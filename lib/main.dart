import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/config/app_routes.dart';
import 'package:restaurant_app/config/constants.dart';
import 'package:restaurant_app/providers/ThemeProvider.dart';
import 'package:device_preview/device_preview.dart  ';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/widgets/theme_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['PROJECT_URL_SUPABASE'];
  final supabaseAnonKey = dotenv.env['ANONKEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception("Missing Supabase configuration in .env");
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder:
          (context) => ChangeNotifierProvider(
            create: (_) => ThemeProvider(),
            child: const MyApp(),
          ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,

      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: themeProvider.themeMode,

      routerConfig: appRouter,
    );
  }
}
