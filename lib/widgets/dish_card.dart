import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:restaurant_app/widgets/comment_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final FocusNode _focusNode = FocusNode();
  bool isliked = false;
  bool isdisliked = false;
  bool _isUpdating = false; // Add loading state

  Future<void> _handleLike(String dishId, bool isLiked) async {
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
      rethrow; // Re-throw to handle in setLike()
    }
  }

  Future<void> _handleDislike(String dishId, bool isDisliked) async {
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
      rethrow; // Re-throw to handle in setDislike()
    }
  }

  Future<void> setLike() async {
    if (_isUpdating) return; // Prevent multiple simultaneous requests

    // Store original state for rollback
    final originalIsLiked = isliked;
    final originalIsDisliked = isdisliked;
    final originalLikes = widget.dish['likes'];
    final originalDislikes = widget.dish['dislikes'];

    setState(() {
      _isUpdating = true;
    });

    // Optimistically update UI first
    setState(() {
      if (!isdisliked) {
        // Simple like/unlike toggle
        isliked = !isliked;
        if (isliked) {
          widget.dish['likes']++;
        } else {
          widget.dish['likes']--;
        }
      } else {
        // Switching from dislike to like
        isliked = true;
        isdisliked = false;
        widget.dish['likes']++;
        widget.dish['dislikes']--;
      }
    });

    try {
      if (originalIsDisliked && !isdisliked) {
        // If we're switching from dislike to like, update both
        await Future.wait([
          _handleLike(widget.dish['id'], isliked),
          _handleDislike(widget.dish['id'], false),
        ]);
      } else {
        // Just update likes
        await _handleLike(widget.dish['id'], isliked);
      }
    } catch (e) {
      // Rollback UI changes if database update fails
      setState(() {
        isliked = originalIsLiked;
        isdisliked = originalIsDisliked;
        widget.dish['likes'] = originalLikes;
        widget.dish['dislikes'] = originalDislikes;
      });

      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update like status. Please try again.'),
          ),
        );
      }
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  Future<void> setDislike() async {
    if (_isUpdating) return; // Prevent multiple simultaneous requests

    // Store original state for rollback
    final originalIsLiked = isliked;
    final originalIsDisliked = isdisliked;
    final originalLikes = widget.dish['likes'];
    final originalDislikes = widget.dish['dislikes'];

    setState(() {
      _isUpdating = true;
    });

    // Optimistically update UI first
    setState(() {
      if (!isliked) {
        // Simple dislike/undislike toggle
        isdisliked = !isdisliked;
        if (isdisliked) {
          widget.dish['dislikes']++;
        } else {
          widget.dish['dislikes']--;
        }
      } else {
        // Switching from like to dislike
        isdisliked = true;
        isliked = false;
        widget.dish['dislikes']++;
        widget.dish['likes']--;
      }
    });

    try {
      if (originalIsLiked && !isliked) {
        // If we're switching from like to dislike, update both
        await Future.wait([
          _handleDislike(widget.dish['id'], isdisliked),
          _handleLike(widget.dish['id'], false),
        ]);
      } else {
        // Just update dislikes
        await _handleDislike(widget.dish['id'], isdisliked);
      }
    } catch (e) {
      // Rollback UI changes if database update fails
      setState(() {
        isliked = originalIsLiked;
        isdisliked = originalIsDisliked;
        widget.dish['likes'] = originalLikes;
        widget.dish['dislikes'] = originalDislikes;
      });

      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update dislike status. Please try again.'),
          ),
        );
      }
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    try {
      // Add comment to database
      await Supabase.instance.client.from('comments').insert({
        'dish_id': widget.dish['id'],
        'comment': text,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Update local state
      setState(() {
        widget.dish['comments'].add(text);
        _commentController.clear();
      });
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add comment. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    // Initialize comments and ensure dislikes field exists
    widget.dish.putIfAbsent('comments', () => []);
    widget.dish.putIfAbsent('dislikes', () => 0);
  }

  void _handleFocusChange() async {
    if (_focusNode.hasFocus) {
      // Remove listener to prevent multiple triggers
      _focusNode.removeListener(_handleFocusChange);

      // Open bottom sheet
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder:
            (context) => CommentSheet(
              dishName: widget.dish['name'],
              dishId: widget.dish['id'],
            ),
      );

      // Re-add listener after sheet closed
      _focusNode.addListener(_handleFocusChange);

      // Unfocus after sheet closes
      if (mounted) {
        _focusNode.unfocus();
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    final theme = Theme.of(context);

    dish.putIfAbsent('comments', () => []);
    dish.putIfAbsent('dislikes', () => 0);

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
                    GestureDetector(
                      onTap: _isUpdating ? null : () => setLike(),
                      child: Opacity(
                        opacity: _isUpdating ? 0.5 : 1.0,
                        child: Icon(
                          isliked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          size: 20,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('${dish['likes']}'),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _isUpdating ? null : () => setDislike(),
                      child: Opacity(
                        opacity: _isUpdating ? 0.5 : 1.0,
                        child: Icon(
                          isdisliked
                              ? Icons.thumb_down
                              : Icons.thumb_down_outlined,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
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
                  focusNode: _focusNode,
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Ajouter un commentaire...',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(LucideIcons.send, size: 18),
                      onPressed: _addComment,
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
