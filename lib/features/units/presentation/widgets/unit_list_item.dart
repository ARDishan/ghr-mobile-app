import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/unit_entity.dart';

Color unitStatusColor(String? status) {
  switch ((status ?? '').toUpperCase()) {
    case 'AVAILABLE':
      return AppColors.success;
    case 'RESERVED':
      return AppColors.warning;
    case 'SOLD':
      return AppColors.error;
    case 'TRANSFERRED':
      return AppColors.info;
    case 'BLOCKED':
      return AppColors.grey600;
    default:
      return AppColors.grey500;
  }
}

String unitStatusLabel(String? status) {
  final s = (status ?? '').trim();
  if (s.isEmpty) return 'Unknown';
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

class UnitListItem extends StatelessWidget {
  final UnitEntity unit;
  const UnitListItem({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final color = unitStatusColor(unit.status);
    final title = [unit.floor, unit.unit].where((e) => e != null && e.isNotEmpty).join(' · ');

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.isEmpty ? (unit.unitRefId ?? 'Unit') : title,
                    style: AppTextStyles.headlineSmall.copyWith(fontSize: 15)),
                if (unit.apartmentType != null) ...[
                  const SizedBox(height: 2),
                  Text(unit.apartmentType!, style: AppTextStyles.caption),
                ],
                if (unit.sqrFt != null) ...[
                  const SizedBox(height: 2),
                  Text('${unit.sqrFt!.toStringAsFixed(0)} sq.ft',
                      style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(CurrencyFormatter.lkrWhole(unit.price),
                  style: AppTextStyles.priceTag.copyWith(fontSize: 15)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  unitStatusLabel(unit.status),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
