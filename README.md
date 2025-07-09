# Restaurant App

## Introduction

**Restaurant App** est une application mobile moderne et intuitive développée avec **Flutter** et **Supabase**, permettant aux utilisateurs de découvrir des plats, interagir avec le menu et personnaliser leur expérience culinaire.  

---

##  Features

-  **Authentification**
  - Inscription et connexion sécurisées
  - Déconnexion (Logout)

-  **Voir le menu**
  - Liste des plats avec images, description et prix

-  **Ajouter aux favoris**
  - Ajouter ou retirer un plat des favoris
  - Liste personnelle des plats favoris

-  **Ajouter un commentaire**
  - Laisser un avis sur chaque plat
  - Voir les commentaires des autres utilisateurs

-  **Likes & Dislikes**
  - Liker ou disliker un plat
  - Affichage du nombre total de likes et dislikes

-  **Mode sombre et mode clair**
  - Interface adaptée aux préférences de l’utilisateur

---

##  Stack technique

- **Frontend** : Flutter
- **Backend** : Supabase (PostgreSQL, Auth, Storage, API REST)

---

##  Installation

### Prérequis

- Flutter installé ([voir la documentation officielle](https://flutter.dev/docs/get-started/install))
- Un compte Supabase ([https://supabase.io/](https://supabase.io/))

### Étapes

#### Cloner le projet

```bash
git clone https://github.com/ton-utilisateur/restaurant-app-flutter.git
cd restaurant-app-flutter
```
#### Installer les dépendances



```bash
flutter pub get
```

#### Configurer Supabase

* Créer un projet sur Supabase
* Copier l'URL du projet et la clé `anon`
* Créer un fichier `.env` à la racine du projet et y ajouter :

```java
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

* Dans votre code Flutter (par exemple dans `lib/constants.dart`), utiliser un package comme `flutter_dotenv` pour lire ces valeurs :

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String supabaseUrl = dotenv.env['SUPABASE_URL']!;
final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
```

#### Lancer l'application

```bash
flutter run
```

---

##  Structure du projet


lib/
├── main.dart
├── screens/
│   ├── login_screen.dart
│   ├── menu_screen.dart
│   ├── favorites_screen.dart
│   └── comments_screen.dart
├── widgets/
│   ├── dish_card.dart
│   └── theme_switch.dart
├── services/
│   ├── supabase_service.dart
│   └── auth_service.dart
└── constants.dart


---

##  Fonctionnalités supplémentaires

* Dark mode & light mode supportés
* Utilisation du `Provider` ou `Riverpod` pour la gestion d’état (optionnel)
* Animations fluides avec Flutter

---

##  Sécurité

* Authentification sécurisée via Supabase
* Tokens JWT gérés côté client
* Droits d'accès configurés dans Supabase (Row Level Security)


