import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String key = 'favorite_meals';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  Future<void> toggleFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList(key) ?? [];

    if (favs.contains(mealId)) {
      favs.remove(mealId);
    } else {
      favs.add(mealId);
    }

    await prefs.setStringList(key, favs);
  }

  Future<bool> isFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList(key) ?? [];
    return favs.contains(mealId);
  }
}
