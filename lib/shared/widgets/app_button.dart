import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_sizes.dart';

enum AppButtonStyle {
  primary,
  secondary,
  outline,
  ghost,
  danger,
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final bool isLoading;
  final Widget? prefixIcon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle;

    switch (style) {
      case AppButtonStyle.primary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        );
        break;

      case AppButtonStyle.secondary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: AppColors.primary,
        );
        break;

      case AppButtonStyle.outline:
        buttonStyle = OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
        );
        break;

      case AppButtonStyle.ghost:
        buttonStyle = TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        );
        break;

      case AppButtonStyle.danger:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: AppColors.white,
        );
        break;
    }

    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 8),
              ],
              Text(label, style: AppTextStyles.buttonLarge),
            ],
          );

    switch (style) {
      case AppButtonStyle.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );

      case AppButtonStyle.ghost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );

      default:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );
    }
  }
}
