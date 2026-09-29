import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phone;
  const OtpVerificationPage({super.key, required this.phone});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go(RouteNames.home);
            } else if (state is AuthFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Padding(
              padding: AppSizes.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Verify OTP', style: AppTextStyles.displaySmall),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    'Enter the code sent to ${widget.phone}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: AppSizes.xl),
                  AppTextField(
                    label: 'OTP Code',
                    controller: _otpController,
                  ),
                  const SizedBox(height: AppSizes.xl),
                  AppButton(
                    label: 'VERIFY',
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () => context.read<AuthBloc>().add(
                              AuthOtpSubmitted(
                                phone: widget.phone,
                                otp: _otpController.text.trim(),
                              ),
                            ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => context
                            .read<AuthBloc>()
                            .add(AuthResendOtpRequested(widget.phone)),
                    child: const Text('Resend OTP'),
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