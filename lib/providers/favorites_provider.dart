import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  final Set<String> _favoriteIds = {};

  FavoritesProvider(this._prefs) {
    _loadFavorites();
  }

  Set<String> get favoriteIds => _favoriteIds;

  // Load bookmarked recipe keys from local storage
  void _loadFavorites() {
    try {
      final List<String>? saved = _prefs.getStringList('favorite_recipes');
      if (saved != null) {
        _favoriteIds.addAll(saved);
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  // Write bookmarked recipe keys to local storage
  void _saveFavorites() {
    try {
      _prefs.setStringList('favorite_recipes', _favoriteIds.toList());
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  bool isFavorite(String idOrTitle) {
    return _favoriteIds.contains(idOrTitle);
  }

  void toggleFavorite(String idOrTitle) {
    if (_favoriteIds.contains(idOrTitle)) {
      _favoriteIds.remove(idOrTitle);
    } else {
      _favoriteIds.add(idOrTitle);
    }
    _saveFavorites();
    notifyListeners();
  }
}
