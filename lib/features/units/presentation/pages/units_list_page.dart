import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/unit_entity.dart';
import '../bloc/units_bloc.dart';
import '../bloc/units_event.dart';
import '../bloc/units_state.dart';
import '../widgets/unit_list_item.dart';

/// Arguments passed via go_router `extra` when navigating here.
class UnitsListPageArgs {
  final int projectBasicId;
  final String projectTitle;
  const UnitsListPageArgs({required this.projectBasicId, required this.projectTitle});
}

class UnitsListPage extends StatefulWidget {
  final UnitsListPageArgs args;
  const UnitsListPage({super.key, required this.args});

  @override
  State<UnitsListPage> createState() => _UnitsListPageState();
}

class _UnitsListPageState extends State<UnitsListPage> {
  String? _status; // null = all

  @override
  void initState() {
    super.initState();
    context.read<UnitsBloc>().add(UnitsLoadRequested(widget.args.projectBasicId));
  }

  /// "GROUND FLOOR" first, then 1ST, 2ND ... 10TH in numeric order.
  static int _floorOrder(String floor) {
    final f = floor.toUpperCase();
    if (f.contains('GROUND')) return 0;
    final m = RegExp(r'^\D*(\d+)').firstMatch(f);
    return m == null ? 1000 : int.parse(m.group(1)!);
  }

  /// "Unit 2" before "Unit 10".
  static int _unitOrder(UnitEntity u) {
    final m = RegExp(r'(\d+)\s*$').firstMatch(u.unit ?? '');
    return m == null ? 1000000 : int.parse(m.group(1)!);
  }

  Map<String, List<UnitEntity>> _groupByFloor(List<UnitEntity> units) {
    final grouped = <String, List<UnitEntity>>{};
    for (final unit in units) {
      grouped.putIfAbsent(unit.floor ?? 'Other', () => []).add(unit);
    }
    final floors = grouped.keys.toList()
      ..sort((a, b) {
        final c = _floorOrder(a).compareTo(_floorOrder(b));
        return c != 0 ? c : a.compareTo(b);
      });
    return {
      for (final f in floors)
        f: (grouped[f]!..sort((a, b) => _unitOrder(a).compareTo(_unitOrder(b)))),
    };
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.args.projectTitle, style: AppTextStyles.headlineMedium),
      ),
      body: BlocBuilder<UnitsBloc, UnitsState>(
        builder: (context, state) {
          if (state is UnitsLoading || state is UnitsInitial) return const LoadingWidget();
          if (state is UnitsError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context
                  .read<UnitsBloc>()
                  .add(UnitsLoadRequested(widget.args.projectBasicId)),
            );
          }
          if (state is! UnitsLoaded) return const SizedBox.shrink();

          if (state.units.isEmpty) {
            return const EmptyState(
              icon: Icons.apartment_rounded,
              title: 'No units listed yet',
              message: 'Units for this project will appear here.',
            );
          }

          final statuses = (state.units
                  .map((u) => (u.status ?? '').toUpperCase())
                  .where((s) => s.isNotEmpty)
                  .toSet()
                  .toList()
                ..sort());
          final visible = _status == null
              ? state.units
              : state.units.where((u) => (u.status ?? '').toUpperCase() == _status).toList();
          final available = state.units.where((u) => u.isAvailable).length;
          final grouped = _groupByFloor(visible);

          return ListView(
            padding: AppSizes.pagePadding,
            children: [
              Text('$available of ${state.units.length} units available',
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppSizes.sm),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: _status == null,
                        onSelected: (_) => setState(() => _status = null),
                      ),
                    ),
                    for (final s in statuses)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(unitStatusLabel(s)),
                          selected: _status == s,
                          onSelected: (on) => setState(() => _status = on ? s : null),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              if (visible.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: AppSizes.xl),
                  child: Center(child: Text('No units with this status.')),
                ),
              for (final entry in grouped.entries) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                  child: Text(entry.key, style: AppTextStyles.sectionTitle),
                ),
                for (final unit in entry.value) UnitListItem(unit: unit),
              ],
            ],
          );
        },
      ),
    );
  }
}