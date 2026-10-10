import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../shared/widgets/brand_logo.dart';

/// Blue gradient header with the GHR logo, used by the login screens.
class AuthHeader extends StatelessWidget {
  final bool showBack;
  const AuthHeader({super.key, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        Container(
          height: 210 + top,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryLight, AppColors.primarySoft],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -30,
                child: _Circle(size: 150, alpha: 0.08),
              ),
              Positioned(
                bottom: 10,
                left: -30,
                child: _Circle(size: 110, alpha: 0.06),
              ),
              if (showBack)
                Positioned(
                  top: top + 6,
                  left: 6,
                  child: IconButton(
                    tooltip: 'Back',
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white, size: 20),
                    onPressed: () => context.pop(),
                  ),
                ),
              Positioned(
                left: AppSizes.lg,
                bottom: 44,
                child: Row(
                  children: [
                    const BrandLogo(size: 48),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Global Housing',
                            style: AppTextStyles.headlineMedium
                                .copyWith(color: AppColors.white)),
                        Text('& Real Estate',
                            style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.white.withValues(alpha: 0.8))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final double alpha;
  const _Circle({required this.size, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}