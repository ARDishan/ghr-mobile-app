import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/link_launcher.dart';
import '../cubit/about_cubit.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('About', style: AppTextStyles.headlineMedium)),
      body: ListView(
        padding: AppSizes.pagePadding,
        children: [
          const _Hero(),
          const SizedBox(height: AppSizes.lg),
          const _Stats(),
          const _Section(
            title: 'Our Story',
            child: Text(
              'Founded in 2003, Global Housing & Real Estate (GHR) builds '
              'residential developments across Sri Lanka, from city '
              'apartments in Colombo to hotel residencies and retreats in the '
              'hills and along the coast. We are known as a pioneer of the '
              'hotel residency concept, combining modern living, long-term '
              'value and environmentally conscious building practices.',
            ),
          ),
          const _Section(
            title: 'Our Vision',
            child: Text(
              'To redefine luxury living in Sri Lanka with innovative real '
              'estate solutions that create lasting value for our clients, '
              'investors and communities.',
            ),
          ),
          const _Section(
            title: 'Our Mission',
            child: Text(
              'To deliver high-quality, client-focused and sustainable '
              'developments, led by innovation, transparency and exceptional '
              'service, so that every project offers both luxury and '
              'long-term value.',
            ),
          ),
          const _Section(
            title: 'What We Do',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Pillar('Strategy',
                    'Well-located projects designed to deliver strong returns.'),
                _Pillar('Ideation',
                    'Design and functionality that anticipate future needs.'),
                _Pillar('Expertise',
                    'Experienced teams delivering to a high standard, concept to completion.'),
                _Pillar('Support & Engagement',
                    'Continuous support before and after purchase.'),
              ],
            ),
          ),
          _Section(
            title: 'Certifications & Awards',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _Chip('IAF Certified'),
                _Chip('BOI Approved'),
                _Chip('CIDA Approved'),
                _Chip('ISO 9001 by RoyalCert'),
                _Chip('Gold Award by ICSG'),
              ],
            ),
          ),
          const _ContactSection(),
          const SizedBox(height: AppSizes.md),
          Center(
            child: Text(
              '© ${DateTime.now().year} ${AppConstants.companyName}',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Global Housing',
              style: AppTextStyles.displaySmall.copyWith(color: AppColors.white)),
          Text('& Real Estate',
              style: AppTextStyles.labelLarge
                  .copyWith(color: AppColors.white.withOpacity(0.8))),
          const SizedBox(height: AppSizes.md),
          Text(
            'Over two decades of building homes across Sri Lanka.',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.white.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutCubit, AboutState>(
      builder: (context, state) {
        final s = state.stats;
        if (state.status != AboutStatus.loaded || s == null) {
          // Loading or failed: skip the block rather than show wrong numbers.
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.lg),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSizes.sm,
            crossAxisSpacing: AppSizes.sm,
            childAspectRatio: 2.2,
            children: [
              _StatTile(value: '${s.projectsTotal}', label: 'Projects'),
              _StatTile(value: '${s.projectsCompleted}', label: 'Completed'),
              _StatTile(value: '${s.projectsOngoing}', label: 'Ongoing'),
              _StatTile(value: '${s.unitsTotal}', label: 'Units'),
            ],
          ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.priceTag),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSizes.sm),
          DefaultTextStyle(style: AppTextStyles.bodyMedium, child: child),
        ],
      ),
    );
  }
}

class _Pillar extends StatelessWidget {
  final String title;
  final String text;
  const _Pillar(this.title, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
          Text(text, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: AppTextStyles.labelMedium),
      backgroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.inputBorder),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Us', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSizes.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: Column(
            children: [
              _ContactTile(
                icon: Icons.phone_outlined,
                title: 'Sales hotline',
                value: AppConstants.salesHotlineDisplay,
                onTap: () =>
                    LinkLauncher.call(context, AppConstants.salesHotlineRaw),
              ),
              const Divider(),
              _ContactTile(
                icon: Icons.email_outlined,
                title: 'Email',
                value: AppConstants.contactEmail,
                onTap: () =>
                    LinkLauncher.email(context, AppConstants.contactEmail),
              ),
              const Divider(),
              _ContactTile(
                icon: Icons.location_on_outlined,
                title: 'Head office',
                value: AppConstants.address,
                onTap: () => LinkLauncher.map(context, AppConstants.address),
              ),
              const Divider(),
              _ContactTile(
                icon: Icons.language_rounded,
                title: 'Website',
                value: 'www.globalhousing.lk',
                onTap: () =>
                    LinkLauncher.openUrl(context, AppConstants.websiteUrl),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Wrap(
          spacing: 8,
          children: [
            ActionChip(
              label: const Text('Facebook'),
              onPressed: () =>
                  LinkLauncher.openUrl(context, AppConstants.facebookUrl),
            ),
            ActionChip(
              label: const Text('Instagram'),
              onPressed: () =>
                  LinkLauncher.openUrl(context, AppConstants.instagramUrl),
            ),
            ActionChip(
              label: const Text('LinkedIn'),
              onPressed: () =>
                  LinkLauncher.openUrl(context, AppConstants.linkedinUrl),
            ),
            ActionChip(
              label: const Text('YouTube'),
              onPressed: () =>
                  LinkLauncher.openUrl(context, AppConstants.youtubeUrl),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.caption),
      subtitle: Text(value, style: AppTextStyles.bodyLarge.copyWith(fontSize: 14)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
      onTap: onTap,
    );
  }
}