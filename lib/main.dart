import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/config/app_routes.dart';
import 'package:restaurant_app/config/constants.dart';
import 'package:restaurant_app/providers/ThemeProvider.dart';
import 'package:device_preview/device_preview.dart  ';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // <-- Add this
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Adjust the import to match your project

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['PROJECT_URL_SUPABASE'];
  final supabaseAnonKey = dotenv.env['ANONKEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception("Missing Supabase configuration in .env");
  }
  print("thsi url$supabaseUrl");

  // Initialize Supabase
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
  ThemeMode _themeMode = ThemeMode.system;
  final supabase = Supabase.instance.client;

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          background: AppColors.backgroundLight,
          surface: AppColors.surfaceLight,
          onPrimary: AppColors.onPrimaryLight,
          onSecondary: AppColors.onSecondaryLight,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimaryLight,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimaryLight),
          bodyLarge: TextStyle(color: AppColors.textPrimaryLight),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.onSecondaryLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,

          background: AppColors.backgroundDark,
          surface: AppColors.surfaceDark,
          onPrimary: AppColors.onPrimaryDark,
          onSecondary: AppColors.onSecondaryDark,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimaryDark),
          bodyLarge: TextStyle(color: AppColors.textPrimaryDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.onSecondaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      themeMode: themeProvider.themeMode,

      routerConfig: appRouter,
    );
  }
}
