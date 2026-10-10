import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../injection_container.dart' as di;
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../bookmarks/presentation/cubit/bookmarks_cubit.dart';
import '../../../units/domain/entities/unit_entity.dart';
import '../../../units/presentation/bloc/units_bloc.dart';
import '../../../units/presentation/bloc/units_event.dart';
import '../../../units/presentation/bloc/units_state.dart';
import '../../../units/presentation/pages/units_list_page.dart';
import '../../../units/presentation/widgets/unit_list_item.dart';
import '../../domain/entities/projects_entity.dart';
import '../bloc/project_detail_bloc.dart';
import '../bloc/project_detail_event.dart';
import '../bloc/project_detail_state.dart';
import '../widgets/project_chips.dart';

/// Expects a ProjectDetailBloc above it (provided by the route, which also
/// dispatches the initial ProjectDetailLoadRequested).
class ProjectDetailPage extends StatelessWidget {
  final String projectId;
  const ProjectDetailPage({super.key, required this.projectId});

  static final DateFormat _date = DateFormat('d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return BlocBuilder<ProjectDetailBloc, ProjectDetailState>(
      builder: (context, state) {
        if (state is ProjectDetailError) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(),
            body: AppErrorWidget(
              message: state.message,
              onRetry: () => context
                  .read<ProjectDetailBloc>()
                  .add(ProjectDetailLoadRequested(projectId)),
            ),
          );
        }
        if (state is! ProjectDetailLoaded) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(),
            body: const LoadingWidget(),
          );
        }

        final project = state.project;
        final isSaved = context.watch<BookmarksCubit>().state.contains(project.id);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 270,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                actions: [
                  IconButton(
                    tooltip: isSaved ? 'Remove from saved' : 'Save project',
                    onPressed: () => context.read<BookmarksCubit>().toggle(project.id),
                    icon: Icon(isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _Gallery(images: project.imageUrls, type: project.type),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSizes.pagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.displayTitle, style: AppTextStyles.displaySmall),
                      const SizedBox(height: AppSizes.sm),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          StatusPill(project: project),
                          if (project.typeLabel != null)
                            Pill(label: project.typeLabel!, icon: projectTypeIcon(project.type)),
                          if (project.cityLabel != null)
                            Pill(
                              label: project.cityLabel!,
                              icon: Icons.location_on_outlined,
                              color: AppColors.info,
                            ),
                          if (!project.isMainBranch && project.branchLabel != null)
                            BranchTag(label: project.branchLabel!),
                        ],
                      ),
                      if (project.address != null && project.address!.trim().isNotEmpty) ...[
                        const SizedBox(height: AppSizes.lg),
                        _InfoCard(
                          icon: Icons.location_on_outlined,
                          title: 'Address',
                          value: project.address!,
                          trailing: IconButton(
                            tooltip: 'Open in maps',
                            icon: const Icon(Icons.directions_rounded, color: AppColors.primary),
                            onPressed: () => LinkLauncher.map(
                              context,
                              [project.displayTitle, project.address!].join(', '),
                            ),
                          ),
                        ),
                      ],
                      if (project.startDate != null || project.endDate != null) ...[
                        const SizedBox(height: AppSizes.sm),
                        Row(
                          children: [
                            if (project.startDate != null)
                              Expanded(
                                child: _InfoCard(
                                  icon: Icons.play_circle_outline_rounded,
                                  title: 'Started',
                                  value: _date.format(project.startDate!.toLocal()),
                                ),
                              ),
                            if (project.startDate != null && project.endDate != null)
                              const SizedBox(width: AppSizes.sm),
                            if (project.endDate != null)
                              Expanded(
                                child: _InfoCard(
                                  icon: Icons.flag_outlined,
                                  title: project.isCompleted ? 'Completed' : 'Est. completion',
                                  value: _date.format(project.endDate!.toLocal()),
                                ),
                              ),
                          ],
                        ),
                      ],
                      if (project.projectBasicId != null) ...[
                        const SizedBox(height: AppSizes.lg),
                        BlocProvider<UnitsBloc>(
                          create: (_) => di.sl<UnitsBloc>()
                            ..add(UnitsLoadRequested(project.projectBasicId!)),
                          child: _UnitsSection(project: project),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UnitsSection extends StatelessWidget {
  final ProjectEntity project;
  const _UnitsSection({required this.project});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitsBloc, UnitsState>(
      builder: (context, state) {
        if (state is UnitsLoading || state is UnitsInitial) return const LoadingWidget();
        if (state is UnitsError) return AppErrorWidget(message: state.message);
        if (state is! UnitsLoaded) return const SizedBox.shrink();

        final units = state.units;
        if (units.isEmpty) {
          return Text('No units listed yet.', style: AppTextStyles.bodyMedium);
        }
        int count(bool Function(UnitEntity) test) => units.where(test).length;
        final available = count((u) => u.isAvailable);
        final reserved = count((u) => (u.status ?? '').toUpperCase() == 'RESERVED');
        final sold = count((u) {
          final s = (u.status ?? '').toUpperCase();
          return s == 'SOLD' || s == 'TRANSFERRED';
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Units', style: AppTextStyles.sectionTitle),
                TextButton(
                  onPressed: () => context.push(
                    RouteNames.units,
                    extra: UnitsListPageArgs(
                      projectBasicId: project.projectBasicId!,
                      projectTitle: project.displayTitle,
                    ),
                  ),
                  child: const Text('View all'),
                ),
              ],
            ),
            Row(
              children: [
                _Stat(label: 'Available', value: available, color: AppColors.success),
                const SizedBox(width: AppSizes.sm),
                _Stat(label: 'Reserved', value: reserved, color: AppColors.warning),
                const SizedBox(width: AppSizes.sm),
                _Stat(label: 'Sold', value: sold, color: AppColors.error),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            // Preview: up to 3 available units, or the first 3 if none are available.
            for (final unit in (units.any((u) => u.isAvailable)
                    ? units.where((u) => u.isAvailable)
                    : units)
                .take(3))
              UnitListItem(unit: unit),
          ],
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          children: [
            Text('$value',
                style: AppTextStyles.headlineMedium.copyWith(color: color)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Widget? trailing;
  const _InfoCard({required this.icon, required this.title, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: AppSizes.sm + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.caption),
                Text(value, style: AppTextStyles.bodyLarge.copyWith(fontSize: 14)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _Gallery extends StatefulWidget {
  final List<String> images;
  final String? type;
  const _Gallery({required this.images, required this.type});

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  int _page = 0;

  Widget _placeholder() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primarySoft],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Icon(projectTypeIcon(widget.type),
              size: 64, color: AppColors.white.withValues(alpha: 0.5)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return _placeholder();

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: widget.images.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (context, i) => Image.network(
            widget.images[i],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder(),
          ),
        ),
        if (widget.images.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _page == i ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _page == i ? AppColors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
