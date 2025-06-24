import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
