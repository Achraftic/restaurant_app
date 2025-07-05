import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/config/constants.dart';
import 'package:restaurant_app/providers/ThemeProvider.dart';
import 'package:restaurant_app/utils/fakedata.dart';
import 'package:restaurant_app/widgets/food_card.dart';
import 'package:restaurant_app/widgets/my_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodItem {
  final String name;
  final String imageUrl;
  final double price;

  FoodItem({required this.name, required this.imageUrl, required this.price});
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final user = Supabase.instance.client.auth.currentUser;
    final String name = user?.userMetadata?['full_name'] ?? 'Invité';
    final String email = user?.email ?? 'guest@example.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            tooltip: 'Search',
            iconSize: 28,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            tooltip: 'Notifications',
            iconSize: 28,
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: MyDrawer(name: name, email: email, themeProvider: themeProvider),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promo banner
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1677175245494-dc306351b541?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.multiply,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Special Discount',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const Gap(8),
                  const Text(
                    'Up to 50% off your favorite dishes!',
                    style: TextStyle(
                      fontSize: 24,

                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(12),
                  SizedBox(
                    width: 140,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => context.go('/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Get it now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Gap(30),

            // Featured Dishes
            Text(
              'Featured Dishes',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featuredDishes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final dish = featuredDishes[index];
                  return FoodCard(
                    dish: dish,

                    elevation: 3,
                    priceColor: Colors.deepOrange,
                  );
                },
              ),
            ),

            const Gap(30),

            // Today's Deals
            Text(
              "Today's Deals",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(12),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: todaysDeals.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final deal = todaysDeals[index];
                  return FoodCard(
                    dish: deal,

                    elevation: 4,
                    priceColor: Colors.deepOrange,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
