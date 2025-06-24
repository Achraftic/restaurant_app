import 'package:flutter/material.dart';
import 'package:restaurant_app/config/constants.dart';
import 'package:restaurant_app/screens/home_screen.dart';

class FoodCard extends StatelessWidget {
  final FoodItem dish;
  final double elevation;
  final Color priceColor;

  /// Optional: provide a background color override, otherwise it auto-selects based on theme.
  final Color? backgroundColor;

  const FoodCard({
    super.key,
    required this.dish,
    required this.elevation,
    required this.priceColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ??
        (isDark ? AppColors.onSecondaryLight : AppColors.backgroundLight);

    return SizedBox(
      width: 160,
      child: Card(
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: elevation,
        shadowColor: Colors.black.withOpacity(0.2),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                dish.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Icons.broken_image, size: 40));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 15, 0, 3),
              child: Text(
                dish.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '\$${dish.price.toStringAsFixed(2)}',
                style: TextStyle(color: priceColor, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
