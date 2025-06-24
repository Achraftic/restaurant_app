import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/screens/favoris_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/auth/signin_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/menu_screen.dart';

import '../screens/profile_screen.dart';
import '../screens/welcome_screen.dart';
import '../widgets/bottom_nav_shell.dart';

/// Auth state listener to trigger router refresh
class SupabaseAuthNotifier extends ChangeNotifier {
  SupabaseAuthNotifier() {
    Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/welcome',

  /// Listen to auth changes
  refreshListenable: SupabaseAuthNotifier(),

  /// Redirect logic
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;
    final location = state.uri.toString();

    final isAuthRoute =
        location.startsWith('/login') ||
        location.startsWith('/signUp') ||
        location.startsWith('/welcome');

    // If not logged in, redirect to login
    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }

    // If already logged in, prevent going to login/signup/welcome
    if (isLoggedIn && isAuthRoute) {
      return '/home';
    }

    return null; // allow navigation
  },

  routes: [
    // Shell route for bottom navigation bar
    ShellRoute(
      builder: (context, state, child) => BottomNavShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/menu',
          name: 'menu',
          builder: (context, state) => const MenuScreen(),
        ),
        GoRoute(
          path: '/favoris',
          name: 'favoris',
          builder: (context, state) => const FavorisScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // Authentication and entry routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/signUp',
      name: 'signup',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
  ],
);
