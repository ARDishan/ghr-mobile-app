import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../projects/presentation/bloc/projects_bloc.dart';
import '../../../projects/presentation/bloc/projects_state.dart';
import '../../../projects/presentation/widgets/project_card.dart';
import '../cubit/bookmarks_cubit.dart';

/// Body only; the shell provides the Scaffold and top bar.
class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final saved = context.watch<BookmarksCubit>().state;

    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        if (state is ProjectsLoading || state is ProjectsInitial) {
          return const LoadingWidget();
        }
        if (state is ProjectsError) {
          return AppErrorWidget(message: state.message);
        }
        if (state is ProjectsLoaded) {
          final projects =
              state.projects.where((p) => saved.contains(p.id)).toList();
          if (projects.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_outline_rounded,
                        size: 56, color: AppColors.grey400),
                    SizedBox(height: AppSizes.md),
                    Text(
                      'No saved projects yet.\nTap the bookmark on a project to save it here.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: AppSizes.pagePadding,
            itemCount: projects.length,
            itemBuilder: (context, i) => ProjectCard(
              project: projects[i],
              onTap: () => context.push(RouteNames.projectDetail(projects[i].id)),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}