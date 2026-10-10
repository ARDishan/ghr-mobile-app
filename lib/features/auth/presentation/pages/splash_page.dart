import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/brand_logo.dart';

/// Shown only while the stored session is being restored.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, t, child) => Opacity(
            opacity: t,
            child: Transform.scale(scale: 0.9 + 0.1 * t, child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BrandLogo(size: 92),
              const SizedBox(height: 24),
              Text('Global Housing',
                  style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
              const SizedBox(height: 4),
              Text(
                '& REAL ESTATE',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.8),
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: AppColors.primaryAccent, strokeWidth: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}