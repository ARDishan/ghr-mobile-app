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
import '../../../../core/utils/phone_formatter.dart';
import '../../../../shared/widgets/login_required_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_state_x.dart';
import '../../../bookmarks/presentation/cubit/bookmarks_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _clearSaved(BuildContext context) async {
    final cubit = context.read<BookmarksCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Clear saved projects?'),
        content: const Text('This removes all bookmarks on this device.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(d).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(d).pop(true), child: const Text('Clear')),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.clear();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Saved projects cleared')));
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final auth = context.watch<AuthBloc>().state;
    final isCustomer = auth.isCustomer;
    final user = auth is AuthAuthenticated ? auth.user : null;
    final savedCount = context.watch<BookmarksCubit>().state.ids.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Settings', style: AppTextStyles.headlineMedium)),
      body: ListView(
        padding: AppSizes.pagePadding,
        children: [
          _Group(title: 'Account', children: [
            if (isCustomer) ...[
              _Tile(
                icon: Icons.phone_outlined,
                title: 'Signed in as',
                subtitle: PhoneFormatter.pretty(PhoneFormatter.toE164(user?.phone ?? '')),
              ),
              _Tile(
                icon: Icons.logout_rounded,
                iconColor: AppColors.error,
                title: 'Log out',
                onTap: () => confirmLogout(context),
              ),
            ] else
              _Tile(
                icon: Icons.login_rounded,
                title: 'Log in',
                subtitle: 'You are browsing as a guest',
                onTap: () => context.read<AuthBloc>().add(const AuthLogoutRequested()),
              ),
          ]),
          _Group(title: 'Notifications', children: [
            const _Tile(
              icon: Icons.sms_outlined,
              title: 'How you are notified',
              subtitle: 'Payment schedules, reminders and announcements are sent '
                  'to your registered mobile by SMS and also appear in the app.',
            ),
          ]),
          _Group(title: 'Data on this device', children: [
            _Tile(
              icon: Icons.bookmark_remove_outlined,
              title: 'Clear saved projects',
              subtitle: savedCount == 0
                  ? 'Nothing saved'
                  : '$savedCount saved project${savedCount == 1 ? '' : 's'}',
              onTap: savedCount == 0 ? null : () => _clearSaved(context),
            ),
          ]),
          _Group(title: 'Support', children: [
            _Tile(
              icon: Icons.phone_in_talk_outlined,
              title: 'Call sales hotline',
              subtitle: AppConstants.salesHotlineDisplay,
              onTap: () => LinkLauncher.call(context, AppConstants.salesHotlineRaw),
            ),
            _Tile(
              icon: Icons.email_outlined,
              title: 'Email us',
              subtitle: AppConstants.contactEmail,
              onTap: () => LinkLauncher.email(context, AppConstants.contactEmail),
            ),
            _Tile(
              icon: Icons.info_outline_rounded,
              title: 'About GHR',
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(RouteNames.about),
            ),
          ]),
          _Group(title: 'Legal', children: [
            _Tile(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              trailing: const Icon(Icons.open_in_new_rounded, size: 18),
              onTap: () => LinkLauncher.openUrl(context, AppConstants.termsUrl),
            ),
            _Tile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              trailing: const Icon(Icons.open_in_new_rounded, size: 18),
              onTap: () => LinkLauncher.openUrl(context, AppConstants.privacyUrl),
            ),
          ]),
          const SizedBox(height: AppSizes.sm),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) {
              final info = snap.data;
              return Column(
                children: [
                  Text('Global Housing & Real Estate', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 2),
                  Text(
                    info == null ? '' : 'Version ${info.version} (${info.buildNumber})',
                    style: AppTextStyles.caption,
                  ),
                ],
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
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i != children.length - 1) const Divider(indent: 56),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _Tile({
    required this.icon,
    required this.title,
    this.iconColor = AppColors.primary,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(fontSize: 15)),
      subtitle: subtitle == null ? null : Text(subtitle!, style: AppTextStyles.caption),
      trailing: trailing,
      onTap: onTap,
    );
  }
}