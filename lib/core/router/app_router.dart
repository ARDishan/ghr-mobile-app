import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/phone_entry_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/projects/presentation/pages/project_detail_page.dart';
import '../../features/projects/presentation/pages/projects_list_page.dart';
import 'route_names.dart';

/// go_router configuration.
/// TODO: add a `redirect` based on AuthBloc state once splash/session
/// restoration logic is finalized (currently starts directly at phone entry).
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.phoneEntry,
    routes: [
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
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.projects,
        builder: (context, state) => const ProjectsListPage(),
      ),
      GoRoute(
        path: RouteNames.projectDetailPattern,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProjectDetailPage(projectId: id);
        },
      ),
    ],
  );
}