import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_sizes.dart';

enum AppButtonStyle { primary, secondary, outline, ghost, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final double? width;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.width,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius = AppSizes.radiusLg,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final handler = isLoading ? null : onPressed;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    late final Color bg;
    late final Color fg;
    switch (style) {
      case AppButtonStyle.primary:
        bg = backgroundColor ?? AppColors.primary;
        fg = textColor ?? AppColors.white;
      case AppButtonStyle.danger:
        bg = backgroundColor ?? AppColors.error;
        fg = textColor ?? AppColors.white;
      case AppButtonStyle.secondary:
        bg = backgroundColor ?? AppColors.grey200;
        fg = textColor ?? AppColors.textPrimary;
      case AppButtonStyle.outline:
      case AppButtonStyle.ghost:
        bg = Colors.transparent;
        fg = textColor ?? AppColors.primary;
    }

    final content = _ButtonContent(
      label: label,
      isLoading: isLoading,
      color: fg,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );

    final Widget button;
    switch (style) {
      case AppButtonStyle.outline:
        button = OutlinedButton(
          onPressed: handler,
          style: OutlinedButton.styleFrom(
            foregroundColor: fg,
            minimumSize: Size.zero,
            shape: shape,
            side: BorderSide(
              color: onPressed == null && !isLoading ? AppColors.grey300 : fg,
              width: 1.5,
            ),
          ),
          child: content,
        );
      case AppButtonStyle.ghost:
        button = TextButton(
          onPressed: handler,
          style: TextButton.styleFrom(
            foregroundColor: fg,
            minimumSize: Size.zero,
            shape: shape,
          ),
          child: content,
        );
      default:
        button = ElevatedButton(
          onPressed: handler,
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            // Keep the full colour while loading; fade only when truly disabled.
            disabledBackgroundColor:
                isLoading ? bg : bg.withValues(alpha: 0.45),
            disabledForegroundColor: fg.withValues(alpha: 0.8),
            minimumSize: Size.zero,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: shape,
          ),
          child: content,
        );
    }

    return SizedBox(
      height: height ?? AppSizes.buttonHeightLg,
      width: isFullWidth ? double.infinity : width,
      child: button,
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final bool isLoading;
  final Color color;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const _ButtonContent({
    required this.label,
    required this.isLoading,
    required this.color,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(color: color, strokeWidth: 2.5),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          prefixIcon!,
          const SizedBox(width: AppSizes.sm),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.buttonLarge.copyWith(color: color),
          ),
        ),
        if (suffixIcon != null) ...[
          const SizedBox(width: AppSizes.sm),
          suffixIcon!,
        ],
      ],
    );
  }
}