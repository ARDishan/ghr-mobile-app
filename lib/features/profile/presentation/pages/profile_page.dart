import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppErrorWidget(message: state.message),
                TextButton(
                  onPressed: () => context
                      .read<ProfileBloc>()
                      .add(const ProfileLoadRequested()),
                  child: const Text('Try again'),
                ),
              ],
            );
          }
          if (state is ProfileLoaded) {
            final p = state.profile;
            final initial =
                p.name.isNotEmpty ? p.name.substring(0, 1).toUpperCase() : '?';
            return ListView(
              padding: AppSizes.pagePadding,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primaryAccent.withOpacity(0.3),
                    child: Text(initial,
                        style: AppTextStyles.displaySmall
                            .copyWith(color: AppColors.primary)),
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Center(
                  child: Text(p.name,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headlineLarge),
                ),
                if (p.partyId != null)
                  Center(
                      child: Text('Customer ID: ${p.partyId}',
                          style: AppTextStyles.caption)),
                const SizedBox(height: AppSizes.lg),
                _InfoCard(items: [
                  _Item(Icons.phone_outlined, 'Mobile', p.mobile),
                  _Item(Icons.chat_outlined, 'WhatsApp', p.whatsapp),
                  _Item(Icons.email_outlined, 'Email', p.email),
                  _Item(Icons.badge_outlined, 'NIC', p.maskedNic),
                  _Item(Icons.home_outlined, 'Address', p.address),
                  _Item(Icons.location_city_outlined, 'City', p.city),
                  _Item(Icons.public_outlined, 'Country', p.country),
                ]),
                const SizedBox(height: AppSizes.md),
                Text(
                  'These details come from GHR records. To update them, please '
                  'contact GHR (see Menu → About).',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption,
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _Item {
  final IconData icon;
  final String label;
  final String? value;
  const _Item(this.icon, this.label, this.value);
}

class _InfoCard extends StatelessWidget {
  final List<_Item> items;
  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final visible = items.where((i) => i.value != null && i.value!.trim().isNotEmpty).toList();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        children: [
          for (var i = 0; i < visible.length; i++) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(visible[i].icon, color: AppColors.primary),
              title: Text(visible[i].label, style: AppTextStyles.caption),
              subtitle: Text(visible[i].value!,
                  style: AppTextStyles.bodyLarge.copyWith(fontSize: 15)),
            ),
            if (i != visible.length - 1) const Divider(),
          ],
        ],
      ),
    );
  }
}