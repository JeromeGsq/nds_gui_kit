import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nds_gui_kit/models/favorite_app_config.dart';

class FavoritesStorageService {
  static const String _keyPrefix = 'favorite_app_';
  static const int maxFavorites = 4;

  Future<void> saveFavorite(int index, FavoriteAppConfig config) async {
    if (index < 0 || index >= maxFavorites) {
      throw ArgumentError('Index must be between 0 and ${maxFavorites - 1}');
    }

    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$index';
    final jsonString = jsonEncode(config.toJson());
    await prefs.setString(key, jsonString);
  }

  Future<FavoriteAppConfig> loadFavorite(int index) async {
    if (index < 0 || index >= maxFavorites) {
      throw ArgumentError('Index must be between 0 and ${maxFavorites - 1}');
    }

    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$index';
    final jsonString = prefs.getString(key);

    if (jsonString == null) {
      return FavoriteAppConfig.empty();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return FavoriteAppConfig.fromJson(json);
    } catch (e) {
      return FavoriteAppConfig.empty();
    }
  }

  Future<List<FavoriteAppConfig>> loadAllFavorites() async {
    final favorites = <FavoriteAppConfig>[];
    for (int i = 0; i < maxFavorites; i++) {
      favorites.add(await loadFavorite(i));
    }
    return favorites;
  }

  Future<void> clearFavorite(int index) async {
    if (index < 0 || index >= maxFavorites) {
      throw ArgumentError('Index must be between 0 and ${maxFavorites - 1}');
    }

    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$index';
    await prefs.remove(key);
  }

  Future<void> clearAllFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < maxFavorites; i++) {
      final key = '$_keyPrefix$i';
      await prefs.remove(key);
    }
  }
}

