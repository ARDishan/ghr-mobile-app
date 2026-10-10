import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/projects_entity.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';
import '../project_filter.dart';
import '../widgets/project_card.dart';

class ProjectsListPage extends StatefulWidget {
  final ProjectFilter initialFilter;
  const ProjectsListPage({super.key, this.initialFilter = const ProjectFilter()});

  @override
  State<ProjectsListPage> createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends State<ProjectsListPage> {
  late ProjectFilter _filter = widget.initialFilter;
  late final TextEditingController _search =
      TextEditingController(text: widget.initialFilter.query);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _refresh() {
    final completer = Completer<void>();
    context.read<ProjectsBloc>().add(ProjectsLoadRequested(completer: completer));
    return completer.future;
  }

  Future<void> _openFilters(List<ProjectEntity> all) async {
    final result = await showModalBottomSheet<ProjectFilter>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _FilterSheet(initial: _filter, projects: all),
    );
    if (result != null) setState(() => _filter = result);
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Projects', style: AppTextStyles.headlineMedium),
        actions: [
          BlocBuilder<ProjectsBloc, ProjectsState>(
            builder: (context, state) {
              if (state is! ProjectsLoaded) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Filters',
                onPressed: () => _openFilters(state.projects),
                icon: Badge(
                  isLabelVisible: _filter.activeCount > 0,
                  label: Text('${_filter.activeCount}'),
                  child: const Icon(Icons.tune_rounded),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          if (state is ProjectsLoading || state is ProjectsInitial) {
            return const LoadingWidget();
          }
          if (state is ProjectsError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<ProjectsBloc>().add(const ProjectsLoadRequested()),
            );
          }
          if (state is! ProjectsLoaded) return const SizedBox.shrink();

          final results = _filter.apply(state.projects);

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.xl),
              children: [
                TextField(
                  controller: _search,
                  textInputAction: TextInputAction.search,
                  onChanged: (v) => setState(() => _filter = _filter.withQuery(v)),
                  decoration: InputDecoration(
                    hintText: 'Search projects, cities...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.grey500),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              _search.clear();
                              setState(() => _filter = _filter.withQuery(''));
                            },
                          ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                if (_filter.activeCount > 0) ...[
                  const SizedBox(height: AppSizes.sm),
                  Wrap(
                    spacing: 8,
                    children: [
                      if (_filter.branchPrefix != null)
                        InputChip(
                          label: Text(
                            state.projects.branches
                                .where((b) => b.prefix == _filter.branchPrefix!.toUpperCase())
                                .map((b) => b.label)
                                .firstOrNull ?? _filter.branchPrefix!,
                          ),
                          onDeleted: () => setState(() => _filter = _filter.withBranch(null)),
                        ),
                      if (_filter.type != null)
                        InputChip(
                          label: Text(_filter.type!),
                          onDeleted: () => setState(() => _filter = _filter.withType(null)),
                        ),
                      if (_filter.city != null)
                        InputChip(
                          label: Text(_filter.city!),
                          onDeleted: () => setState(() => _filter = _filter.withCity(null)),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSizes.sm),
                Text(
                  '${results.length} project${results.length == 1 ? '' : 's'}',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSizes.sm),
                if (results.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSizes.xl),
                    child: EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No projects found',
                      message: 'Try a different search or clear the filters.',
                      actionLabel: _filter.isActive ? 'Clear filters' : null,
                      onAction: () {
                        _search.clear();
                        setState(() => _filter = const ProjectFilter());
                      },
                    ),
                  )
                else
                  for (final project in results)
                    ProjectCard(
                      project: project,
                      onTap: () => context.push(RouteNames.projectDetail(project.id)),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final ProjectFilter initial;
  final List<ProjectEntity> projects;
  const _FilterSheet({required this.initial, required this.projects});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late ProjectFilter _f = widget.initial;

  @override
  Widget build(BuildContext context) {
    final branches = widget.projects.branches;
    final types = widget.projects.typeCounts;
    final cities = widget.projects.cityCounts;

    Widget section(String title, List<Widget> chips) => Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.labelLarge),
              const SizedBox(height: AppSizes.sm),
              Wrap(spacing: 8, runSpacing: 8, children: chips),
            ],
          ),
        );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: AppTextStyles.headlineMedium),
                  TextButton(
                    onPressed: () => setState(() => _f = ProjectFilter(query: _f.query)),
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              if (branches.length > 1)
                section('Company', [
                  for (final b in branches)
                    ChoiceChip(
                      label: Text(b.label),
                      selected: _f.branchPrefix?.toUpperCase() == b.prefix,
                      onSelected: (on) =>
                          setState(() => _f = _f.withBranch(on ? b.prefix : null)),
                    ),
                ]),
              if (types.isNotEmpty)
                section('Property type', [
                  for (final t in types)
                    ChoiceChip(
                      label: Text('${t.label} (${t.count})'),
                      selected: _f.type?.toLowerCase() == t.label.toLowerCase(),
                      onSelected: (on) =>
                          setState(() => _f = _f.withType(on ? t.label : null)),
                    ),
                ]),
              if (cities.isNotEmpty)
                section('Location', [
                  for (final c in cities)
                    ChoiceChip(
                      label: Text('${c.label} (${c.count})'),
                      selected: _f.city?.toLowerCase() == c.label.toLowerCase(),
                      onSelected: (on) =>
                          setState(() => _f = _f.withCity(on ? c.label : null)),
                    ),
                ]),
              const SizedBox(height: AppSizes.sm),
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeightMd,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(_f),
                  child: const Text('SHOW PROJECTS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
