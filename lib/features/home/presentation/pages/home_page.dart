import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/text_utils.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_state_x.dart';
import '../../../projects/domain/entities/projects_entity.dart';
import '../../../projects/presentation/bloc/projects_bloc.dart';
import '../../../projects/presentation/bloc/projects_event.dart';
import '../../../projects/presentation/bloc/projects_state.dart';
import '../../../projects/presentation/project_filter.dart';
import '../../../projects/presentation/widgets/project_card.dart';
import '../../../projects/presentation/widgets/project_chips.dart';

/// Body only: the shell supplies the Scaffold, top bar and bottom navigation.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final auth = context.watch<AuthBloc>().state;
    final isCustomer = auth.isCustomer;
    final name = auth is AuthAuthenticated && isCustomer && (auth.user.name ?? '').isNotEmpty
        ? toTitleCase(auth.user.name!)
        : null;

    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        if (state is ProjectsLoading || state is ProjectsInitial) {
          return const LoadingWidget();
        }
        if (state is ProjectsError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () =>
                context.read<ProjectsBloc>().add(const ProjectsLoadRequested()),
          );
        }
        if (state is! ProjectsLoaded) return const SizedBox.shrink();

        final projects = state.projects;
        final featured = projects.featured.take(5).toList();
        final cities = projects.cityCounts;
        final types = projects.typeCounts;

        return RefreshIndicator(
          onRefresh: () {
            final completer = Completer<void>();
            context
                .read<ProjectsBloc>()
                .add(ProjectsLoadRequested(completer: completer));
            return completer.future;
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: AppSizes.xl),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name != null ? 'Hello, $name' : 'Welcome',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.headlineLarge,
                    ),
                    const SizedBox(height: 2),
                    Text('Find your next home with GHR', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),

              if (featured.isNotEmpty) ...[
                _SectionHeader(
                  title: 'Featured Projects',
                  action: 'See all',
                  onAction: () => context.push(RouteNames.projects),
                ),
                _FeaturedCarousel(projects: featured),
              ],

              if (cities.isNotEmpty) ...[
                const _SectionHeader(title: 'Top Locations'),
                SizedBox(
                  height: 78,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                    itemCount: cities.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
                    itemBuilder: (context, i) => _LocationChip(
                      option: cities[i],
                      onTap: () => context
                          .push(RouteNames.projectsFiltered(city: cities[i].label)),
                    ),
                  ),
                ),
              ],

              if (types.isNotEmpty) ...[
                const _SectionHeader(title: 'Explore by Type'),
                SizedBox(
                  height: 96,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                    itemCount: types.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
                    itemBuilder: (context, i) => _TypeTile(
                      option: types[i],
                      onTap: () => context
                          .push(RouteNames.projectsFiltered(type: types[i].label)),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppSizes.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                child: OutlinedButton.icon(
                  onPressed: () => context.push(RouteNames.projects),
                  icon: const Icon(Icons.grid_view_rounded, size: 18),
                  label: Text('BROWSE ALL ${projects.length} PROJECTS'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const _SectionHeader({required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.lg, AppSizes.lg, AppSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          if (action != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(action!),
            ),
        ],
      ),
    );
  }
}

class _FeaturedCarousel extends StatefulWidget {
  final List<ProjectEntity> projects;
  const _FeaturedCarousel({required this.projects});

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final _controller = PageController(viewportFraction: 0.9);
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.projects.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => FeaturedProjectCard(
              project: widget.projects[i],
              onTap: () =>
                  context.push(RouteNames.projectDetail(widget.projects[i].id)),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.projects.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _page == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _page == i ? AppColors.primary : AppColors.grey300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationChip extends StatelessWidget {
  final OptionCount option;
  final VoidCallback onTap;
  const _LocationChip({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: AppSizes.sm),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.label, style: AppTextStyles.labelLarge.copyWith(fontSize: 13)),
                  Text('${option.count} project${option.count == 1 ? '' : 's'}',
                      style: AppTextStyles.caption),
                ],
              ),
              const SizedBox(width: AppSizes.xs),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeTile extends StatelessWidget {
  final OptionCount option;
  final VoidCallback onTap;
  const _TypeTile({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        onTap: onTap,
        child: SizedBox(
          width: 132,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.sm + 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(projectTypeIcon(option.label), color: AppColors.primary, size: 26),
                const Spacer(),
                Text(option.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelLarge.copyWith(fontSize: 12)),
                Text('${option.count}', style: AppTextStyles.caption),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
