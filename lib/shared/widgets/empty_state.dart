import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_sizes.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: AppSizes.md),
            Text(title, textAlign: TextAlign.center, style: AppTextStyles.headlineSmall),
            if (message != null) ...[
              const SizedBox(height: AppSizes.xs),
              Text(message!, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSizes.lg),
              OutlinedButton(
                onPressed: onAction,
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}