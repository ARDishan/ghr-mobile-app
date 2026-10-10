import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum Brand { ghr, ced }

/// The brand logo on a white rounded tile, so it stays readable on any background.
/// GHR is the main brand; CED (Corals Edge) is used only where a CED context applies.
class BrandLogo extends StatelessWidget {
  final Brand brand;
  final double size;

  const BrandLogo({super.key, this.brand = Brand.ghr, this.size = 44});

  @override
  Widget build(BuildContext context) {
    final asset = brand == Brand.ced ? AssetConstants.cedLogo : AssetConstants.ghrLogo;
    final fallback = brand == Brand.ced ? 'CED' : 'GHR';
    final padding = size * 0.16;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(size * 0.26),
      ),
      child: SvgPicture.asset(
        asset,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => const SizedBox.shrink(),
        errorBuilder: (_, __, ___) => Center(
          child: Text(
            fallback,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.primary,
              fontSize: size * 0.28,
            ),
          ),
        ),
      ),
    );
  }
}