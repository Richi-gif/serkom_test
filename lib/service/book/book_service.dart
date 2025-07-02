// lib/services/book_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:praktikum_1/service/book/book_model.dart';

class BookService {
  static const String _baseUrl = 'https://openlibrary.org';

  Future<List<Book>> searchBooks(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search.json?q=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> docs = data['docs'];
      return docs.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books: ${response.statusCode}');
    }
  }

  Future<Book> getBookDetails(String workKey, {String? currentCoverUrl}) async {
    // workKey is something like "/works/OL45804W"
    final response = await http.get(Uri.parse('$_baseUrl$workKey.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Open Library's /works API doesn't always have a direct cover_i.
      // We'll use the one from the search result if available, or try to find an ISBN from editions.
      String? finalCoverUrl = currentCoverUrl;
      if (finalCoverUrl == null && data['covers'] != null && data['covers'].isNotEmpty) {
        finalCoverUrl = 'https://covers.openlibrary.org/b/id/${data['covers'][0]}-L.jpg';
      } else if (finalCoverUrl == null && data['latest_revision'] != null) {
         // Try to get cover from an edition if available, this is more complex and might require another API call
         // For simplicity, we'll stick to the passed coverUrl or the 'covers' array if present.
      }


      // For pages and language, we often need to fetch a specific edition.
      // For this example, we'll keep them null in the Book.fromWorkJson and
      // just focus on title, author, description.
      // A more robust solution would involve fetching editions and then picking one for details.

      return Book.fromWorkJson(data, coverUrl: finalCoverUrl);
    } else {
      throw Exception('Failed to load book details: ${response.statusCode}');
    }
  }
}