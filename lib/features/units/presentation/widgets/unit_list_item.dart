import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../domain/entities/unit_entity.dart';

class UnitListItem extends StatelessWidget {
  final UnitEntity unit;
  const UnitListItem({super.key, required this.unit});

  Color _statusColor(String? status) {
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

  String _formatPrice(double? price) {
    if (price == null) return '-';
    // TODO: use a real currency/number formatter (intl package) once added.
    return 'LKR ${price.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [unit.floor, unit.unit].where((e) => e != null && e.isNotEmpty).join(' · '),
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 15),
                ),
                if (unit.apartmentType != null) ...[
                  const SizedBox(height: 2),
                  Text(unit.apartmentType!, style: AppTextStyles.caption),
                ],
                if (unit.sqrFt != null) ...[
                  const SizedBox(height: 2),
                  Text('${unit.sqrFt!.toStringAsFixed(0)} sq.ft', style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_formatPrice(unit.price), style: AppTextStyles.priceTag.copyWith(fontSize: 15)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor(unit.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  unit.status ?? 'UNKNOWN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(unit.status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}