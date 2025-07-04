import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_handleFocusChange);

    // Initialize comments if not present
    widget.dish.putIfAbsent('comments', () => []);
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

class CommentSheet extends StatefulWidget {
  final String dishName;
  final String dishId;
  const CommentSheet({super.key, required this.dishName, required this.dishId});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> Allcomments = [];
  final user = Supabase.instance.client.auth.currentUser;
  bool _loading = true;
  Future<void> _getComments() async {
    try {
      final response = await Supabase.instance.client
          .from('comments')
          .select('content')
          .eq('dish_id', widget.dishId);

      // Map to a list of comment + username strings or a structured model
      setState(() {
        Allcomments = List<Map<String, dynamic>>.from(response);
        _loading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleCommentSubmit() async {
    try {
      final response = await Supabase.instance.client.from('comments').insert({
        'dish_id': widget.dishId,
        'content': _controller.text,
        'user_id': Supabase.instance.client.auth.currentUser?.id,
      });
      setState(() {
        Allcomments.add({"content": _controller.text});
        _controller.clear();
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getComments();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(child: Center(child: CircularProgressIndicator()));
    }
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                'Commentaires sur ${widget.dishName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child:
                    Allcomments.isEmpty
                        ? const Center(
                          child: Text('Aucun commentaire pour le moment.'),
                        )
                        : ListView.builder(
                          controller: scrollController,
                          itemCount: Allcomments.length,
                          itemBuilder:
                              (context, index) => ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text("ACHRAF"),
                                subtitle: Text(Allcomments[index]["content"]),
                              ),
                        ),
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Ajouter un commentaire...",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _handleCommentSubmit,
                  ),
                ),
                onSubmitted: (_) => _handleCommentSubmit(),
              ),
            ],
          ),
        );
      },
    );
  }
}
