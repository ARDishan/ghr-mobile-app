import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Shown only while the stored session is being restored.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Global Housing',
              style: AppTextStyles.displaySmall.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 4),
            Text(
              '& Real Estate',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.primaryAccent,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}