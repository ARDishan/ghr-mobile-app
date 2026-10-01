import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../injection_container.dart' as di;
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../bookmarks/presentation/cubit/bookmarks_cubit.dart';
import '../../../units/presentation/bloc/units_bloc.dart';
import '../../../units/presentation/bloc/units_event.dart';
import '../../../units/presentation/bloc/units_state.dart';
import '../../../units/presentation/pages/units_list_page.dart';
import '../../../units/presentation/widgets/unit_list_item.dart';
import '../bloc/project_detail_bloc.dart';
import '../bloc/project_detail_event.dart';
import '../bloc/project_detail_state.dart';

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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppErrorWidget(message: state.message),
                TextButton(
                  onPressed: () => context
                      .read<ProjectDetailBloc>()
                      .add(ProjectDetailLoadRequested(projectId)),
                  child: const Text('Try again'),
                ),
              ],
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
                expandedHeight: 220,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                actions: [
                  IconButton(
                    tooltip: isSaved ? 'Remove from saved' : 'Save project',
                    onPressed: () =>
                        context.read<BookmarksCubit>().toggle(project.id),
                    icon: Icon(isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: project.imageUrls.isNotEmpty
                      ? Image.network(
                          project.imageUrls.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: AppColors.primary),
                        )
                      : Container(color: AppColors.primary),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSizes.pagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.displayTitle,
                          style: AppTextStyles.displaySmall),
                      if (project.type != null) ...[
                        const SizedBox(height: AppSizes.xs),
                        Text(project.type!, style: AppTextStyles.bodyMedium),
                      ],
                      if (project.address != null) ...[
                        const SizedBox(height: AppSizes.md),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: AppColors.grey500, size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(project.address!,
                                  style: AppTextStyles.bodyMedium),
                            ),
                          ],
                        ),
                      ],
                      if (project.startDate != null || project.endDate != null) ...[
                        const SizedBox(height: AppSizes.md),
                        const Divider(color: AppColors.divider),
                        const SizedBox(height: AppSizes.sm),
                        if (project.startDate != null)
                          Text('Start: ${_date.format(project.startDate!.toLocal())}',
                              style: AppTextStyles.bodySmall),
                        if (project.endDate != null)
                          Text(
                              'Estimated Completion: ${_date.format(project.endDate!.toLocal())}',
                              style: AppTextStyles.bodySmall),
                      ],
                      if (project.projectBasicId != null) ...[
                        const SizedBox(height: AppSizes.lg),
                        const Divider(color: AppColors.divider),
                        const SizedBox(height: AppSizes.sm),
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
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                        BlocProvider<UnitsBloc>(
                          create: (_) => di.sl<UnitsBloc>()
                            ..add(UnitsLoadRequested(project.projectBasicId!)),
                          child: BlocBuilder<UnitsBloc, UnitsState>(
                            builder: (context, unitsState) {
                              if (unitsState is UnitsLoading ||
                                  unitsState is UnitsInitial) {
                                return const LoadingWidget();
                              }
                              if (unitsState is UnitsError) {
                                return AppErrorWidget(message: unitsState.message);
                              }
                              if (unitsState is UnitsLoaded) {
                                if (unitsState.units.isEmpty) {
                                  return const Text('No units listed yet.');
                                }
                                return Column(
                                  children: [
                                    for (final unit
                                        in unitsState.units.take(3))
                                      UnitListItem(unit: unit),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
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