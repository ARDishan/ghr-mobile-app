import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/my_unit_entity.dart';

class MyUnitDetailPage extends StatelessWidget {
  final MyUnitEntity unit;
  const MyUnitDetailPage({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Unit Details', style: AppTextStyles.headlineMedium)),
      body: ListView(
        padding: AppSizes.pagePadding,
        children: [
          Text(unit.displayProject, style: AppTextStyles.displaySmall),
          const SizedBox(height: AppSizes.xs),
          Text(
            [unit.displayUnit, unit.apartmentType]
                .where((e) => e != null && e.isNotEmpty)
                .join(' · '),
            style: AppTextStyles.bodyMedium,
          ),
          Text(unit.unitRefId, style: AppTextStyles.caption),
          const SizedBox(height: AppSizes.lg),

          // Headline figures
          _Panel(
            children: [
              Text('Outstanding balance', style: AppTextStyles.labelMedium),
              const SizedBox(height: 4),
              Text(CurrencyFormatter.lkr(unit.outstanding),
                  style: AppTextStyles.priceTag.copyWith(fontSize: 26)),
              const SizedBox(height: AppSizes.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: unit.paidFraction,
                  minHeight: 8,
                  backgroundColor: AppColors.grey200,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.success),
                ),
              ),
              const SizedBox(height: 4),
              Text('${(unit.paidFraction * 100).toStringAsFixed(1)}% of scheduled payments received',
                  style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // Overdue
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: (unit.hasOverdue ? AppColors.error : AppColors.success)
                  .withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(
                color: (unit.hasOverdue ? AppColors.error : AppColors.success)
                    .withOpacity(0.35),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  unit.hasOverdue
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline_rounded,
                  color: unit.hasOverdue ? AppColors.error : AppColors.success,
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unit.hasOverdue
                            ? 'Overdue ${CurrencyFormatter.lkr(unit.overdue)}'
                            : 'No overdue payments',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: unit.hasOverdue
                              ? AppColors.error
                              : AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Payments become overdue ${AppConstants.overdueGraceDays} days after the due date.',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Figures
          _Panel(
            children: [
              _Row('Unit value', CurrencyFormatter.lkr(unit.unitValue)),
              _Row('Total scheduled', CurrencyFormatter.lkr(unit.totalScheduled)),
              _Row('Total received', CurrencyFormatter.lkr(unit.totalReceived)),
              if (unit.defaultAmount > 0)
                _Row('Default amount', CurrencyFormatter.lkr(unit.defaultAmount)),
              if (unit.sqrFt != null)
                _Row('Area', '${unit.sqrFt!.toStringAsFixed(0)} sq.ft'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final List<Widget> children;
  const _Panel({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyLarge
                    .copyWith(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}