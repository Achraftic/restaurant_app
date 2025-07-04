import 'package:flutter/material.dart';
import 'package:restaurant_app/widgets/dish_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavorisScreen extends StatefulWidget {
  const FavorisScreen({super.key});

  @override
  State<FavorisScreen> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen> {
  List<Map<String, dynamic>> favoris = [];
  Set<String> favoriteDishIds = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoris();
  }

  Future<void> _fetchFavoris() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final response = await Supabase.instance.client
        .from('favoris')
        .select(
          'id, dish_id, dishes(id, name, image, price, description, likes, dislikes)',
        )
        .eq('user_id', userId);

    final dishList = List<Map<String, dynamic>>.from(response);

    if (mounted) {
      setState(() {
        favoris = dishList;
        favoriteDishIds =
            dishList.map((fav) => fav['dish_id'].toString()).toSet();
        loading = false;
      });
    }
  }

  Future<void> removeFromFavoris(String dishId) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    await Supabase.instance.client.from('favoris').delete().match({
      'user_id': userId,
      'dish_id': dishId,
    });
  }

  void toggleFavorite(String dishId) async {
    final isFav = favoriteDishIds.contains(dishId);

    setState(() {
      if (isFav) {
        favoriteDishIds.remove(dishId);
        favoris.removeWhere((fav) => fav['dish_id'] == dishId);
      } else {
        favoriteDishIds.add(dishId);
        // Optional: You can re-fetch to refresh UI
      }
    });

    await removeFromFavoris(dishId);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris'), centerTitle: true),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : favoris.isEmpty
              ? const Center(child: Text("Aucun favori trouvé."))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: favoris.length,
                itemBuilder: (context, index) {
                  final fav = favoris[index];
                  final dish = fav['dishes'];
                  final dishId = dish['id'].toString();

                  return DishCard(
                    
                    dish: dish,
                    isFavorite: favoriteDishIds.contains(dishId),
                    onFavoriteToggle: () => toggleFavorite(dishId),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchFavoris,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
