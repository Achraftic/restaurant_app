import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;

  const BottomNavShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _getCurrentIndex(context),
          onTap: (index) => _onItemTapped(context, index),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(
            context,
          ).colorScheme.onSurface.withOpacity(0.5),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedIconTheme: const IconThemeData(size: 24),
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.home),
              activeIcon: Icon(LucideIcons.home),
              label: 'Home',
              tooltip: 'Navigate to Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.utensils),
              activeIcon: Icon(LucideIcons.utensils),
              label: 'Menu',
              tooltip: 'Navigate to Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.heart),
              activeIcon: Icon(LucideIcons.heart),
              label: 'Favoris',
              tooltip: 'Navigate to Favoris',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user),
              activeIcon: Icon(LucideIcons.user),
              label: 'Profile',
              tooltip: 'Navigate to Profile',
            ),
          ],
        ),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    switch (location) {
      case '/home':
        return 0;
      case '/menu':
        return 1;
      case '/favoris':
        return 2;
      case '/profile':
        return 3;
      default:
        return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/menu');
        break;
      case 2:
        context.go('/favoris');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
