import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<UnitsBloc>().add(UnitsLoadRequested(widget.args.projectBasicId));
  }

  Map<String, List<UnitEntity>> _groupByFloor(List<UnitEntity> units) {
    final Map<String, List<UnitEntity>> grouped = {};
    for (final unit in units) {
      final key = unit.floor ?? 'Other';
      grouped.putIfAbsent(key, () => []).add(unit);
    }
    return grouped;
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
          if (state is UnitsLoading || state is UnitsInitial) {
            return const LoadingWidget();
          }
          if (state is UnitsError) {
            return AppErrorWidget(message: state.message);
          }
          if (state is UnitsLoaded) {
            if (state.units.isEmpty) {
              return const Center(child: Text('No units listed for this project yet.'));
            }

            final available = state.units.where((u) => u.isAvailable).length;
            final grouped = _groupByFloor(state.units);
            final floors = grouped.keys.toList();

            return ListView(
              padding: AppSizes.pagePadding,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.md),
                  child: Text(
                    '$available of ${state.units.length} units available',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                for (final floor in floors) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                    child: Text(floor, style: AppTextStyles.sectionTitle),
                  ),
                  for (final unit in grouped[floor]!) UnitListItem(unit: unit),
                ],
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}