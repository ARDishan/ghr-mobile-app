import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/notifications_entity.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';

/// Icon + colour per notification kind. Unknown kinds fall back to an
/// announcement style, so new types from the Notification Service just work.
(IconData, Color) kindStyle(String kind) {
  final k = kind.toUpperCase();
  if (k.contains('PAYMENT_RECEIVED')) return (Icons.payments_rounded, AppColors.success);
  if (k.contains('OVERDUE')) return (Icons.warning_amber_rounded, AppColors.error);
  if (k.contains('REMINDER') || k.contains('DUE')) {
    return (Icons.alarm_rounded, AppColors.warning);
  }
  if (k.contains('SCHEDULE')) return (Icons.description_outlined, AppColors.primary);
  if (k.contains('WELCOME')) return (Icons.celebration_outlined, AppColors.gold);
  if (k.contains('OFFER')) return (Icons.local_offer_outlined, AppColors.gold);
  return (Icons.campaign_outlined, AppColors.primary);
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _unreadOnly = false;

  @override
  void initState() {
    super.initState();
    // Messages are sent by a separate system (Python/SMS), so always fetch the
    // latest when the page opens, not only when the app starts.
    context.read<NotificationsBloc>().add(const NotificationsLoadRequested());
  }

  Future<void> _refresh() {
    final completer = Completer<void>();
    context
        .read<NotificationsBloc>()
        .add(NotificationsLoadRequested(completer: completer));
    return completer.future;
  }

  static String _dayLabel(DateTime d) {
    final now = DateTime.now();
    final local = d.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('d MMM yyyy').format(local);
  }

  /// Flat list of day headers and notifications (input is already newest first).
  static List<_Row> _rows(List<NotificationEntity> items) {
    final rows = <_Row>[];
    String? last;
    for (final n in items) {
      final label = _dayLabel(n.createdAt);
      if (label != last) {
        rows.add(_Row.header(label));
        last = label;
      }
      rows.add(_Row.item(n));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Notifications', style: AppTextStyles.headlineMedium),
        actions: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              final hasUnread = state is NotificationsLoaded && state.unreadCount > 0;
              return TextButton(
                onPressed: hasUnread
                    ? () => context
                        .read<NotificationsBloc>()
                        .add(const NotificationsMarkAllReadRequested())
                    : null,
                child: const Text('Mark all read'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading || state is NotificationsInitial) {
            return const LoadingWidget();
          }
          if (state is NotificationsError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context
                  .read<NotificationsBloc>()
                  .add(const NotificationsLoadRequested()),
            );
          }
          if (state is! NotificationsLoaded) return const SizedBox.shrink();

          final all = state.items;
          if (all.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  EmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: 'No notifications yet',
                    message: 'Payment schedules, reminders and announcements '
                        'from GHR will appear here.',
                  ),
                ],
              ),
            );
          }

          final shown = _unreadOnly ? all.where((n) => !n.isRead).toList() : all;
          final rows = _rows(shown);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.lg, AppSizes.xs, AppSizes.lg, AppSizes.sm),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: !_unreadOnly,
                      onSelected: (_) => setState(() => _unreadOnly = false),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(state.unreadCount > 0
                          ? 'Unread (${state.unreadCount})'
                          : 'Unread'),
                      selected: _unreadOnly,
                      onSelected: (_) => setState(() => _unreadOnly = true),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: rows.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 60),
                            EmptyState(
                              icon: Icons.done_all_rounded,
                              title: "You're all caught up",
                              message: 'There are no unread notifications.',
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                              AppSizes.lg, 0, AppSizes.lg, AppSizes.xl),
                          itemCount: rows.length,
                          itemBuilder: (context, index) {
                            final row = rows[index];
                            if (row.header != null) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: AppSizes.md, bottom: AppSizes.sm),
                                child: Text(row.header!.toUpperCase(),
                                    style: AppTextStyles.labelSmall
                                        .copyWith(letterSpacing: 1.2)),
                              );
                            }
                            final item = row.item!;
                            void markRead() => context
                                .read<NotificationsBloc>()
                                .add(NotificationsMarkReadRequested([item.id]));
                            return _NotificationTile(
                              item: item,
                              onTap: markRead,
                              onOpenLink: () {
                                markRead();
                                LinkLauncher.openUrl(context, item.linkUrl!);
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Row {
  final String? header;
  final NotificationEntity? item;
  const _Row.header(this.header) : item = null;
  const _Row.item(this.item) : header = null;
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity item;
  final VoidCallback onTap;
  final VoidCallback onOpenLink;
  const _NotificationTile({
    required this.item,
    required this.onTap,
    required this.onOpenLink,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color) = kindStyle(item.kind);
    final time = DateFormat('h:mm a').format(item.createdAt.toLocal());

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: item.isRead
            ? AppColors.white
            : AppColors.primaryAccent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: AppTextStyles.headlineSmall.copyWith(
                              fontSize: 15,
                              fontWeight:
                                  item.isRead ? FontWeight.w500 : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(item.body, style: AppTextStyles.bodyMedium),
                    if (item.hasLink) ...[
                      const SizedBox(height: AppSizes.sm),
                      OutlinedButton.icon(
                        onPressed: onOpenLink,
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                        label: const Text('View document'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(time, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
