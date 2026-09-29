import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class PhoneEntryPage extends StatefulWidget {
  const PhoneEntryPage({super.key});

  @override
  State<PhoneEntryPage> createState() => _PhoneEntryPageState();
}

class _PhoneEntryPageState extends State<PhoneEntryPage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final e164 = PhoneFormatter.toE164(_phoneController.text.trim());
    context.read<AuthBloc>().add(AuthPhoneSubmitted(e164));
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthOtpSent) {
              context.push(RouteNames.otpVerification, extra: state.phone);
            } else if (state is AuthCustomerNotFound) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'This mobile number is not registered with GHR. '
                    'Please contact us if you believe this is a mistake.',
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
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
                  Text('Welcome Back', style: AppTextStyles.displaySmall),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    'Enter your registered mobile number to continue',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: AppSizes.xl),
                  AppTextField(
                    label: 'Mobile Number',
                    controller: _phoneController,
                  ),
                  const SizedBox(height: AppSizes.xl),
                  AppButton(
                    label: 'SEND OTP',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _submit(context),
                  ),
                  const SizedBox(height: AppSizes.md),
                  AppButton(
                    label: 'CONTINUE AS GUEST',
                    style: AppButtonStyle.outline,
                    onPressed: isLoading
                        ? null
                        : () => context
                            .read<AuthBloc>()
                            .add(const AuthContinueAsGuestRequested()),
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