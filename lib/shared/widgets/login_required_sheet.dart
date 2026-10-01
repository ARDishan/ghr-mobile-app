import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_sizes.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import 'app_button.dart';

/// Shown when a guest taps something that needs a customer account.
/// "Log in" ends the guest session; the router then sends them to phone entry.
Future<void> showLoginRequiredSheet(BuildContext context) {
  final authBloc = context.read<AuthBloc>();
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
    ),
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log in to continue', style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppSizes.xs),
          Text(
            'This section is available to GHR customers. Log in with your '
            'registered mobile number to see it.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSizes.lg),
          AppButton(
            label: 'LOG IN',
            onPressed: () {
              Navigator.of(sheetContext).pop();
              authBloc.add(const AuthLogoutRequested());
            },
          ),
          const SizedBox(height: AppSizes.sm),
        ],
      ),
    ),
  );
}

Future<void> confirmLogout(BuildContext context) async {
  final authBloc = context.read<AuthBloc>();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Log out?'),
      content: const Text('You will need your mobile number and an OTP to log in again.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Log out'),
        ),
      ],
    ),
  );
  if (confirmed == true) {
    authBloc.add(const AuthLogoutRequested());
  }
}