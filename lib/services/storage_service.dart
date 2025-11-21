import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_app/models/post_model.dart';

class StorageService {
  static const String postsBoxName = 'posts_cache';
  static const String userBoxName = 'user_data';
  static const String postsKey = 'cached_posts';
  static const String lastUpdateKey = 'last_update';


  Future<void> cachePosts(List<Post> posts) async {
    try {
      final box = await Hive.openBox(postsBoxName);
 
      final postsJson = posts.map((post) => post.toJson()).toList();
    
      await box.put(postsKey, json.encode(postsJson));
      await box.put(lastUpdateKey, DateTime.now().toIso8601String());
      
      print('Cached ${posts.length} posts successfully');
    } catch (e) {
      print('Error caching posts: $e');
    }
  }


  Future<List<Post>> getCachedPosts() async {
    try {
      final box = await Hive.openBox(postsBoxName);
      
      final postsString = box.get(postsKey);
      
      if (postsString == null) {
        return [];
      }

      final List<dynamic> postsJson = json.decode(postsString);
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      print('Error retrieving cached posts: $e');
      return [];
    }
  }

  Future<bool> hasCachedPosts() async {
    try {
      final box = await Hive.openBox(postsBoxName);
      return box.containsKey(postsKey);
    } catch (e) {
      return false;
    }
  }

  Future<DateTime?> getLastUpdateTime() async {
    try {
      final box = await Hive.openBox(postsBoxName);
      final timeString = box.get(lastUpdateKey);
      
      if (timeString == null) return null;
      
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearCache() async {
    try {
      final box = await Hive.openBox(postsBoxName);
      await box.clear();
      print('Cache cleared successfully');
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  Future<bool> isCacheStale({Duration maxAge = const Duration(hours: 1)}) async {
    final lastUpdate = await getLastUpdateTime();
    
    if (lastUpdate == null) return true;
    
    final difference = DateTime.now().difference(lastUpdate);
    return difference > maxAge;
  }


  Future<void> saveUserData(String key, dynamic value) async {
    try {
      final box = await Hive.openBox(userBoxName);
      await box.put(key, value);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }


  Future<dynamic> getUserData(String key, {dynamic defaultValue}) async {
    try {
      final box = await Hive.openBox(userBoxName);
      return box.get(key, defaultValue: defaultValue);
    } catch (e) {
      print('Error getting user data: $e');
      return defaultValue;
    }
  }


  Future<void> clearUserData() async {
    try {
      final box = await Hive.openBox(userBoxName);
      await box.clear();
      print('User data cleared successfully');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }
}