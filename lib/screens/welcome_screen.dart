import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:restaurant_app/providers/ThemeProvider.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

          
              CircleAvatar(
                radius: 120,
                backgroundImage: const AssetImage('assets/images/logo.png'),
                backgroundColor: theme.colorScheme.surfaceVariant,
              ),
              const SizedBox(height: 32),

            
              Text(
                'Le Gourmet Bistro',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

           
              Text(
                'Un lieu chaleureux pour savourer des plats faits maison avec des ingrédients frais.',
                style: textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

           
              Card(
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _InfoRow(
                        icon: LucideIcons.mapPin,
                        text: '123 Rue de Paris, 75001 Paris, France',
                      ),
                      SizedBox(height: 16),
                      _InfoRow(
                        icon: LucideIcons.phone,
                        text: '+33 1 23 45 67 89',
                      ),
                      SizedBox(height: 16),
                      _InfoRow(
                        icon: LucideIcons.clock,
                        text: 'Ouvert de 12h à 22h, 7j/7',
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

       
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(LucideIcons.arrowRight),
                  onPressed: () => context.go('/home'),

                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  label: const Text(
                    'Entrer',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.9),
            ),
          ),
        ),
      ],
    );
  }
}
