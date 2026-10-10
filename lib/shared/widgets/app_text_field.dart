import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_sizes.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final bool autofocus;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.autofillHints,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.autofocus = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.xs + 2),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
          inputFormatters: widget.inputFormatters,
          autofillHints: widget.autofillHints,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          autofocus: widget.autofocus,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: widget.hint ?? widget.label,
            helperText: widget.helperText,
            helperMaxLines: 2,
            helperStyle: AppTextStyles.caption,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: widget.prefixIcon,
                  )
                : null,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 48, minHeight: 48),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.grey500,
                      size: AppSizes.iconSm,
                    ),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}