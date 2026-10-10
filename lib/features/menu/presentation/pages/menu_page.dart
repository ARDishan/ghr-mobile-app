import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/utils/text_utils.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/login_required_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_state_x.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final auth = context.watch<AuthBloc>().state;
    final isCustomer = auth.isCustomer;
    final user = auth is AuthAuthenticated ? auth.user : null;

    void open(String route, {required bool customerOnly}) {
      if (customerOnly && !isCustomer) {
        showLoginRequiredSheet(context);
      } else {
        context.push(route);
      }
    }

    final name = isCustomer && (user?.name ?? '').trim().isNotEmpty
        ? toTitleCase(user!.name!)
        : (isCustomer ? 'Customer' : 'Guest');
    final subtitle = isCustomer
        ? PhoneFormatter.pretty(PhoneFormatter.toE164(user?.phone ?? ''))
        : 'Log in to see your units and payments';

    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.xl),
      children: [
        _UserHeader(name: name, subtitle: subtitle, isCustomer: isCustomer),
        const SizedBox(height: AppSizes.lg),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSizes.md,
          crossAxisSpacing: AppSizes.md,
          childAspectRatio: 1.1,
          children: [
            _MenuCard(
              icon: Icons.apartment_rounded,
              title: 'My Unit(s)',
              subtitle: 'Balance & overdue',
              locked: !isCustomer,
              onTap: () => open(RouteNames.myUnits, customerOnly: true),
            ),
            _MenuCard(
              icon: Icons.person_outline_rounded,
              title: 'Profile',
              subtitle: 'Your details',
              locked: !isCustomer,
              onTap: () => open(RouteNames.profile, customerOnly: true),
            ),
            _MenuCard(
              icon: Icons.info_outline_rounded,
              title: 'About',
              subtitle: 'GHR & contact us',
              onTap: () => open(RouteNames.about, customerOnly: false),
            ),
            _MenuCard(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Account & legal',
              onTap: () => open(RouteNames.settings, customerOnly: false),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
        const _HelpCard(),
        const SizedBox(height: AppSizes.xl),
        if (isCustomer)
          AppButton(
            label: 'LOG OUT',
            style: AppButtonStyle.outline,
            prefixIcon: const Icon(Icons.logout_rounded,
                color: AppColors.primary, size: 18),
            onPressed: () => confirmLogout(context),
          )
        else
          AppButton(
            label: 'LOG IN',
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
          ),
      ],
    );
  }
}

class _UserHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isCustomer;
  const _UserHeader({
    required this.name,
    required this.subtitle,
    required this.isCustomer,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';
    return Container(
      padding: const EdgeInsets.all(AppSizes.md + 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.white.withValues(alpha: 0.2),
            child: isCustomer
                ? Text(initial,
                    style: AppTextStyles.headlineMedium.copyWith(color: AppColors.white))
                : const Icon(Icons.person_outline_rounded, color: AppColors.white),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white)),
                const SizedBox(height: 2),
                Text(subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.white.withValues(alpha: 0.85))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isCustomer ? 'CUSTOMER' : 'GUEST',
              style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool locked;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Icon(icon, color: AppColors.primary),
                  ),
                  if (locked)
                    const Icon(Icons.lock_outline_rounded,
                        size: 18, color: AppColors.grey400),
                ],
              ),
              const Spacer(),
              Text(title, style: AppTextStyles.headlineSmall),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Need help?', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 2),
          Text('Our team is happy to assist you.', style: AppTextStyles.caption),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              _QuickAction(
                icon: Icons.phone_outlined,
                label: 'Call',
                onTap: () =>
                    LinkLauncher.call(context, AppConstants.salesHotlineRaw),
              ),
              _QuickAction(
                icon: Icons.email_outlined,
                label: 'Email',
                onTap: () =>
                    LinkLauncher.email(context, AppConstants.contactEmail),
              ),
              _QuickAction(
                icon: Icons.directions_outlined,
                label: 'Visit us',
                onTap: () => LinkLauncher.map(context, AppConstants.address),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withValues(alpha: 0.28),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(height: 6),
              Text(label, style: AppTextStyles.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}