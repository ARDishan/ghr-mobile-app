import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/network/supabase_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
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

class GHRealEstateApp extends StatelessWidget {
  const GHRealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(const AuthCheckStatusRequested()),
        ),
        BlocProvider<ProjectsBloc>(
          create: (_) => di.sl<ProjectsBloc>()..add(const ProjectsLoadRequested()),
        ),
      ],
      child: MaterialApp.router(
        title: 'GH Real Estate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}