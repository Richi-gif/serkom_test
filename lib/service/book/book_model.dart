// lib/models/book_model.dart

class Book {
  final String title;
  final String author;
  final String? coverUrl;
  final String? description;
  final double? rating;
  final int? pages;
  final String? language;
  final String? publishDate;
  final String? key; // Open Library Work Key or Edition Key

  Book({
    required this.title,
    required this.author,
    this.coverUrl,
    this.description,
    this.rating,
    this.pages,
    this.language,
    this.publishDate,
    this.key,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    // Open Library search API response structure
    String authorName = 'Unknown Author';
    if (json['author_name'] != null && json['author_name'].isNotEmpty) {
      authorName = json['author_name'][0].toString();
    } else if (json['authors'] != null && json['authors'].isNotEmpty) {
      authorName = json['authors'][0]['name'].toString();
    }

    String? coverId = json['cover_i']?.toString();
    String? coverUrl;
    if (coverId != null) {
      coverUrl = 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'; // M for medium size
    } else if (json['isbn'] != null && json['isbn'].isNotEmpty) {
      coverUrl = 'https://covers.openlibrary.org/b/isbn/${json['isbn'][0]}-M.jpg';
    }

    // Attempt to get description from 'first_sentence' or 'subject' or 'subtitle'
    String? desc;
    if (json['first_sentence'] != null && json['first_sentence'].isNotEmpty) {
      desc = json['first_sentence'][0];
    } else if (json['subject'] != null && json['subject'].isNotEmpty) {
      desc = 'Subjects: ${json['subject'].join(', ')}';
    } else if (json['subtitle'] != null) {
      desc = json['subtitle'];
    }

    // Extract pages and language (these might require more detailed API calls or parsing)
    int? pageCount;
    if (json['number_of_pages_median'] != null) {
      pageCount = json['number_of_pages_median'] is int ? json['number_of_pages_median'] : int.tryParse(json['number_of_pages_median'].toString());
    } else if (json['edition_count'] != null) { // Fallback, not actual pages
      pageCount = json['edition_count'] is int ? json['edition_count'] : int.tryParse(json['edition_count'].toString());
    }

    String? lang;
    if (json['language'] != null && json['language'].isNotEmpty) {
      lang = json['language'][0].toString().toUpperCase();
    }

    return Book(
      title: json['title'] ?? 'No Title',
      author: authorName,
      coverUrl: coverUrl,
      description: desc,
      // Open Library search results don't typically have direct rating/pages/language
      // For detailed info, a separate API call to /works/{key}.json would be needed.
      // For simplicity in this example, we'll try to infer or leave null.
      rating: null, // Open Library search API doesn't directly provide ratings
      pages: pageCount,
      language: lang,
      publishDate: json['first_publish_year']?.toString(),
      key: json['key'], // e.g., "/works/OL45804W"
    );
  }

  // Factory constructor for detailed book info (e.g., from /works/{key}.json)
  factory Book.fromWorkJson(Map<String, dynamic> json, {String? coverUrl}) {
    String authorName = 'Unknown Author';
    if (json['authors'] != null && json['authors'].isNotEmpty) {
      // Authors from /works API are typically a list of maps with 'author' key
      if (json['authors'][0]['author'] != null && json['authors'][0]['author']['name'] != null) {
        authorName = json['authors'][0]['author']['name'];
      }
    }

    String? descriptionText;
    if (json['description'] != null) {
      if (json['description'] is String) {
        descriptionText = json['description'];
      } else if (json['description'] is Map && json['description']['value'] != null) {
        descriptionText = json['description']['value'];
      }
    }

    return Book(
      title: json['title'] ?? 'No Title',
      author: authorName,
      coverUrl: coverUrl, // Pass coverUrl from search result or fetch separately
      description: descriptionText,
      rating: null, // Detailed API also doesn't directly provide rating
      pages: null, // Pages are typically in edition data, not work data
      language: null, // Language is typically in edition data, not work data
      publishDate: json['first_publish_date'],
      key: json['key'],
    );
  }
}