import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../providers/recipe_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/recipe_model.dart';
import '../services/firebase_service.dart';
import 'recipe_detail_screen.dart';
import 'profile_features/order_history_screen.dart';
import 'profile_features/manage_addresses_screen.dart';
import 'profile_features/payment_methods_screen.dart';
import 'profile_features/notifications_settings_screen.dart';
import 'profile_features/security_privacy_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeLocation = '15 Water Street Fremont';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Resolves category to visual emoji and label matching elite food delivery apps
  String _getCategoryLabelWithEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'all': return '🍽️ All';
      case 'burger': return '🍔 Burger';
      case 'pizza': return '🍕 Pizza';
      case 'pasta': return '🍝 Pasta';
      case 'salad': return '🥗 Salad';
      case 'drinks': return '🥤 Drinks';
      default: return '🍔 $category';
    }
  }

  // Displays a beautiful Bottom Sheet selector to switch locations dynamically
  void _showLocationSelector(BuildContext context) {
    final List<String> mockLocations = [
      '15 Water Street Fremont',
      '88 Gourmet Boulevard',
      '104 Baker Avenue Suite C',
      '12 Olive Garden Lane',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bottom sheet drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                'Select Delivery Address',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              ...mockLocations.map((loc) {
                final bool isSelected = _activeLocation == loc;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6366F1).withOpacity(0.06) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on_rounded,
                      color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF64748B),
                    ),
                    title: Text(
                      loc,
                      style: TextStyle(
                        color: const Color(0xFF0F172A),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF6366F1))
                        : null,
                    onTap: () {
                      setState(() {
                        _activeLocation = loc;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Generates and adds sample recipe data directly to Firestore matching the mockup UI
  void _addSampleRecipes(BuildContext context) async {
    final firebaseService = FirebaseService();
    final sampleRecipes = [
      // BURGERS
      RecipeModel(
        id: '',
        title: 'Chicken Burger',
        category: 'Burger',
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=600',
        cookTimeMinutes: 15,
        servings: 1,
        ingredients: ['Crispy Chicken Patty', 'Brioche Bun', 'Lettuce', 'Mayonnaise', 'Cheddar Cheese'],
        instructions: ['Fry the crispy chicken patty.', 'Toast the brioche bun.', 'Assemble with lettuce, cheese, and mayonnaise.'],
        price: 30.00,
        calories: 500,
        restaurant: 'Cookie Heaven',
      ),
      RecipeModel(
        id: '',
        title: 'BBQ Bacon Burger',
        category: 'Burger',
        imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=600',
        cookTimeMinutes: 18,
        servings: 1,
        ingredients: ['Flame Grilled Beef', 'Bacon Strips', 'BBQ Sauce', 'Onion Rings', 'Brioche Bun'],
        instructions: ['Flame grill the beef patty.', 'Crisp the bacon.', 'Layer on toasted bun with BBQ sauce and onion rings.'],
        price: 32.00,
        calories: 580,
        restaurant: 'Grill Station',
      ),
      // PIZZAS
      RecipeModel(
        id: '',
        title: 'Margherita Pizza',
        category: 'Pizza',
        imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?q=80&w=600',
        cookTimeMinutes: 12,
        servings: 2,
        ingredients: ['Pizza Dough', 'San Marzano Tomato Sauce', 'Fresh Mozzarella', 'Fresh Basil Leaves', 'Extra Virgin Olive Oil'],
        instructions: ['Roll out pizza dough.', 'Spread tomato sauce and Mozzarella.', 'Bake in stone oven, garnish with fresh basil and olive oil.'],
        price: 24.00,
        calories: 420,
        restaurant: 'Bella Italia',
      ),
      RecipeModel(
        id: '',
        title: 'Pepperoni Feast',
        category: 'Pizza',
        imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?q=80&w=600',
        cookTimeMinutes: 14,
        servings: 2,
        ingredients: ['Pizza Dough', 'Marinara Sauce', 'Spicy Pepperoni Slices', 'Mozzarella', 'Oregano'],
        instructions: ['Preheat oven.', 'Layer marinara, cheese, and a generous layer of pepperoni.', 'Bake until crust is golden brown.'],
        price: 28.00,
        calories: 520,
        restaurant: 'Bella Italia',
      ),
      // PASTAS
      RecipeModel(
        id: '',
        title: 'Creamy Alfredo Pasta',
        category: 'Pasta',
        imageUrl: 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?q=80&w=600',
        cookTimeMinutes: 15,
        servings: 1,
        ingredients: ['Fettuccine Pasta', 'Heavy Cream', 'Parmesan Cheese', 'Garlic', 'Butter', 'Parsley'],
        instructions: ['Boil Fettuccine.', 'Sauté garlic in butter, add heavy cream and Parmesan to simmer.', 'Toss pasta in Alfredo sauce, garnish with parsley.'],
        price: 22.00,
        calories: 380,
        restaurant: 'Pasta Garden',
      ),
      RecipeModel(
        id: '',
        title: 'Spicy Carbonara',
        category: 'Pasta',
        imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?q=80&w=600',
        cookTimeMinutes: 15,
        servings: 1,
        ingredients: ['Spaghetti', 'Pancetta', 'Egg Yolks', 'Pecorino Romano', 'Black Pepper', 'Chili Flakes'],
        instructions: ['Crisp pancetta.', 'Whisk egg yolks and cheese.', 'Toss hot spaghetti with egg mixture, bacon, black pepper, and chili flakes.'],
        price: 25.00,
        calories: 410,
        restaurant: 'Pasta Garden',
      ),
      // SALADS
      RecipeModel(
        id: '',
        title: 'Classic Caesar Salad',
        category: 'Salad',
        imageUrl: 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?q=80&w=600',
        cookTimeMinutes: 8,
        servings: 1,
        ingredients: ['Romaine Lettuce', 'Garlic Croutons', 'Parmesan Shavings', 'Caesar Dressing', 'Grilled Chicken Breast'],
        instructions: ['Chop fresh romaine lettuce.', 'Toss with croutons, dressing, and parmesan shavings.', 'Top with sliced grilled chicken breast.'],
        price: 18.00,
        calories: 220,
        restaurant: 'Green Leaf',
      ),
      RecipeModel(
        id: '',
        title: 'Avocado Quinoa Bowl',
        category: 'Salad',
        imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=600',
        cookTimeMinutes: 10,
        servings: 1,
        ingredients: ['Quinoa', 'Ripe Avocado', 'Cherry Tomatoes', 'Cucumber', 'Spinach', 'Lemon Vinaigrette'],
        instructions: ['Cook quinoa.', 'Dice avocado, cucumber, and tomatoes.', 'Combine over fresh spinach with a drizzle of vinaigrette.'],
        price: 20.00,
        calories: 280,
        restaurant: 'Green Leaf',
      ),
      // DRINKS
      RecipeModel(
        id: '',
        title: 'Berry Lemonade',
        category: 'Drinks',
        imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?q=80&w=600',
        cookTimeMinutes: 5,
        servings: 1,
        ingredients: ['Fresh Lemon Juice', 'Strawberry Puree', 'Sparkling Water', 'Mint Leaves', 'Ice Cubes'],
        instructions: ['Mix lemon juice with strawberry puree.', 'Top with sparkling water.', 'Stir and garnish with fresh mint and ice.'],
        price: 8.00,
        calories: 95,
        restaurant: 'Juice Bar',
      ),
      RecipeModel(
        id: '',
        title: 'Iced Matcha Latte',
        category: 'Drinks',
        imageUrl: 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?q=80&w=600',
        cookTimeMinutes: 5,
        servings: 1,
        ingredients: ['Ceremonial Matcha Powder', 'Warm Water', 'Oat Milk', 'Agave Syrup', 'Ice'],
        instructions: ['Whisk matcha powder in warm water until frothy.', 'Fill glass with ice and oat milk.', 'Pour matcha over milk and sweeten with agave.'],
        price: 9.50,
        calories: 120,
        restaurant: 'Matcha Cafe',
      ),
    ];

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
        ),
      );

      // Clean/flush the existing database recipes first to avoid duplicates or old burger-only clutter!
      final existingSnapshot = await FirebaseFirestore.instance.collection('recipes').get();
      for (var doc in existingSnapshot.docs) {
        await doc.reference.delete();
      }

      for (var recipe in sampleRecipes) {
        await firebaseService.addRecipe(recipe);
      }

      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully loaded ${sampleRecipes.length} premium dishes across 5 categories!'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add samples: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Crisp White Background
      body: Stack(
        children: [
          // 1. Light Ambient Gradient Blur Decorations
          Positioned(
            top: -150,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.06), // Soft Lavender/Indigo
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEC4899).withOpacity(0.04), // Soft Pink
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // 2. Main Tab Body Content
          SafeArea(
            child: _buildTabBody(context),
          ),

          // 3. Custom Bottom Elevated Navigation Bar
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFF1F5F9), // Thin light-gray border
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_rounded, 'Home'),
                  _buildNavItem(1, Icons.shopping_bag_outlined, 'My Order'),
                  _buildNavItem(2, Icons.favorite_border_rounded, 'Saved'),
                  _buildNavItem(3, Icons.person_outline_rounded, 'Profile'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Switches between active tabs
  Widget _buildTabBody(BuildContext context) {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomeTab(context);
      case 1:
        return _buildCartTab(context);
      case 2:
        return _buildSavedTab(context);
      case 3:
        return _buildProfileTab(context);
      default:
        return _buildHomeTab(context);
    }
  }

  // Navigation Items with Dynamic Cart Count Badge
  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _currentNavIndex == index;
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent, // Broaden tap target
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? const Color(0xFFEC4899) : const Color(0xFF94A3B8),
                  size: 22,
                ),
                if (label == 'My Order' && cartProvider.itemCount > 0)
                  Positioned(
                    top: -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEC4899), // Neon Pink badge
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cartProvider.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (label == 'Saved' && favoritesProvider.favoriteIds.isNotEmpty)
                  Positioned(
                    top: -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEC4899), // Neon Pink badge
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${favoritesProvider.favoriteIds.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFEC4899) : const Color(0xFF94A3B8),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 0: HOME SCREEN UI =================
  Widget _buildHomeTab(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    // Filter recipes locally by category AND search query
    final filteredRecipes = recipeProvider.recipes.where((recipe) {
      final matchesSearch = recipe.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.restaurant.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = recipeProvider.selectedCategory == 'All' ||
          recipe.category.toLowerCase() == recipeProvider.selectedCategory.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Custom Header (Location & Icons)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Interactive Location Selector Display
              GestureDetector(
                onTap: () => _showLocationSelector(context),
                child: Container(
                  color: Colors.transparent, // Broaden tap target
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFFEC4899), // Accent Pink Pin
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _activeLocation,
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF64748B).withOpacity(0.7),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              // Action Icons
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border_rounded, color: Color(0xFF0F172A), size: 22),
                        onPressed: () {
                          setState(() => _currentNavIndex = 2); // Route to Saved
                        },
                      ),
                      if (favoritesProvider.favoriteIds.isNotEmpty)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEC4899),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              '${favoritesProvider.favoriteIds.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A), size: 22),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),

        // Expanded view containing search and scroll list
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100), // Avoid overlap with bottom nav bar
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9), // Light neutral gray
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.015),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
                      hintText: 'Search burgers, pizzas, pastas...',
                      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, color: Color(0xFF64748B)),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 1.5,
                                    color: const Color(0xFFCBD5E1),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.mic_none_rounded, color: Color(0xFF64748B)),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Categories filters with dynamic Emojis
              if (recipeProvider.categories.length > 1 && _searchQuery.isEmpty)
                Container(
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: recipeProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = recipeProvider.categories[index];
                      final bool isSelected = recipeProvider.selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ChoiceChip(
                          label: Text(
                            _getCategoryLabelWithEmoji(category),
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF6366F1),
                          backgroundColor: const Color(0xFFF1F5F9),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                          onSelected: (selected) {
                            recipeProvider.selectCategory(category);
                          },
                        ),
                      );
                    },
                  ),
                ),

              // Featured Discount Promo Banner Card
              if (_searchQuery.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE2F0D9), Color(0xFFC7E2B5)], // Sage/Light Green
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC7E2B5).withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Left Text Side
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '25% OFF',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFF2C3E2D),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Weekend special deal',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFF3B5E3C),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  // Find first item in Burger category and open it
                                  final burgers = recipeProvider.recipes
                                      .where((r) => r.category.toLowerCase() == 'burger')
                                      .toList();
                                  if (burgers.isNotEmpty) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RecipeDetailScreen(recipe: burgers.first),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF2C3E2D),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Order now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Floating Burger Image on the Right
                        Positioned(
                          top: -10,
                          right: 10,
                          bottom: -10,
                          child: Image.network(
                            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=600',
                            fit: BoxFit.contain,
                            width: 160,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.fastfood_rounded, color: Color(0xFF3B5E3C), size: 80),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // "Your trusted picks" Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Your trusted picks',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (recipeProvider.recipes.isEmpty)
                      TextButton(
                        onPressed: () => _addSampleRecipes(context),
                        child: const Text(
                          'Load Samples',
                          style: TextStyle(
                            color: Color(0xFF6366F1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      TextButton.icon(
                        onPressed: () => _addSampleRecipes(context),
                        icon: const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFF6366F1)),
                        label: const Text(
                          'Reset & Load 10 Items',
                          style: TextStyle(
                            color: Color(0xFF6366F1),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Horizontal Slider picks (Light Cards)
              recipeProvider.isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                        ),
                      ),
                    )
                  : filteredRecipes.isEmpty
                      ? _buildEmptyState(context)
                      : SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            itemCount: filteredRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = filteredRecipes[index];
                              return _buildTrustedPickCard(context, recipe);
                            },
                          ),
                        ),

              const SizedBox(height: 28),

              // "Recommended" Section (Light Cards)
              if (filteredRecipes.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Recommended',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: filteredRecipes
                        .map((recipe) => _buildRecommendedItemRow(context, recipe))
                        .toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // Trusted pick horizontal card (Premium Light Theme Card with overlay heart)
  Widget _buildTrustedPickCard(BuildContext context, RecipeModel recipe) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final recipeKey = recipe.id.isEmpty ? recipe.title : recipe.id;
    final bool isFavorite = favoritesProvider.isFavorite(recipeKey);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        width: 175,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Rating Badge on top right
            const Positioned(
              top: 0,
              right: 0,
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                  SizedBox(width: 2),
                  Text(
                    '4.5',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Favorite Toggle Icon on Top-Left
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  favoritesProvider.toggleFavorite(recipeKey);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFavorite ? const Color(0xFFEF4444) : const Color(0xFF94A3B8),
                    size: 16,
                  ),
                ),
              ),
            ),

            // Card details
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24), // Clearance for overlay icons
                // Image
                Expanded(
                  child: recipe.imageUrl.isNotEmpty
                      ? Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.fastfood_rounded, color: Color(0xFF6366F1), size: 50),
                        )
                      : const Icon(Icons.fastfood, color: Color(0xFF6366F1), size: 50),
                ),
                
                const SizedBox(height: 8),

                // Title
                Text(
                  recipe.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                // Restaurant
                Text(
                  recipe.restaurant,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                // Time | Calories
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Color(0xFF64748B), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${recipe.cookTimeMinutes} min | ${recipe.calories} Kal',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Price and Round Plus Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${recipe.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Round Plus Button
                    GestureDetector(
                      onTap: () {
                        cartProvider.addItem(recipe);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${recipe.title} to cart!'),
                            backgroundColor: const Color(0xFF4F6F52),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.black, // Dark slate circular pill
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Recommended vertical list row (Premium Light Theme Row with Heart Image overlay)
  Widget _buildRecommendedItemRow(BuildContext context, RecipeModel recipe) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final recipeKey = recipe.id.isEmpty ? recipe.title : recipe.id;
    final bool isFavorite = favoritesProvider.isFavorite(recipeKey);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Image Section with Bestseller Overlay and Heart Toggler
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: recipe.imageUrl.isNotEmpty
                      ? Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 90,
                                height: 90,
                                color: const Color(0xFFF1F5F9),
                                child: const Icon(Icons.fastfood_rounded, color: Colors.black26),
                              ),
                        )
                      : Container(
                          width: 90,
                          height: 90,
                          color: const Color(0xFFF1F5F9),
                          child: const Icon(Icons.fastfood, color: Colors.black26),
                        ),
                ),

                // Bestseller overlay badge
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F6F52).withOpacity(0.9), // Forest Green
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Bestseller',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Favorite Overlay heart on Image bottom-right
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () {
                      favoritesProvider.toggleFavorite(recipeKey);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? const Color(0xFFEF4444) : const Color(0xFF94A3B8),
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // Right Info Details Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Rating row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                          SizedBox(width: 2),
                          Text(
                            '4.5',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Restaurant
                  Text(
                    recipe.restaurant,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Location
                  const Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: Color(0xFFEC4899), size: 12),
                      SizedBox(width: 4),
                      Text(
                        '54 Summit Street',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Price and Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${recipe.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Black capsule "+ Add" button
                      GestureDetector(
                        onTap: () {
                          cartProvider.addItem(recipe);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added ${recipe.title} to cart!'),
                              backgroundColor: const Color(0xFF4F6F52),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty state shown when search query yield no results
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF1F5F9),
                border: Border.all(
                  color: const Color(0xFF6366F1).withOpacity(0.15),
                  width: 2,
                ),
              ),
              child: Icon(
                _searchQuery.isNotEmpty ? Icons.search_off_rounded : Icons.menu_book_rounded,
                color: const Color(0xFF6366F1),
                size: 40,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _searchQuery.isNotEmpty ? 'No Results Found' : 'No Recipes Found',
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No delicious food items match the search query "$_searchQuery".'
                  : 'Tap below to load sample high-fidelity mockups directly into Cloud Firestore.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            if (_searchQuery.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('RESET SEARCH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              )
            else
              ElevatedButton.icon(
                onPressed: () => _addSampleRecipes(context),
                icon: const Icon(Icons.playlist_add_rounded, color: Colors.white, size: 18),
                label: const Text(
                  'LOAD SAMPLE RECIPES',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 1: MY ORDER (CART) UI =================
  Widget _buildCartTab(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList = cartProvider.items.values.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Text(
            'My Cart',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Cart Items List
          Expanded(
            child: cartProvider.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF1F5F9),
                            border: Border.all(
                              color: const Color(0xFF94A3B8).withOpacity(0.1),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Color(0xFF64748B),
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Your cart is empty',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add delicious items to get started!',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _currentNavIndex = 0); // Switch to Home
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text(
                            'DISCOVER FOOD',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: cartItemsList.length,
                    itemBuilder: (context, index) {
                      final item = cartItemsList[index];
                      final recipeKey = item.recipe.id.isEmpty ? item.recipe.title : item.recipe.id;
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFF1F5F9),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.015),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Recipe image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: item.recipe.imageUrl.isNotEmpty
                                  ? Image.network(
                                      item.recipe.imageUrl,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                            width: 70,
                                            height: 70,
                                            color: const Color(0xFFF1F5F9),
                                            child: const Icon(Icons.fastfood, color: Colors.black26),
                                          ),
                                    )
                                  : Container(
                                      width: 70,
                                      height: 70,
                                      color: const Color(0xFFF1F5F9),
                                      child: const Icon(Icons.fastfood, color: Colors.black26),
                                    ),
                            ),

                            const SizedBox(width: 16),

                            // Item details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.recipe.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.recipe.restaurant,
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${(item.recipe.price * item.quantity).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFFEC4899),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Quantity selectors & delete
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 20),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    cartProvider.removeItem(recipeKey);
                                  },
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, color: Color(0xFF64748B), size: 14),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                                        onPressed: () {
                                          cartProvider.updateQuantity(recipeKey, item.quantity - 1);
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            color: Color(0xFF0F172A),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, color: Color(0xFF0F172A), size: 14),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                                        onPressed: () {
                                          cartProvider.updateQuantity(recipeKey, item.quantity + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Total Summary & Checkout Button
          if (!cartProvider.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(bottom: 96), // Clearance above bottom navbar
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFF1F5F9),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                      ),
                      Text(
                        '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Fee',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                      ),
                      Text(
                        'FREE',
                        style: TextStyle(color: Color(0xFF10B981), fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFE2E8F0), height: 24, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total amount',
                        style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFFEC4899),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        // Show Checkout success modal dialog
                        showDialog(
                          context: context,
                          builder: (context) => BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              title: const Center(
                                child: Text(
                                  'Order Placed! 🎉',
                                  style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
                                ),
                              ),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 60),
                                  SizedBox(height: 16),
                                  Text(
                                    'Your fresh meal is being prepared and will be delivered shortly!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.4),
                                  ),
                                ],
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close dialog
                                    cartProvider.clearCart(); // Flush cart
                                    setState(() => _currentNavIndex = 0); // Switch to Home
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('AWESOME'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F6F52), // Premium Forest Green
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ================= TAB 2: SAVED (FAVORITES) UI =================
  Widget _buildSavedTab(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    
    // Find all recipes that exist in the favorites set
    final savedRecipesList = recipeProvider.recipes.where((recipe) {
      final recipeKey = recipe.id.isEmpty ? recipe.title : recipe.id;
      return favoritesProvider.isFavorite(recipeKey);
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Saved Recipes',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (savedRecipesList.isNotEmpty) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEC4899).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${savedRecipesList.length}',
                    style: const TextStyle(
                      color: Color(0xFFEC4899),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Favorites list
          Expanded(
            child: savedRecipesList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF1F5F9),
                          ),
                          child: const Icon(
                            Icons.favorite_border_rounded,
                            color: Color(0xFFEC4899),
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No saved recipes yet',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Tap the heart icon on any recipe card to bookmark it here!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _currentNavIndex = 0); // Switch to Home
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text(
                            'EXPLORE MENU',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: savedRecipesList.length,
                    itemBuilder: (context, index) {
                      final recipe = savedRecipesList[index];
                      final recipeKey = recipe.id.isEmpty ? recipe.title : recipe.id;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFF1F5F9),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.015),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(recipe: recipe),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              // Recipe image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: recipe.imageUrl.isNotEmpty
                                    ? Image.network(
                                        recipe.imageUrl,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Container(
                                              width: 70,
                                              height: 70,
                                              color: const Color(0xFFF1F5F9),
                                              child: const Icon(Icons.fastfood, color: Colors.black26),
                                            ),
                                      )
                                    : Container(
                                        width: 70,
                                        height: 70,
                                        color: const Color(0xFFF1F5F9),
                                        child: const Icon(Icons.fastfood, color: Colors.black26),
                                      ),
                              ),

                              const SizedBox(width: 16),

                              // Item details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xFF0F172A),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      recipe.restaurant,
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded, color: Color(0xFF64748B), size: 12),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${recipe.cookTimeMinutes} min | ${recipe.calories} Kal',
                                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Heart button to toggle off favorite immediately
                              IconButton(
                                icon: const Icon(Icons.favorite_rounded, color: Color(0xFFEF4444), size: 22),
                                onPressed: () {
                                  favoritesProvider.toggleFavorite(recipeKey);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ================= TAB 3: PROFILE SCREEN UI =================
  Widget _buildProfileTab(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userEmail = authProvider.user?.email ?? 'guest@example.com';
    final userInitial = userEmail.isNotEmpty ? userEmail[0].toUpperCase() : 'U';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Text(
            'My Profile',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // User Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.12),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.04),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                // Avatar circle
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      userInitial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // Name & Email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2), width: 1),
                        ),
                        child: const Text(
                          'Active Member',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Settings list
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildProfileItem(Icons.history_rounded, 'Order History', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
                }),
                _buildProfileItem(Icons.location_on_outlined, 'Manage Addresses', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageAddressesScreen()));
                }),
                _buildProfileItem(Icons.payment_rounded, 'Payment Methods', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()));
                }),
                _buildProfileItem(Icons.notifications_active_outlined, 'Notifications Settings', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsSettingsScreen()));
                }),
                _buildProfileItem(Icons.security_rounded, 'Security & Privacy', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityPrivacyScreen()));
                }),
                
                const SizedBox(height: 32),

                // Sign Out Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Show confirmation dialog before signout
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: const Text('Sign Out', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
                          content: const Text(
                            'Are you sure you want to sign out of Restaurant Hub?',
                            style: TextStyle(color: Color(0xFF64748B)),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('CANCEL', style: TextStyle(color: Color(0xFF64748B))),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop(); // Close dialog
                                cartProvider.clearCart(); // Flush cart on logout
                                await authProvider.signOut(); // Trigger firebase signout
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF4444),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('SIGN OUT'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                    label: const Text(
                      'SIGN OUT',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444), // Crimson accent
                      foregroundColor: Colors.white,
                      shadowColor: const Color(0xFFEF4444).withOpacity(0.2),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 120), // Clearance for nav bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF6366F1), size: 22),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
