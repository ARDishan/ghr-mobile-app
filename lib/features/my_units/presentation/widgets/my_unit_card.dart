import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/my_unit_entity.dart';

class MyUnitCard extends StatelessWidget {
  final MyUnitEntity unit;
  final VoidCallback onTap;
  const MyUnitCard({super.key, required this.unit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
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
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(unit.displayProject,
                              style: AppTextStyles.headlineSmall),
                          const SizedBox(height: 2),
                          Text(
                            [unit.displayUnit, unit.apartmentType]
                                .where((e) => e != null && e.isNotEmpty)
                                .join(' · '),
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (unit.hasOverdue)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('OVERDUE',
                            style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w700)),
                      ),
                  ],
                ),
                const SizedBox(height: AppSizes.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: unit.paidFraction,
                    minHeight: 6,
                    backgroundColor: AppColors.grey200,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.success),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${(unit.paidFraction * 100).toStringAsFixed(0)}% paid',
                    style: AppTextStyles.caption),
                const SizedBox(height: AppSizes.md),
                Row(
                  children: [
                    Expanded(
                      child: _Figure(
                          label: 'Outstanding',
                          value: CurrencyFormatter.lkr(unit.outstanding),
                          color: AppColors.primary),
                    ),
                    Expanded(
                      child: _Figure(
                          label: 'Overdue',
                          value: CurrencyFormatter.lkr(unit.overdue),
                          color: unit.hasOverdue
                              ? AppColors.error
                              : AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Figure({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 2),
        Text(value,
            style: AppTextStyles.labelLarge
                .copyWith(color: color, fontWeight: FontWeight.w700)),
      ],
    );
  }
}