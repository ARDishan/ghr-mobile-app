import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../../core/utils/text_utils.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Profile', style: AppTextStyles.headlineMedium)),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const LoadingWidget();
          }
          if (state is ProfileError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<ProfileBloc>().add(const ProfileLoadRequested()),
            );
          }
          if (state is! ProfileLoaded) return const SizedBox.shrink();
          return _ProfileView(profile: state.profile);
        },
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final ProfileEntity profile;
  const _ProfileView({required this.profile});

  String? _phone(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return PhoneFormatter.pretty(PhoneFormatter.toE164(raw));
  }

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final name = toTitleCase(p.name);
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';

    final contact = [
      _Item(Icons.phone_outlined, 'Mobile', _phone(p.mobile), copy: p.mobile),
      _Item(Icons.chat_outlined, 'WhatsApp', _phone(p.whatsapp), copy: p.whatsapp),
      _Item(Icons.email_outlined, 'Email', p.email, copy: p.email),
    ];
    final personal = [
      // The NIC is shown masked and is deliberately not copyable.
      _Item(Icons.badge_outlined, 'NIC', p.maskedNic),
    ];
    final address = [
      _Item(Icons.home_outlined, 'Address', p.address, copy: p.address),
      _Item(Icons.location_city_outlined, 'City',
          p.city == null ? null : toTitleCase(p.city!)),
      _Item(Icons.public_outlined, 'Country',
          p.country == null ? null : toTitleCase(p.country!)),
    ];

    return ListView(
      padding: AppSizes.pagePadding,
      children: [
        Center(
          child: CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.primary,
            child: Text(initial,
                style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Center(
          child: Text(name,
              textAlign: TextAlign.center, style: AppTextStyles.headlineLarge),
        ),
        if (p.partyId != null && p.partyId!.trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Customer ID: ${p.partyId}',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
        const SizedBox(height: AppSizes.lg),
        _Section(title: 'Contact', items: contact),
        _Section(title: 'Personal', items: personal),
        _Section(title: 'Address', items: address),
        const SizedBox(height: AppSizes.sm),
        AppButton(
          label: 'REQUEST A CHANGE',
          style: AppButtonStyle.outline,
          prefixIcon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
          onPressed: () => LinkLauncher.emailWith(
            context,
            AppConstants.contactEmail,
            subject: 'Profile update request'
                '${p.partyId == null ? '' : ' - ${p.partyId}'}',
            body: 'Customer: $name\n'
                '${p.partyId == null ? '' : 'Customer ID: ${p.partyId}\n'}'
                '\nPlease update the following details:\n',
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          'Your details come from GHR records, so changes are made by our team.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

class _Item {
  final IconData icon;
  final String label;
  final String? value;
  final String? copy; // text to copy on tap, null = not copyable
  const _Item(this.icon, this.label, this.value, {this.copy});
}

class _Section extends StatelessWidget {
  final String title;
  final List<_Item> items;
  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final visible =
        items.where((i) => i.value != null && i.value!.trim().isNotEmpty).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
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
            child: Column(
              children: [
                for (var i = 0; i < visible.length; i++) ...[
                  ListTile(
                    leading: Icon(visible[i].icon, color: AppColors.primary),
                    title: Text(visible[i].label, style: AppTextStyles.caption),
                    subtitle: Text(visible[i].value!,
                        style: AppTextStyles.bodyLarge.copyWith(fontSize: 15)),
                    trailing: visible[i].copy == null
                        ? null
                        : const Icon(Icons.copy_rounded, size: 18, color: AppColors.grey400),
                    onTap: visible[i].copy == null
                        ? null
                        : () async {
                            final messenger = ScaffoldMessenger.of(context);
                            await Clipboard.setData(
                                ClipboardData(text: visible[i].copy!));
                            messenger
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  content: Text('${visible[i].label} copied')));
                          },
                  ),
                  if (i != visible.length - 1) const Divider(indent: 16, endIndent: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
