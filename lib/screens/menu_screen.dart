// screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:restaurant_app/config/constants.dart';
import 'package:gap/gap.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: AppColors.secondary),
            Gap(10),
            Text(
              'Our Delicious Menu',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Gap(10),
            Text(
              'Browse our amazing dishes',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
