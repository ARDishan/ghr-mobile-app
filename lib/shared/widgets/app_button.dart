import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_sizes.dart';

/// Carried over from the previous project structure.
/// TODO: review as the redesign progresses.
enum AppButtonStyle { primary, secondary, outline, ghost, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: port full implementation from previous app_button.dart.
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: Text(label, style: AppTextStyles.buttonLarge),
    );
  }
}
