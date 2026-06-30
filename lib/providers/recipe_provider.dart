import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/recipe_model.dart';
import '../services/firebase_service.dart';

class RecipeProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<RecipeModel> _recipes = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';
  StreamSubscription<List<RecipeModel>>? _recipesSubscription;

  RecipeProvider() {
    _listenToRecipes();
  }

  List<RecipeModel> get recipes {
    if (_selectedCategory == 'All') {
      return _recipes;
    }
    return _recipes
        .where((recipe) =>
            recipe.category.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  // Real-time listener for recipe updates in Firestore
  void _listenToRecipes() {
    _isLoading = true;
    notifyListeners();

    _recipesSubscription = _firebaseService.getRecipesStream().listen(
      (recipeList) {
        _recipes = recipeList;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  // Change category selection and notify UI to filter recipes
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Manual refresh if needed
  Future<void> refreshRecipes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recipes = await _firebaseService.getRecipesFuture();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Fetch unique categories from existing recipes for dynamic filters
  List<String> get categories {
    final uniqueCategories = _recipes.map((r) => r.category).toSet().toList();
    uniqueCategories.sort();
    return ['All', ...uniqueCategories];
  }

  @override
  void dispose() {
    _recipesSubscription?.cancel();
    super.dispose();
  }
}
