import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
          'https://images.unsplash.com/photo-1567982047351-76b6f93e38ee?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8bW9yb2NjbyUyMGZvb2R8ZW58MHx8MHx8fDA%3D',
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
          'https://images.unsplash.com/photo-1492470026006-0e12a33eb7fb?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fG1vcm9jY28lMjBmb29kfGVufDB8fDB8fHww',
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
          'https://images.unsplash.com/photo-1643995529778-7f77c082e6a4?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzR8fG1vcm9jY28lMjBmb29kfGVufDB8fDB8fHww',
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
          'https://images.unsplash.com/photo-1615535248235-253d93813ca5?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTF8fG1vcm9jY28lMjBmb29kfGVufDB8fDB8fHww',
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
          'https://images.unsplash.com/photo-1641977915875-9b09e2ab7965?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTh8fG1vcm9jY28lMjBmb29kfGVufDB8fDB8fHww',
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
          'https://images.unsplash.com/photo-1643146001923-d37e3d0b07fb?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjZ8fG1vcm9jY28lMjBmb29kfGVufDB8fDB8fHww',
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
      resizeToAvoidBottomInset:
          true, // ✅ Prevent overflow when keyboard appears
      body: Column(
        children: [
          // 🔽 Category Selector
          SizedBox(
            height: 50,
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
                    onSelected:
                        (_) => setState(() {
                          selectedCategory = category;
                        }),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // 🧾 Grid of Dishes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredDishes.length,
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior
                      .onDrag, // ✅ Dismiss keyboard on scroll

              itemBuilder: (context, index) {
                return DishCard(dish: filteredDishes[index]);
              },
            ),
          ),
        ],
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

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ Dish Image
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.network(
              dish['image'],
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.image_not_supported)),
            ),
          ),

          // 📋 Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🍽️ Name & Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        dish['name'],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${dish['price'].toStringAsFixed(2)} €',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // 📝 Description
                Text(
                  dish['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(LucideIcons.thumbsUp, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text('${dish['likes']}', style: theme.textTheme.labelSmall),
                    const SizedBox(width: 12),
                    Icon(LucideIcons.thumbsDown, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      '${dish['dislikes']}',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 💬 Short Comments (2 max)
                if (dish['comments'].isNotEmpty)
                  ...List.generate(
                    dish['comments'].length > 2 ? 2 : dish['comments'].length,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            LucideIcons.messageCircle,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              dish['comments'][i],
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 6),

                // ➕ Add Comment Field
                TextField(
                  controller: _commentController,
                  style: theme.textTheme.bodySmall,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    hintText: 'Ajouter...',
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
