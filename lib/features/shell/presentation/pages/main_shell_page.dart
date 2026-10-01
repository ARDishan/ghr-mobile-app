import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/login_required_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state_x.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../notifications/presentation/bloc/notifications_event.dart';
import '../../../notifications/presentation/bloc/notifications_state.dart';

/// Hosts the bottom navigation (Home / Saved / Menu) and the top bar with the
/// notification bell.
class MainShellPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainShellPage({super.key, required this.navigationShell});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  static const _titles = ['Global Housing', 'Saved Projects', 'Menu'];

  @override
  void initState() {
    super.initState();
    if (context.read<AuthBloc>().state.isCustomer) {
      context.read<NotificationsBloc>().add(const NotificationsLoadRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(_titles[index], style: AppTextStyles.headlineMedium),
        actions: const [_NotificationBell(), SizedBox(width: 8)],
      ),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.primaryAccent.withOpacity(0.35),
        selectedIndex: index,
        onDestinationSelected: (i) => widget.navigationShell.goBranch(
          i,
          initialLocation: i == index,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_rounded),
            selectedIcon: Icon(Icons.menu_open_rounded),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    final isCustomer = context.watch<AuthBloc>().state.isCustomer;

    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        final unread =
            isCustomer && state is NotificationsLoaded ? state.unreadCount : 0;
        return IconButton(
          tooltip: 'Notifications',
          onPressed: () {
            if (isCustomer) {
              context.push(RouteNames.notifications);
            } else {
              showLoginRequiredSheet(context);
            }
          },
          icon: Badge(
            isLabelVisible: unread > 0,
            label: Text(unread > 99 ? '99+' : '$unread'),
            child: const Icon(Icons.notifications_outlined,
                color: AppColors.textPrimary),
          ),
        );
      },
    );
  }
}