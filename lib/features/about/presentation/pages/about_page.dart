import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../core/utils/text_utils.dart';
import '../../../../shared/widgets/brand_logo.dart';
import '../../data/company_stats_repository.dart';
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
            child: _Card(
              child: Text(
                'Founded in 2003, Global Housing & Real Estate (GHR) builds '
                'residential developments across Sri Lanka, from city '
                'apartments in Colombo to hotel residencies and retreats in the '
                'hills and along the coast. We are known as a pioneer of the '
                'hotel residency concept, combining modern living, long-term '
                'value and environmentally conscious building practices.',
              ),
            ),
          ),
          const _Section(
            title: 'Vision & Mission',
            child: Column(
              children: [
                _IconCard(
                  icon: Icons.visibility_outlined,
                  title: 'Our Vision',
                  text: 'To redefine luxury living in Sri Lanka with innovative real '
                      'estate solutions that create lasting value for our clients, '
                      'investors and communities.',
                ),
                SizedBox(height: AppSizes.sm),
                _IconCard(
                  icon: Icons.flag_outlined,
                  title: 'Our Mission',
                  text: 'To deliver high-quality, client-focused and sustainable '
                      'developments, led by innovation, transparency and exceptional '
                      'service, so every project offers luxury and long-term value.',
                ),
              ],
            ),
          ),
          const _Section(title: 'What We Do', child: _Pillars()),
          _Section(
            title: 'Certifications & Awards',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _Badge('IAF Certified'),
                _Badge('BOI Approved'),
                _Badge('CIDA Approved'),
                _Badge('ISO 9001 by RoyalCert'),
                _Badge('Gold Award by ICSG'),
              ],
            ),
          ),
          const _Companies(),
          const _Section(title: 'Contact Us', child: _Contact()),
          const SizedBox(height: AppSizes.sm),
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

// ───────────────────────── building blocks ─────────────────────────

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
          child,
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: DefaultTextStyle(
        style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
        child: child,
      ),
    );
  }
}

class _IconCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _IconCard({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryAccent.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headlineSmall.copyWith(fontSize: 15)),
                const SizedBox(height: 4),
                Text(text),
              ],
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
      child: Row(
        children: [
          const BrandLogo(size: 64),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Global Housing',
                    style: AppTextStyles.headlineLarge.copyWith(color: AppColors.white)),
                Text('& Real Estate',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.white.withValues(alpha: 0.85))),
                const SizedBox(height: 6),
                Text('Over two decades of building homes across Sri Lanka.',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.white.withValues(alpha: 0.9))),
              ],
            ),
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
        if (s == null) return const SizedBox.shrink(); // loading or unavailable
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.lg),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSizes.sm,
            crossAxisSpacing: AppSizes.sm,
            childAspectRatio: 2.3,
            children: [
              _StatTile(icon: Icons.domain_rounded, value: s.projectsTotal, label: 'Projects'),
              _StatTile(icon: Icons.verified_outlined, value: s.projectsCompleted, label: 'Completed'),
              _StatTile(icon: Icons.construction_rounded, value: s.projectsOngoing, label: 'Ongoing'),
              _StatTile(icon: Icons.apartment_rounded, value: s.unitsTotal, label: 'Units'),
            ],
          ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  const _StatTile({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 26),
          const SizedBox(width: AppSizes.sm + 2),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$value', style: AppTextStyles.priceTag.copyWith(fontSize: 20)),
              Text(label, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pillars extends StatelessWidget {
  const _Pillars();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.insights_rounded, 'Strategy', 'Well-located projects built for strong returns.'),
      (Icons.lightbulb_outline_rounded, 'Ideation', 'Design that anticipates future needs.'),
      (Icons.workspace_premium_outlined, 'Expertise', 'Experienced teams from concept to completion.'),
      (Icons.support_agent_rounded, 'Support', 'Continuous help before and after purchase.'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSizes.sm,
      crossAxisSpacing: AppSizes.sm,
      childAspectRatio: 1.05,
      children: [
        for (final (icon, title, text) in items)
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.primary, size: 26),
                const Spacer(),
                Text(title, style: AppTextStyles.headlineSmall.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(text, style: AppTextStyles.caption),
              ],
            ),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded, size: 16, color: AppColors.gold),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}

// ───────────────────────── companies (from the branches table) ─────────────────────────

class _Companies extends StatelessWidget {
  const _Companies();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutCubit, AboutState>(
      builder: (context, state) {
        if (state.branches.isEmpty) return const SizedBox.shrink();
        return _Section(
          title: 'Our Companies',
          child: Column(
            children: [
              for (final b in state.branches)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: _CompanyCard(branch: b),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final CompanyBranch branch;
  const _CompanyCard({required this.branch});

  @override
  Widget build(BuildContext context) {
    final brand = branch.prefix.toUpperCase() == 'CED' ? Brand.ced : Brand.ghr;
    final hasAddress = branch.address != null && branch.address!.trim().isNotEmpty;
    final hasPhone = branch.mobile != null && branch.mobile!.trim().isNotEmpty;
    final hasEmail = branch.email != null && branch.email!.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: BrandLogo(brand: brand, size: 46),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(toTitleCase(branch.name), style: AppTextStyles.headlineSmall),
                    if (!branch.isMain)
                      Text('Sister company', style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
          if (hasAddress) ...[
            const SizedBox(height: AppSizes.sm),
            Text(branch.address!, style: AppTextStyles.bodySmall),
          ],
          if (hasPhone || hasEmail || hasAddress) ...[
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: 8,
              children: [
                if (hasPhone)
                  ActionChip(
                    avatar: const Icon(Icons.phone_outlined, size: 16),
                    label: Text(branch.mobile!),
                    onPressed: () => LinkLauncher.call(context, branch.mobile!),
                  ),
                if (hasEmail)
                  ActionChip(
                    avatar: const Icon(Icons.email_outlined, size: 16),
                    label: const Text('Email'),
                    onPressed: () => LinkLauncher.email(context, branch.email!),
                  ),
                if (hasAddress)
                  ActionChip(
                    avatar: const Icon(Icons.directions_outlined, size: 16),
                    label: const Text('Directions'),
                    onPressed: () => LinkLauncher.map(context, branch.address!),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ───────────────────────── contact ─────────────────────────

class _Contact extends StatelessWidget {
  const _Contact();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: Column(
            children: [
              _ContactTile(
                icon: Icons.phone_in_talk_outlined,
                title: 'Sales hotline',
                value: AppConstants.salesHotlineDisplay,
                onTap: () => LinkLauncher.call(context, AppConstants.salesHotlineRaw),
              ),
              const Divider(indent: 16, endIndent: 16),
              _ContactTile(
                icon: Icons.email_outlined,
                title: 'Email',
                value: AppConstants.contactEmail,
                onTap: () => LinkLauncher.email(context, AppConstants.contactEmail),
              ),
              const Divider(indent: 16, endIndent: 16),
              _ContactTile(
                icon: Icons.location_on_outlined,
                title: 'Head office',
                value: AppConstants.address,
                onTap: () => LinkLauncher.map(context, AppConstants.address),
              ),
              const Divider(indent: 16, endIndent: 16),
              _ContactTile(
                icon: Icons.language_rounded,
                title: 'Website',
                value: 'www.globalhousing.lk',
                onTap: () => LinkLauncher.openUrl(context, AppConstants.websiteUrl),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Wrap(
          spacing: 8,
          children: [
            ActionChip(
              avatar: const Icon(Icons.facebook, size: 18),
              label: const Text('Facebook'),
              onPressed: () => LinkLauncher.openUrl(context, AppConstants.facebookUrl),
            ),
            ActionChip(
              avatar: const Icon(Icons.photo_camera_outlined, size: 18),
              label: const Text('Instagram'),
              onPressed: () => LinkLauncher.openUrl(context, AppConstants.instagramUrl),
            ),
            ActionChip(
              avatar: const Icon(Icons.business_center_outlined, size: 18),
              label: const Text('LinkedIn'),
              onPressed: () => LinkLauncher.openUrl(context, AppConstants.linkedinUrl),
            ),
            ActionChip(
              avatar: const Icon(Icons.smart_display_outlined, size: 18),
              label: const Text('YouTube'),
              onPressed: () => LinkLauncher.openUrl(context, AppConstants.youtubeUrl),
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
