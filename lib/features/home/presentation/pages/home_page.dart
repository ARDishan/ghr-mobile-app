import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../projects/presentation/bloc/projects_bloc.dart';
import '../../../projects/presentation/bloc/projects_state.dart';
import '../../../projects/presentation/widgets/project_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final authState = context.watch<AuthBloc>().state;
    final userName = authState is AuthAuthenticated
        ? (authState.user.name ?? 'Guest')
        : 'Guest';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSizes.pagePadding,
                child: Text('Hello, $userName', style: AppTextStyles.headlineLarge),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Featured Projects', style: AppTextStyles.sectionTitle),
                    TextButton(
                      onPressed: () => context.push(RouteNames.projects),
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<ProjectsBloc, ProjectsState>(
              builder: (context, state) {
                if (state is ProjectsLoading || state is ProjectsInitial) {
                  return const SliverToBoxAdapter(child: LoadingWidget());
                }
                if (state is ProjectsError) {
                  return SliverToBoxAdapter(child: AppErrorWidget(message: state.message));
                }
                if (state is ProjectsLoaded) {
                  final featured = state.projects.take(5).toList();
                  if (featured.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: AppSizes.pagePadding,
                        child: Text('No projects available right now.'),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: AppSizes.pagePadding,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProjectCard(
                          project: featured[index],
                          onTap: () => context.push(
                            RouteNames.projectDetail(featured[index].id),
                          ),
                        ),
                        childCount: featured.length,
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            // TODO: Top Locations / Property Types sections need a schema
            // decision (e.g. a city/category column) before they can be
            // built against real data — see Phase 4 follow-up.
          ],
        ),
      ),
    );
  }
}