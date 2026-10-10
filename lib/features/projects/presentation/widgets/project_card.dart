import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../bookmarks/presentation/cubit/bookmarks_cubit.dart';
import '../../domain/entities/projects_entity.dart';
import 'project_chips.dart';

/// Cover image (or a branded placeholder) with a gradient, used by both cards.
class ProjectCover extends StatelessWidget {
  final ProjectEntity project;
  final double height;
  const ProjectCover({super.key, required this.project, required this.height});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primarySoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(projectTypeIcon(project.type),
          size: 44, color: AppColors.white.withValues(alpha: 0.5)),
    );

    if (project.imageUrls.isEmpty) return placeholder;
    return Image.network(
      project.imageUrls.first,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}

class BookmarkButton extends StatelessWidget {
  final String projectId;
  const BookmarkButton({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final isSaved = context.watch<BookmarksCubit>().state.contains(projectId);
    return Material(
      color: AppColors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => context.read<BookmarksCubit>().toggle(projectId),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
            size: 20,
            color: isSaved ? AppColors.primary : AppColors.grey600,
          ),
        ),
      ),
    );
  }
}

/// List card: cover on top, details below.
class ProjectCard extends StatelessWidget {
  final ProjectEntity project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final subtitle = [project.typeLabel, project.cityLabel]
        .whereType<String>()
        .join(' · ');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ProjectCover(project: project, height: 160),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Wrap(
                    spacing: 6,
                    children: [
                      StatusPill(project: project, solid: true),
                      if (!project.isMainBranch && project.branchLabel != null)
                        BranchTag(label: project.branchLabel!, solid: true),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: BookmarkButton(projectId: project.id),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.displayTitle, style: AppTextStyles.headlineSmall),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.bodySmall),
                  ],
                  if (project.address != null && project.address!.trim().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 14, color: AppColors.grey400),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            project.address!,
                            style: AppTextStyles.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carousel card for Home: full-bleed image with text over a gradient.
class FeaturedProjectCard extends StatelessWidget {
  final ProjectEntity project;
  final VoidCallback onTap;
  const FeaturedProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ProjectCover(project: project, height: 220),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                  stops: [0.35, 1],
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Wrap(
                spacing: 6,
                children: [
                  StatusPill(project: project, solid: true),
                  if (!project.isMainBranch && project.branchLabel != null)
                    BranchTag(label: project.branchLabel!, solid: true),
                ],
              ),
            ),
            Positioned(top: 8, right: 8, child: BookmarkButton(projectId: project.id)),
            Positioned(
              left: AppSizes.md,
              right: AppSizes.md,
              bottom: AppSizes.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 14, color: Colors.white70),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          [project.cityLabel, project.typeLabel]
                              .whereType<String>()
                              .join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
