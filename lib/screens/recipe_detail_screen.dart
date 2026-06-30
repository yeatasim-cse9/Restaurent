import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class RecipeDetailScreen extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  int _quantity = 2; // Default to 2 to match the mockup image

  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.recipe.price * _quantity;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final String recipeKey = widget.recipe.id.isEmpty ? widget.recipe.title : widget.recipe.id;
    final bool isSaved = favoritesProvider.isFavorite(recipeKey);

    return Scaffold(
      backgroundColor: Colors.white, // Crisp Clean White
      body: Stack(
        children: [
          // 1. Large Top Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: widget.recipe.imageUrl.isNotEmpty
                ? Image.network(
                    widget.recipe.imageUrl,
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        color: Color(0xFF6366F1),
                        size: 80,
                      ),
                    ),
                  ),
          ),

          // Gradient Overlay to make top icons readable
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 2. Top Action Buttons (Back & Favorite) (Light Glassmorphism style)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6), // Light glass effect
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
                
                // Favorite Button
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isSaved ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
                          size: 22,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(recipeKey);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Scrollable Detail Sheet Overlapping the Image (Crisp White Canvas)
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.40,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white, // Pure white background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title & Quantity Selector Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.recipe.title,
                                style: const TextStyle(
                                  color: Color(0xFF0F172A), // Slate Dark
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xFF64748B),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.recipe.restaurant == 'Cookie Heaven'
                                        ? '54 Summit Street.'
                                        : '15 Water Street Fremont',
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Quantity Counter (Light Slate Theme)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9), // Light neutral gray
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: Color(0xFF64748B), size: 18),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Color(0xFF0F172A), size: 18),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  setState(() => _quantity++);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Stats Row (Rating, Prep Time, Calories Badge) (Light Theme)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatBadge(
                          icon: Icons.star_rounded,
                          iconColor: const Color(0xFFF59E0B),
                          text: '4.5',
                        ),
                        _buildStatBadge(
                          icon: Icons.timer_outlined,
                          iconColor: const Color(0xFF6366F1),
                          text: '${widget.recipe.cookTimeMinutes}-${widget.recipe.cookTimeMinutes + 2} min',
                        ),
                        _buildStatBadge(
                          icon: Icons.local_fire_department_rounded,
                          iconColor: const Color(0xFFEC4899),
                          text: '${widget.recipe.calories} Kcal',
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Recipe Description & Nutrition stats
                    const Text(
                      'Protein-50gm, Carbs-10gm, Fats-15gm',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '(The unique recipe will make you fly in creaminess of ${widget.recipe.title.toLowerCase()}) Design by Fluttertop',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Customize list item
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFF1F5F9),
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Customize',
                              style: TextStyle(
                                color: Color(0xFF0F172A),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF6366F1), size: 16),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // Ingredients List Title
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Bullet list of ingredients
                    ...widget.recipe.ingredients.map((ingredient) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEC4899),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            ingredient,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),

          // 4. Fixed Bottom Bar (Total amount & Add to cart button) (Clean Light Theme)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.98),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                border: Border.all(
                  color: const Color(0xFFF1F5F9),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total amount',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Add to cart Button (Forest Green)
                    ElevatedButton(
                      onPressed: () {
                        final cartProvider = Provider.of<CartProvider>(context, listen: false);
                        cartProvider.addItem(widget.recipe, quantity: _quantity);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added $_quantity x ${widget.recipe.title} to cart!'),
                            backgroundColor: const Color(0xFF4F6F52),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F6F52), // Premium muted green
                        foregroundColor: Colors.white,
                        shadowColor: const Color(0xFF4F6F52).withOpacity(0.2),
                        elevation: 6,
                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Add to cart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Light neutral gray
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
