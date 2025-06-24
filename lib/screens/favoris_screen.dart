import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavorisScreen extends StatefulWidget {
  const FavorisScreen({super.key});

  @override
  State<FavorisScreen> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen> {
  List<dynamic> favoris = [];
  bool loading = true;

  Future<void> _fetchFavoris() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final response = await Supabase.instance.client
        .from('favoris')
        .select('id, dish_id, dishes(name, image, price)')
        .eq('user_id', userId as Object);

    print('Favoris: ${response}');

    if (mounted) {
      setState(() {
        favoris = response;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFavoris();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris'), centerTitle: true),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: favoris.length,
                itemBuilder: (context, index) {
                  final fav = favoris[index];
                  final dish = fav['dishes'];
                  // final user = fav['users'];
                  return ListTile(
                    leading: Image.network(
                      dish['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(dish['name']),
                    // subtitle: Text('${dish['price']} € - ${user['email']}'),
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
