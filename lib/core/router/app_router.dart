import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghr/features/projects/presentation/bloc/project_detail_bloc.dart';
import 'package:ghr/features/projects/presentation/bloc/project_detail_event.dart';
import 'package:go_router/go_router.dart';
import '../../features/about/presentation/cubit/about_cubit.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/phone_entry_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/bookmarks/presentation/pages/bookmarks_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/menu/presentation/pages/menu_page.dart';
import '../../features/my_units/domain/entities/my_unit_entity.dart';
import '../../features/my_units/presentation/bloc/my_units_bloc.dart';
import '../../features/my_units/presentation/bloc/my_units_event.dart';
import '../../features/my_units/presentation/pages/my_unit_detail_page.dart';
import '../../features/my_units/presentation/pages/my_units_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/projects/presentation/pages/project_detail_page.dart';
import '../../features/projects/presentation/pages/projects_list_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/shell/presentation/pages/main_shell_page.dart';
import '../../features/units/presentation/bloc/units_bloc.dart';
import '../../features/units/presentation/pages/units_list_page.dart';
import '../../injection_container.dart';
import 'go_router_refresh_stream.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter(this.authBloc) : _refresh = GoRouterRefreshStream(authBloc.stream) {
    router = GoRouter(
      initialLocation: RouteNames.splash,
      refreshListenable: _refresh,
      redirect: _redirect,
      routes: [
        GoRoute(
          path: RouteNames.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: RouteNames.phoneEntry,
          builder: (context, state) => const PhoneEntryPage(),
        ),
        GoRoute(
          path: RouteNames.otpVerification,
          builder: (context, state) {
            final phone = state.extra as String? ?? '';
            return OtpVerificationPage(phone: phone);
          },
        ),

        // Bottom-nav shell: Home / Saved / Menu
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              MainShellPage(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const HomePage(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: RouteNames.bookmarks,
                builder: (context, state) => const BookmarksPage(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: RouteNames.menu,
                builder: (context, state) => const MenuPage(),
              ),
            ]),
          ],
        ),

        // Full-screen pages (outside the shell)
        GoRoute(
          path: RouteNames.projects,
          builder: (context, state) => const ProjectsListPage(),
        ),
        GoRoute(
          path: RouteNames.projectDetailPattern,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return BlocProvider<ProjectDetailBloc>(
              create: (_) => sl<ProjectDetailBloc>()..add(ProjectDetailLoadRequested(id)),
              child: ProjectDetailPage(projectId: id),
            );
          },
        ),
        GoRoute(
          path: RouteNames.units,
          builder: (context, state) {
            final args = state.extra as UnitsListPageArgs;
            return BlocProvider<UnitsBloc>(
              create: (_) => sl<UnitsBloc>(),
              child: UnitsListPage(args: args),
            );
          },
        ),
        GoRoute(
          path: RouteNames.profile,
          builder: (context, state) => BlocProvider<ProfileBloc>(
            create: (_) => sl<ProfileBloc>()..add(const ProfileLoadRequested()),
            child: const ProfilePage(),
          ),
        ),
        GoRoute(
          path: RouteNames.myUnits,
          builder: (context, state) => BlocProvider<MyUnitsBloc>(
            create: (_) => sl<MyUnitsBloc>()..add(const MyUnitsLoadRequested()),
            child: const MyUnitsPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.myUnitDetail,
          builder: (context, state) {
            final unit = state.extra;
            if (unit is MyUnitEntity) return MyUnitDetailPage(unit: unit);
            return const Scaffold(body: Center(child: Text('Unit not found.')));
          },
        ),
        GoRoute(
          path: RouteNames.settings,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: RouteNames.about,
          builder: (context, state) => BlocProvider<AboutCubit>(
            create: (_) => sl<AboutCubit>()..load(),
            child: const AboutPage(),
          ),
        ),
        GoRoute(
          path: RouteNames.notifications,
          builder: (context, state) => const NotificationsPage(),
        ),
      ],
    );
  }

  final AuthBloc authBloc;
  final GoRouterRefreshStream _refresh;
  late final GoRouter router;

  String? _redirect(BuildContext context, GoRouterState state) {
    final auth = authBloc.state;
    final loc = state.matchedLocation;
    final atSplash = loc == RouteNames.splash;
    final atAuth =
        loc == RouteNames.phoneEntry || loc == RouteNames.otpVerification;

    // Logged in (customer or guest): keep them out of splash/login screens.
    if (auth is AuthAuthenticated) {
      return (atSplash || atAuth) ? RouteNames.home : null;
    }

    // Session check still running.
    if (auth is AuthInitial || (auth is AuthLoading && atSplash)) {
      return atSplash ? null : RouteNames.splash;
    }

    // Not logged in: everything except the login screens needs a session.
    return (atSplash || !atAuth) ? RouteNames.phoneEntry : null;
  }

  void dispose() {
    router.dispose();
    _refresh.dispose();
  }
}