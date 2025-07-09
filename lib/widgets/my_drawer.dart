import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
// import 'package:restaurant_app/config/app_routes.dart';
import 'package:restaurant_app/config/constants.dart';
import 'package:restaurant_app/providers/ThemeProvider.dart';
import 'package:restaurant_app/utils/services.dart';

class MyDrawer extends StatelessWidget {
  final String name;
  final String email;
  final ThemeProvider themeProvider;

  const MyDrawer({
    super.key,
    required this.name,
    required this.email,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/124599?v=4",
                  ),
                  radius: 35,
                ),
                const Gap(12),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(4),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Drawer Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                    // Already on home screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.restaurant_menu_outlined),
                  title: const Text('Menu'),
                  onTap: () {
                    context.go('/menu');
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.favorite_outline),
                  title: const Text('favorites'),
                  onTap: () {
                    context.go('/favoris');
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profile'),
                  onTap: () {
                    context.go('/profile');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    // context.go('/settings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Contact'),
                  onTap: () {
                    // Navigator.pop(context);
                    context.go('/contact');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.pop(context);
                    // context.go('/about');
                  },
                ),
              ],
            ),
          ),

          // Drawer Footer
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (value) => themeProvider.toggleTheme(),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    logout(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
