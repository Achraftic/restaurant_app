import 'package:flutter/material.dart';
import 'package:restaurant_app/config/constants.dart';
import 'package:restaurant_app/utils/services.dart';
import 'package:restaurant_app/widgets/dish_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = 'Plats principaux';
  final List<String> categories = [
    'Plats principaux',
    'Entrées',
    'Desserts',
    'Boissons',
  ];

  List<Map<String, dynamic>> allDishes = [];
  bool _loading = true;

  Set<String> favoriteDishIds = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    // Fetch dishes
    final {'dishes': dishesResponse, 'favoris': favResponse} = await getData();

    if (mounted) {
      setState(() {
        allDishes = List<Map<String, dynamic>>.from(dishesResponse);
        favoriteDishIds =
            favResponse.map((e) => e['dish_id'] as String).toSet();
        _loading = false;
      });
    }
  }

  // Toggle favorite and update UI + backend
  void toggleFavorite(String dishId) async {
    final currentlyFav = favoriteDishIds.contains(dishId);

    setState(() {
      if (currentlyFav) {
        favoriteDishIds.remove(dishId);
      } else {
        favoriteDishIds.add(dishId);
      }
    });

    if (currentlyFav) {
      await removeFromFavoris(dishId);
    } else {
      await addToFavoris(dishId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final filteredDishes =
        allDishes
            .where((dish) => dish['category'] == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Menu Marocain')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildCategoryChips(context),
          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredDishes.length,
              itemBuilder: (context, index) {
                final dish = filteredDishes[index];
                final isFav = favoriteDishIds.contains(dish['id'].toString());
                return DishCard(
                  dish: dish,
                  isFavorite: isFav,
                  onFavoriteToggle: () => toggleFavorite(dish['id'].toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedCategory = category),
              selectedColor: AppColors.primary,
              backgroundColor: theme.colorScheme.secondary.withOpacity(0.4),
              labelStyle: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
