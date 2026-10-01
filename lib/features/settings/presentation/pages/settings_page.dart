import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../shared/widgets/login_required_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_state_x.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final auth = context.watch<AuthBloc>().state;
    final isCustomer = auth.isCustomer;
    final user = auth is AuthAuthenticated ? auth.user : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Settings', style: AppTextStyles.headlineMedium)),
      body: ListView(
        padding: AppSizes.pagePadding,
        children: [
          _Group(title: 'Account', children: [
            if (isCustomer) ...[
              ListTile(
                leading: const Icon(Icons.phone_outlined, color: AppColors.primary),
                title: const Text('Signed in as'),
                subtitle: Text(user?.phone ?? ''),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                title: const Text('Log out'),
                onTap: () => confirmLogout(context),
              ),
            ] else
              ListTile(
                leading: const Icon(Icons.login_rounded, color: AppColors.primary),
                title: const Text('Log in'),
                subtitle: const Text('You are browsing as a guest'),
                onTap: () =>
                    context.read<AuthBloc>().add(const AuthLogoutRequested()),
              ),
          ]),
          _Group(title: 'Support', children: [
            ListTile(
              leading: const Icon(Icons.support_agent_rounded, color: AppColors.primary),
              title: const Text('Contact us'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(RouteNames.about),
            ),
          ]),
          _Group(title: 'Legal', children: [
            ListTile(
              leading: const Icon(Icons.description_outlined, color: AppColors.primary),
              title: const Text('Terms & Conditions'),
              trailing: const Icon(Icons.open_in_new_rounded, size: 18),
              onTap: () => LinkLauncher.openUrl(context, AppConstants.termsUrl),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.open_in_new_rounded, size: 18),
              onTap: () => LinkLauncher.openUrl(context, AppConstants.privacyUrl),
            ),
          ]),
          const SizedBox(height: AppSizes.sm),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) {
              final info = snap.data;
              return Center(
                child: Text(
                  info == null ? '' : 'Version ${info.version} (${info.buildNumber})',
                  style: AppTextStyles.caption,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Group({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: AppSizes.sm),
            child: Text(title.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1.2)),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}