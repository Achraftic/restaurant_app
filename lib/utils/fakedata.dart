  // final allDishes = [
  //   {
  //     'name': 'Harira',
  //     'description':
  //         'Soupe marocaine traditionnelle aux tomates et pois chiches.',
  //     'price': 7.50,
  //     'category': 'Entrées',
  //     'image':
  //         'https://images.unsplash.com/photo-1567982047351-76b6f93e38ee?w=600',
  //     'likes': 60,
  //     'dislikes': 2,
  //     'comments': ['Parfait pour commencer le repas.'],
  //   },
  //   {
  //     'name': 'Briouates',
  //     'description': 'Feuilletés farcis au fromage ou à la viande.',
  //     'price': 6.99,
  //     'category': 'Entrées',
  //     'image':
  //         'https://images.unsplash.com/photo-1492470026006-0e12a33eb7fb?w=600',
  //     'likes': 45,
  //     'dislikes': 1,
  //     'comments': ['Croustillants et délicieux.'],
  //   },
  //   {
  //     'name': 'Tajine de poulet',
  //     'description': 'Poulet mijoté avec citron confit et olives.',
  //     'price': 14.99,
  //     'category': 'Plats principaux',
  //     'image':
  //         'https://images.unsplash.com/photo-1643995529778-7f77c082e6a4?w=600',
  //     'likes': 100,
  //     'dislikes': 3,
  //     'comments': ['Un classique marocain.'],
  //   },
  //   {
  //     'name': 'Couscous royal',
  //     'description': 'Couscous aux légumes, merguez et viande.',
  //     'price': 16.50,
  //     'category': 'Plats principaux',
  //     'image':
  //         'https://images.unsplash.com/photo-1615535248235-253d93813ca5?w=600',
  //     'likes': 150,
  //     'dislikes': 4,
  //     'comments': ['Copieux et savoureux.'],
  //   },
  //   {
  //     'name': 'Baghrir',
  //     'description': 'Crêpes mille trous au miel et beurre.',
  //     'price': 5.50,
  //     'category': 'Desserts',
  //     'image':
  //         'https://images.unsplash.com/photo-1641977915875-9b09e2ab7965?w=600',
  //     'likes': 35,
  //     'dislikes': 1,
  //     'comments': ['Un vrai délice !'],
  //   },
  //   {
  //     'name': 'Thé à la menthe',
  //     'description': 'Boisson traditionnelle marocaine sucrée.',
  //     'price': 2.50,
  //     'category': 'Boissons',
  //     'image':
  //         'https://images.unsplash.com/photo-1643146001923-d37e3d0b07fb?w=600',
  //     'likes': 70,
  //     'dislikes': 0,
  //     'comments': ['Rafraîchissant et sucré.'],
  //   },
  // ];
 import 'package:restaurant_app/screens/home_screen.dart';

final featuredDishes = [
      FoodItem(
        name: 'Burger',
        imageUrl:
            'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=800&q=80',
        price: 5.99,
      ),
      FoodItem(
        name: 'Pizza',
        imageUrl:
            'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGl6emF8ZW58MHx8MHx8fDA%3D',
        price: 7.99,
      ),
      FoodItem(
        name: 'Pasta',
        imageUrl:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80',
        price: 6.49,
      ),
    ];

    final todaysDeals = [
      FoodItem(
        name: 'Grilled Salmon',
        imageUrl:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80',
        price: 12.99,
      ),
      FoodItem(
        name: 'Steak',
        imageUrl:
            'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fEZPT0R8ZW58MHx8MHx8fDA%3D',
        price: 18.99,
      ),
      FoodItem(
        name: 'Caesar Salad',
        imageUrl:
            'https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&w=800&q=80',
        price: 7.49,
      ),
    ];
