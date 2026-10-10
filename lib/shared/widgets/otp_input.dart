import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// One-time-code input shown as separate boxes. A single invisible text field
/// does the typing, so paste and SMS autofill (iOS/Android) work naturally.
class OtpInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final int length;
  final bool hasError;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  const OtpInput({
    super.key,
    required this.controller,
    this.focusNode,
    this.length = AppConstants.otpLength,
    this.hasError = false,
    this.enabled = true,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final FocusNode _focus = widget.focusNode ?? FocusNode();
  String _lastCompleted = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focus.addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _onTextChanged() {
    final text = widget.controller.text;
    widget.onChanged?.call(text);
    if (text.length == widget.length && text != _lastCompleted) {
      _lastCompleted = text;
      widget.onCompleted?.call(text);
    }
    if (text.length < widget.length) _lastCompleted = '';
    _rebuild();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focus.removeListener(_rebuild);
    if (widget.focusNode == null) _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;
    final activeIndex = text.length.clamp(0, widget.length - 1);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.enabled ? () => _focus.requestFocus() : null,
      child: SizedBox(
        height: 60,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < widget.length; i++)
                  _Box(
                    char: i < text.length ? text[i] : '',
                    isActive: _focus.hasFocus && i == activeIndex,
                    hasError: widget.hasError,
                  ),
              ],
            ),
            Positioned.fill(
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                enabled: widget.enabled,
                autofocus: true,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                maxLength: widget.length,
                enableInteractiveSelection: false,
                showCursor: false,
                cursorColor: Colors.transparent,
                style: const TextStyle(color: Colors.transparent),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  filled: false,
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final String char;
  final bool isActive;
  final bool hasError;
  const _Box({required this.char, required this.isActive, required this.hasError});

  @override
  Widget build(BuildContext context) {
    final Color border = hasError
        ? AppColors.error
        : isActive
            ? AppColors.primary
            : char.isNotEmpty
                ? AppColors.primaryLight
                : AppColors.inputBorder;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 46,
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: isActive || hasError ? 2 : 1.2),
      ),
      child: Text(
        char,
        style: AppTextStyles.headlineLarge.copyWith(
          color: hasError ? AppColors.error : AppColors.textPrimary,
        ),
      ),
    );
  }
}