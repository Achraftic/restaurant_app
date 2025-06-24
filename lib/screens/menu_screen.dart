import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:restaurant_app/config/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  List<Map<String, dynamic>> allDishes = [];
  bool _loading = true;

  Set<String> favoriteDishIds = {}; // Store favorite dish IDs for current user

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    // Fetch dishes
    final dishesResponse = await Supabase.instance.client
        .from('dishes')
        .select('*');
    // Fetch favorites for current user
    final userId = Supabase.instance.client.auth.currentUser?.id;
    List<dynamic> favResponse = [];
    if (userId != null) {
      favResponse = await Supabase.instance.client
          .from('favoris')
          .select('dish_id')
          .eq('user_id', userId);
    }

    if (mounted) {
      setState(() {
        allDishes = List<Map<String, dynamic>>.from(dishesResponse);
        favoriteDishIds =
            favResponse.map((e) => e['dish_id'] as String).toSet();
        _loading = false;
      });
    }
  }

  // Add dish to favorites
  Future<void> addToFavoris(String dishId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await Supabase.instance.client.from('favoris').insert({
      'user_id': userId,
      'dish_id': dishId,
    });
    // <--- Important!

    if (response.error != null) {
      throw Exception('Failed to add favorite: ${response.error!.message}');
    }
  }

  // Remove dish from favorites
  Future<void> removeFromFavoris(String dishId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final response = await Supabase.instance.client
        .from('favoris')
        .delete()
        .match({'user_id': userId, 'dish_id': dishId});

    if (response.error != null) {
      throw Exception('Failed to remove favorite: ${response.error!.message}');
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
          TextButton(onPressed: _loadData, child: const Text("Rafraîchir")),
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
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedCategory = category),
              selectedColor: AppColors.primary,
              backgroundColor: theme.colorScheme.secondary.withOpacity(0.6),
              labelStyle: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}

class DishCard extends StatefulWidget {
  final Map<String, dynamic> dish;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const DishCard({
    super.key,
    required this.dish,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

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

    dish.putIfAbsent('comments', () => []);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  dish['image'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                          const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
              Positioned(
                top: 8,
                right: 10,
                child: GestureDetector(
                  onTap: widget.onFavoriteToggle,
                  child: CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: Icon(
                      widget.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.white,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        dish['name'],
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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
                Text(
                  dish['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(LucideIcons.thumbsUp, size: 20, color: Colors.green),
                    const SizedBox(width: 4),
                    Text('${dish['likes']}'),
                    const SizedBox(width: 12),
                    Icon(LucideIcons.thumbsDown, size: 20, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('${dish['dislikes']}'),
                  ],
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  dish['comments'].length.clamp(0, 2),
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.messageCircle,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            dish['comments'][i],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _commentController,
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
