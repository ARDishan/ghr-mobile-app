import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';

class ProjectDetailPage extends StatefulWidget {
  final String projectId;
  const ProjectDetailPage({super.key, required this.projectId});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectsBloc>().add(ProjectDetailLoadRequested(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectDetailLoading) {
            return const LoadingWidget();
          }
          if (state is ProjectsError) {
            return AppErrorWidget(message: state.message);
          }
          if (state is ProjectDetailLoaded) {
            final project = state.project;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 220,
                  backgroundColor: AppColors.primary,
                  flexibleSpace: FlexibleSpaceBar(
                    background: project.imageUrls.isNotEmpty
                        ? Image.network(project.imageUrls.first, fit: BoxFit.cover)
                        : Container(color: AppColors.primary),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: AppSizes.pagePadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(project.displayTitle, style: AppTextStyles.displaySmall),
                        if (project.type != null) ...[
                          const SizedBox(height: AppSizes.xs),
                          Text(project.type!, style: AppTextStyles.bodyMedium),
                        ],
                        if (project.address != null) ...[
                          const SizedBox(height: AppSizes.md),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: AppColors.grey500, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(project.address!, style: AppTextStyles.bodyMedium),
                              ),
                            ],
                          ),
                        ],
                        if (project.startDate != null || project.endDate != null) ...[
                          const SizedBox(height: AppSizes.md),
                          const Divider(color: AppColors.divider),
                          const SizedBox(height: AppSizes.sm),
                          if (project.startDate != null)
                            Text(
                              'Start: ${project.startDate!.toLocal().toString().split(' ').first}',
                              style: AppTextStyles.bodySmall,
                            ),
                          if (project.endDate != null)
                            Text(
                              'Estimated Completion: ${project.endDate!.toLocal().toString().split(' ').first}',
                              style: AppTextStyles.bodySmall,
                            ),
                        ],
                        // TODO: unit/property listing for this project belongs
                        // to Phase 5 (Units) once that schema is confirmed.
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}