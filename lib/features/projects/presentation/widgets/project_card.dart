import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../bookmarks/presentation/cubit/bookmarks_cubit.dart';
import '../../domain/entities/projects_entity.dart';

class ProjectCard extends StatelessWidget {
  final ProjectEntity project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final coverImage = project.imageUrls.isNotEmpty ? project.imageUrls.first : null;
    final isSaved = context.watch<BookmarksCubit>().state.contains(project.id);

    Widget placeholder() => Container(
          height: 140,
          color: AppColors.grey200,
          child: const Center(
            child: Icon(Icons.apartment_rounded, color: AppColors.grey400, size: 40),
          ),
        );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                if (coverImage != null)
                  Image.network(
                    coverImage,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => placeholder(),
                  )
                else
                  SizedBox(width: double.infinity, child: placeholder()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: AppColors.white.withOpacity(0.9),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () =>
                          context.read<BookmarksCubit>().toggle(project.id),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          size: 20,
                          color: isSaved ? AppColors.primary : AppColors.grey600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.displayTitle, style: AppTextStyles.headlineSmall),
                  if (project.type != null) ...[
                    const SizedBox(height: 2),
                    Text(project.type!, style: AppTextStyles.bodySmall),
                  ],
                  if (project.address != null) ...[
                    const SizedBox(height: 4),
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