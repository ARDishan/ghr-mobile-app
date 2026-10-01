import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/network/supabase_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';
import 'features/projects/presentation/bloc/projects_event.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: '.env');
  await SupabaseClientService.init();
  await di.init();

  runApp(const GHRealEstateApp());
}

class GHRealEstateApp extends StatefulWidget {
  const GHRealEstateApp({super.key});

  @override
  State<GHRealEstateApp> createState() => _GHRealEstateAppState();
}

class _GHRealEstateAppState extends State<GHRealEstateApp> {
  // One AuthBloc instance shared by the router (for redirects) and the widget tree.
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = di.sl<AuthBloc>()..add(const AuthCheckStatusRequested());
    _appRouter = AppRouter(_authBloc);
  }

  @override
  void dispose() {
    _appRouter.dispose();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<ProjectsBloc>(
          create: (_) => di.sl<ProjectsBloc>()..add(const ProjectsLoadRequested()),
        ),
        BlocProvider<NotificationsBloc>(create: (_) => di.sl<NotificationsBloc>()),
        BlocProvider<BookmarksCubit>(create: (_) => di.sl<BookmarksCubit>()),
      ],
      child: MaterialApp.router(
        title: 'GH Real Estate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _appRouter.router,
      ),
    );
  }
}