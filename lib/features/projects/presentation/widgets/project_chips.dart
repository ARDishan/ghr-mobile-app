import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/projects_entity.dart';

/// Small pill used on cards and detail pages.
class Pill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color? background;
  final bool solid;

  const Pill({
    super.key,
    required this.label,
    this.icon,
    this.color = AppColors.primary,
    this.background,
    this.solid = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = solid ? color : (background ?? color.withValues(alpha: 0.12));
    final fg = solid ? AppColors.white : color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final ProjectEntity project;
  final bool solid;
  const StatusPill({super.key, required this.project, this.solid = false});

  @override
  Widget build(BuildContext context) {
    return Pill(
      label: project.isCompleted ? 'Completed' : 'Ongoing',
      icon: project.isCompleted ? Icons.check_circle_outline_rounded : Icons.construction_rounded,
      color: project.isCompleted ? AppColors.success : AppColors.warning,
      solid: solid,
    );
  }
}

/// Shown only for non-main branches (e.g. Corals Edge); GHR needs no tag.
class BranchTag extends StatelessWidget {
  final String label;
  final bool solid;
  const BranchTag({super.key, required this.label, this.solid = false});

  @override
  Widget build(BuildContext context) {
    return Pill(
      label: label,
      icon: Icons.sell_outlined,
      color: AppColors.gold,
      solid: solid,
    );
  }
}

IconData projectTypeIcon(String? type) {
  final t = (type ?? '').toUpperCase();
  if (t.contains('HOTEL')) return Icons.hotel_rounded;
  if (t.contains('HOUSING')) return Icons.holiday_village_rounded;
  if (t.contains('APARTMENT')) return Icons.apartment_rounded;
  if (t.contains('VILLA')) return Icons.villa_rounded;
  if (t.contains('LAND')) return Icons.landscape_rounded;
  if (t.contains('COMMERCIAL')) return Icons.store_rounded;
  return Icons.domain_rounded;
}
