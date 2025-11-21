import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/post_model.dart';


class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  

  static const Duration timeoutDuration = Duration(seconds: 30);


  Future<List<Post>> fetchPosts({int start = 0, int limit = 10}) async {
    try {
      final url = Uri.parse('$baseUrl/posts?_start=$start&_limit=$limit');
      
      final response = await http.get(url).timeout(
        timeoutDuration,
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Posts not found');
      } else if (response.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception('Failed to load posts. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: Unable to connect to server. $e');
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }


  Future<Post> fetchPostById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/posts/$id');
      
      final response = await http.get(url).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Post.fromJson(jsonData);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception('Error fetching post: $e');
    }
  }

  Future<bool> checkApiHealth() async {
    try {
      final url = Uri.parse('$baseUrl/posts/1');
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}