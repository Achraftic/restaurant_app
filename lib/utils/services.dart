import 'package:flutter/material.dart';
import 'package:restaurant_app/widgets/dish_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> addToFavoris(String dishId) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) {
    throw Exception('User not authenticated');
  }

  final response = await Supabase.instance.client.from('favoris').insert({
    'user_id': userId,
    'dish_id': dishId,
  });

  if (response.error != null) {
    throw Exception('Failed to add favorite: ${response.error!.message}');
  }
}

Future<Map<String, List>> getData() async {
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

  return {'dishes': dishesResponse, 'favoris': favResponse};
}

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

Future<PostgrestList?> getFavoris() async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return null;

  final response = await Supabase.instance.client
      .from('favoris')
      .select(
        'id, dish_id, dishes(id, name, image, price, description, likes, dislikes)',
      )
      .eq('user_id', userId);

  return response;
}

Future<void> logout(BuildContext context) async {
  await Supabase.instance.client.auth.signOut();

  if (context.mounted) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}

Future<AuthResponse> SignIn(
  String email,
  String password,
  BuildContext context,
) async {
  final response = await Supabase.instance.client.auth.signInWithPassword(
    email: email,
    password: password,
  );

  return response;
}

Future<AuthResponse> SignUp(
  String email,
  String password,
  String full_name,
  BuildContext context,
) async {
  final response = await Supabase.instance.client.auth.signUp(
    email: email,
    password: password,
    data: {'full_name': full_name},
  );

  return response;
}

Future<void> handleLike(String dishId, bool isLiked, DishCard widget) async {
  try {
    await Supabase.instance.client
        .from('dishes')
        .update({
          'likes':
              isLiked ? widget.dish['likes'] + 1 : widget.dish['likes'] - 1,
        })
        .eq('id', dishId);
  } catch (e) {
    // Handle the error appropriately
    print('Error updating like status: $e');
    rethrow;
  }
}

Future<void> handleDislike(
  String dishId,
  bool isDisliked,
  DishCard widget,
) async {
  try {
    await Supabase.instance.client
        .from('dishes')
        .update({
          'dislikes':
              isDisliked
                  ? widget.dish['dislikes'] + 1
                  : widget.dish['dislikes'] - 1,
        })
        .eq('id', dishId);
  } catch (e) {
    // Handle the error appropriately
    print('Error updating dislike status: $e');
    rethrow;
  }
}

Future<PostgrestList> getComments(String dishId) async {
  final response = await Supabase.instance.client
      .from('comments')
      .select('content,id')
      .eq('dish_id', dishId);

  return response;
}

Future<dynamic> AddCommentToSpecifiqueDish(
  String comment,
  String dishId,
) async {
  final response = await Supabase.instance.client.from('comments').insert({
    'dish_id': dishId,
    'content': comment,
    'user_id': Supabase.instance.client.auth.currentUser?.id,
  });

  return response;
}

Future<void> deleteComment(String commentId) async {
  await Supabase.instance.client.from('comments').delete().match({
    'id': commentId,
  });
}
