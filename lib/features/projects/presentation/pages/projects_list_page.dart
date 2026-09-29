import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';
import '../widgets/project_card.dart';

class ProjectsListPage extends StatelessWidget {
  const ProjectsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Projects', style: AppTextStyles.headlineMedium)),
      body: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectsLoading || state is ProjectsInitial) {
            return const LoadingWidget();
          }
          if (state is ProjectsError) {
            return AppErrorWidget(message: state.message);
          }
          if (state is ProjectsLoaded) {
            if (state.projects.isEmpty) {
              return const Center(child: Text('No projects available right now.'));
            }
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<ProjectsBloc>().add(const ProjectsLoadRequested()),
              child: ListView.builder(
                padding: AppSizes.pagePadding,
                itemCount: state.projects.length,
                itemBuilder: (context, index) {
                  final project = state.projects[index];
                  return ProjectCard(
                    project: project,
                    onTap: () => context.push(
                      RouteNames.projectDetail(project.id),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}