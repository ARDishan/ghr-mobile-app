import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;

// TODO: wire up GoRouter (core/router/app_router.dart) and Supabase
// initialization (core/network/supabase_client.dart) before running.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await di.init();
  runApp(const GHRealEstateApp());
}

class GHRealEstateApp extends StatelessWidget {
  const GHRealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GH Real Estate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // TODO: replace with GoRouter (routerConfig: AppRouter.router).
      home: const Scaffold(body: Center(child: Text('GHR'))),
    );
  }
}
