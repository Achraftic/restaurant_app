import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:restaurant_app/config/constants.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = 'Plats principaux';

  final List<String> categories = [
    'Entrées',
    'Plats principaux',
    'Desserts',
    'Boissons',
  ];

  final List<Map<String, dynamic>> allDishes = [
    {
      'name': 'Harira',
      'description':
          'Soupe marocaine traditionnelle aux tomates et pois chiches.',
      'price': 7.50,
      'category': 'Entrées',
      'image':
          'https://images.unsplash.com/photo-1567982047351-76b6f93e38ee?w=600',
      'likes': 60,
      'dislikes': 2,
      'comments': ['Parfait pour commencer le repas.'],
    },
    {
      'name': 'Briouates',
      'description': 'Feuilletés farcis au fromage ou à la viande.',
      'price': 6.99,
      'category': 'Entrées',
      'image':
          'https://images.unsplash.com/photo-1492470026006-0e12a33eb7fb?w=600',
      'likes': 45,
      'dislikes': 1,
      'comments': ['Croustillants et délicieux.'],
    },
    {
      'name': 'Tajine de poulet',
      'description': 'Poulet mijoté avec citron confit et olives.',
      'price': 14.99,
      'category': 'Plats principaux',
      'image':
          'https://images.unsplash.com/photo-1643995529778-7f77c082e6a4?w=600',
      'likes': 100,
      'dislikes': 3,
      'comments': ['Un classique marocain.'],
    },
    {
      'name': 'Couscous royal',
      'description': 'Couscous aux légumes, merguez et viande.',
      'price': 16.50,
      'category': 'Plats principaux',
      'image':
          'https://images.unsplash.com/photo-1615535248235-253d93813ca5?w=600',
      'likes': 150,
      'dislikes': 4,
      'comments': ['Copieux et savoureux.'],
    },
    {
      'name': 'Baghrir',
      'description': 'Crêpes mille trous au miel et beurre.',
      'price': 5.50,
      'category': 'Desserts',
      'image':
          'https://images.unsplash.com/photo-1641977915875-9b09e2ab7965?w=600',
      'likes': 35,
      'dislikes': 1,
      'comments': ['Un vrai délice !'],
    },
    {
      'name': 'Thé à la menthe',
      'description': 'Boisson traditionnelle marocaine sucrée.',
      'price': 2.50,
      'category': 'Boissons',
      'image':
          'https://images.unsplash.com/photo-1643146001923-d37e3d0b07fb?w=600',
      'likes': 70,
      'dislikes': 0,
      'comments': ['Rafraîchissant et sucré.'],
    },
  ];

  @override
  Widget build(BuildContext context) {
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemBuilder: (context, index) {
                return DishCard(dish: filteredDishes[index]);
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
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedCategory = category),
              selectedColor: AppColors.primary,
              backgroundColor: theme.colorScheme.secondary.withOpacity(0.6),
              labelStyle: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}

class DishCard extends StatefulWidget {
  final Map<String, dynamic> dish;

  const DishCard({super.key, required this.dish});

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    final theme = Theme.of(context);

    // Ensure 'isFavorite' field exists
    dish.putIfAbsent('isFavorite', () => false);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Favorite button on top-left
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  dish['image'],
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                          const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),

              // Favorite button
              Positioned(
                top: 8,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      dish['isFavorite'] = !(dish['isFavorite'] ?? false);
                    });
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      dish['isFavorite'] == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          dish['isFavorite'] == true
                              ? Colors.red
                              : Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        dish['name'],
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${dish['price'].toStringAsFixed(2)} €',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  dish['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),

                const SizedBox(height: 8),

                // Likes / Dislikes
                Row(
                  children: [
                    Icon(LucideIcons.thumbsUp, size: 24, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      '${dish['likes']}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(width: 12),
                    Icon(LucideIcons.thumbsDown, size: 24, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      '${dish['dislikes']}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Recent Comments (up to 2)
                ...List.generate(
                  dish['comments'].length.clamp(0, 2),
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          LucideIcons.messageCircle,
                          size: 24,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            dish['comments'][i],
                            style: theme.textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Comment Input Field
                TextField(
                  controller: _commentController,
                  style: theme.textTheme.bodySmall,
                  decoration: InputDecoration(
                    hintText: 'Ajouter un commentaire...',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(LucideIcons.send, size: 18),
                      onPressed: () {
                        final text = _commentController.text.trim();
                        if (text.isNotEmpty) {
                          setState(() {
                            dish['comments'].add(text);
                            _commentController.clear();
                          });
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
