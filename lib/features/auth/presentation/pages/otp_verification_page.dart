import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/otp_input.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_header.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phone;
  const OtpVerificationPage({super.key, required this.phone});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  final _otpFocus = FocusNode();
  Timer? _timer;
  int _seconds = AppConstants.resendSeconds;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_seconds <= 1) {
        t.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  void _submit(String code) {
    if (code.length != AppConstants.otpLength) return;
    final bloc = context.read<AuthBloc>();
    if (bloc.state is AuthLoading) return;
    FocusScope.of(context).unfocus();
    bloc.add(AuthOtpSubmitted(phone: widget.phone, otp: code));
  }

  void _resend() {
    context.read<AuthBloc>().add(AuthResendOtpRequested(widget.phone));
    setState(() {
      _seconds = AppConstants.resendSeconds;
      _hasError = false;
    });
    _otpController.clear();
    _startTimer();
    _otpFocus.requestFocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('A new code is on its way.')));
  }

  String _friendly(String message) {
    final m = message.toLowerCase();
    if (m.contains('expired') || m.contains('invalid')) {
      return 'That code is incorrect or has expired. Please try again.';
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go(RouteNames.home);
            } else if (state is AuthFailureState) {
              setState(() => _hasError = true);
              _otpController.clear();
              _otpFocus.requestFocus();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(_friendly(state.message)),
                  backgroundColor: AppColors.error,
                ));
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(showBack: true),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Verify your number', style: AppTextStyles.displaySmall),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          'Enter the ${AppConstants.otpLength}-digit code sent to',
                          style: AppTextStyles.bodyMedium,
                        ),
                        Row(
                          children: [
                            Text(
                              PhoneFormatter.pretty(widget.phone),
                              style: AppTextStyles.bodyLarge
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              onPressed: isLoading ? null : () => context.pop(),
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('Change'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.xl),
                        OtpInput(
                          controller: _otpController,
                          focusNode: _otpFocus,
                          hasError: _hasError,
                          enabled: !isLoading,
                          onChanged: (_) {
                            if (_hasError) setState(() => _hasError = false);
                          },
                          onCompleted: _submit,
                        ),
                        const SizedBox(height: AppSizes.xl),
                        AppButton(
                          label: 'VERIFY',
                          isLoading: isLoading,
                          onPressed: _otpController.text.length == AppConstants.otpLength
                              ? () => _submit(_otpController.text)
                              : null,
                        ),
                        const SizedBox(height: AppSizes.md),
                        Center(
                          child: TextButton(
                            onPressed: (_seconds == 0 && !isLoading) ? _resend : null,
                            child: Text(
                              _seconds > 0
                                  ? 'Resend code in ${_seconds}s'
                                  : 'Resend code',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}