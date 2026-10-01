import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_sizes.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/notifications_entity.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  Future<void> _refresh(BuildContext context) {
    final completer = Completer<void>();
    context
        .read<NotificationsBloc>()
        .add(NotificationsLoadRequested(completer: completer));
    return completer.future;
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppErrorWidget(message: state.message),
                TextButton(
                  onPressed: () => context
                      .read<NotificationsBloc>()
                      .add(const NotificationsLoadRequested()),
                  child: const Text('Try again'),
                ),
              ],
            );
          }
          if (state is NotificationsLoaded) {
            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: state.items.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),
                        Icon(Icons.notifications_none_rounded,
                            size: 56, color: AppColors.grey400),
                        SizedBox(height: AppSizes.md),
                        Center(child: Text('You have no notifications yet.')),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: AppSizes.pagePadding,
                      itemCount: state.items.length,
                      itemBuilder: (context, index) => _NotificationTile(
                        item: state.items[index],
                        onTap: () => context
                            .read<NotificationsBloc>()
                            .add(NotificationsMarkReadRequested(
                                [state.items[index].id])),
                      ),
                    ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity item;
  final VoidCallback onTap;
  const _NotificationTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('d MMM yyyy, h:mm a').format(item.createdAt.toLocal());
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: item.isRead ? AppColors.white : AppColors.primaryAccent.withOpacity(0.18),
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
              Padding(
                padding: const EdgeInsets.only(top: 6, right: 10),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.isRead ? Colors.transparent : AppColors.primary,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: AppTextStyles.headlineSmall.copyWith(
                            fontSize: 15,
                            fontWeight:
                                item.isRead ? FontWeight.w500 : FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(item.body, style: AppTextStyles.bodyMedium),
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