import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/my_units_bloc.dart';
import '../bloc/my_units_event.dart';
import '../bloc/my_units_state.dart';
import '../widgets/my_unit_card.dart';

class MyUnitsPage extends StatelessWidget {
  const MyUnitsPage({super.key});

  Future<void> _refresh(BuildContext context) {
    final completer = Completer<void>();
    context.read<MyUnitsBloc>().add(MyUnitsLoadRequested(completer: completer));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('My Unit(s)', style: AppTextStyles.headlineMedium)),
      body: BlocBuilder<MyUnitsBloc, MyUnitsState>(
        builder: (context, state) {
          if (state is MyUnitsLoading || state is MyUnitsInitial) {
            return const LoadingWidget();
          }
          if (state is MyUnitsError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppErrorWidget(message: state.message),
                TextButton(
                  onPressed: () => context
                      .read<MyUnitsBloc>()
                      .add(const MyUnitsLoadRequested()),
                  child: const Text('Try again'),
                ),
              ],
            );
          }
          if (state is MyUnitsLoaded) {
            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AppSizes.pagePadding,
                children: [
                  if (state.units.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: AppSizes.xxl),
                      child: Center(
                        child: Text('No units are linked to your account yet.'),
                      ),
                    )
                  else ...[
                    _SummaryCard(
                      outstanding: state.totalOutstanding,
                      overdue: state.totalOverdue,
                      unitCount: state.units.length,
                    ),
                    const SizedBox(height: AppSizes.lg),
                    for (final unit in state.units)
                      MyUnitCard(
                        unit: unit,
                        onTap: () =>
                            context.push(RouteNames.myUnitDetail, extra: unit),
                      ),
                  ],
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double outstanding;
  final double overdue;
  final int unitCount;
  const _SummaryCard({
    required this.outstanding,
    required this.overdue,
    required this.unitCount,
  });

  @override
  Widget build(BuildContext context) {
    final asOf = DateFormat('d MMM yyyy').format(DateTime.now());
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
          Text('TOTAL OUTSTANDING',
              style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.white.withOpacity(0.8), letterSpacing: 1.2)),
          const SizedBox(height: 4),
          Text(CurrencyFormatter.lkr(outstanding),
              style: AppTextStyles.headlineLarge
                  .copyWith(color: AppColors.white)),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: overdue > 0
                      ? AppColors.error
                      : AppColors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Text(
                  overdue > 0
                      ? 'Overdue ${CurrencyFormatter.lkr(overdue)}'
                      : 'No overdue payments',
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            '$unitCount unit${unitCount == 1 ? '' : 's'} · as of $asOf\n'
            'Payments become overdue ${AppConstants.overdueGraceDays} days after the due date.',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.white.withOpacity(0.75)),
          ),
        ],
      ),
    );
  }
}