import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_header.dart';

class PhoneEntryPage extends StatefulWidget {
  const PhoneEntryPage({super.key});

  @override
  State<PhoneEntryPage> createState() => _PhoneEntryPageState();
}

class _PhoneEntryPageState extends State<PhoneEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    final e164 = PhoneFormatter.toE164(_phoneController.text);
    context.read<AuthBloc>().add(AuthPhoneSubmitted(e164));
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<AuthBloc, AuthState>(
          // Only react while this page is the visible one (the OTP page keeps
          // this page mounted underneath it).
          listenWhen: (previous, current) =>
              ModalRoute.of(context)?.isCurrent ?? false,
          listener: (context, state) {
            if (state is AuthOtpSent) {
              context.push(RouteNames.otpVerification, extra: state.phone);
            } else if (state is AuthCustomerNotFound) {
              _showError(
                context,
                'This mobile number is not registered with GHR. '
                'Please contact us if you believe this is a mistake.',
              );
            } else if (state is AuthFailureState) {
              _showError(context, state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.lg),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome Back', style: AppTextStyles.displaySmall),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            'Enter your registered mobile number and we will '
                            'send you a verification code.',
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: AppSizes.xl),
                          AppTextField(
                            label: 'Mobile Number',
                            hint: '07X XXX XXXX',
                            helperText: 'Formats like 0712345678 or +94 71 234 5678 both work.',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            enabled: !isLoading,
                            autofillHints: const [AutofillHints.telephoneNumber],
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-()]')),
                              LengthLimitingTextInputFormatter(20),
                            ],
                            prefixIcon: const Icon(Icons.phone_outlined,
                                color: AppColors.grey500, size: AppSizes.iconSm),
                            validator: Validators.phone,
                            onSubmitted: (_) => _submit(context),
                          ),
                          const SizedBox(height: AppSizes.xl),
                          AppButton(
                            label: 'SEND CODE',
                            isLoading: isLoading,
                            onPressed: () => _submit(context),
                          ),
                          const SizedBox(height: AppSizes.md),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                                child: Text('OR',
                                    style: AppTextStyles.labelSmall
                                        .copyWith(color: AppColors.grey400)),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: AppSizes.md),
                          AppButton(
                            label: 'CONTINUE AS GUEST',
                            style: AppButtonStyle.outline,
                            prefixIcon: const Icon(Icons.person_outline_rounded,
                                color: AppColors.primary, size: 18),
                            onPressed: isLoading
                                ? null
                                : () => context
                                    .read<AuthBloc>()
                                    .add(const AuthContinueAsGuestRequested()),
                          ),
                          const SizedBox(height: AppSizes.lg),
                          Center(
                            child: Text(
                              'Guests can browse projects. Log in to see your units and payments.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.caption,
                            ),
                          ),
                        ],
                      ),
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