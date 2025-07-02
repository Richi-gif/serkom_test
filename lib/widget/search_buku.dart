// lib/widget/search_buku.dart

import 'package:flutter/material.dart';
import 'package:praktikum_1/service/book/book_model.dart';
import 'package:praktikum_1/service/book/book_service.dart';
import 'package:praktikum_1/view/home.dart';
import 'package:praktikum_1/widget/book_card.dart'; // Make sure this path is correct

class SearchBukuWidget extends StatefulWidget {
  final String initialQuery;
  final BookService bookService;
  final VoidCallback
      onClearSearch; // Callback to notify home.dart to clear search

  const SearchBukuWidget({
    super.key,
    required this.initialQuery,
    required this.bookService,
    required this.onClearSearch,
  });

  @override
  State<SearchBukuWidget> createState() => _SearchBukuWidgetState();
}

class _SearchBukuWidgetState extends State<SearchBukuWidget> {
  late TextEditingController _searchController;
  late Future<List<Book>> _searchBooksFuture;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _currentQuery = widget.initialQuery;
    _searchBooksFuture = widget.bookService.searchBooks(_currentQuery);
  }

  @override
  void didUpdateWidget(covariant SearchBukuWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery) {
      _currentQuery = widget.initialQuery;
      _searchController.text = _currentQuery;
      _searchBooksFuture = widget.bookService.searchBooks(_currentQuery);
    }
  }

  void _performSearch() {
    setState(() {
      _currentQuery = _searchController.text.trim();
      if (_currentQuery.isNotEmpty) {
        _searchBooksFuture = widget.bookService.searchBooks(_currentQuery);
      } else {
        // If search is cleared in the widget, notify parent
        widget.onClearSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C), // Darker grey for search bar
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  widget
                      .onClearSearch(); // Notify parent to clear search results
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
            onSubmitted: (query) {
              _performSearch();
            },
          ),
        ),
        const SizedBox(height: 20),

        // Display Search Results or "No popular books found."
        _currentQuery.isNotEmpty
            ? Text(
                "Search results for '$_currentQuery'", // Indicate what's being searched
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const SizedBox.shrink(), // No title if search is empty
        const SizedBox(height: 15),
        FutureBuilder<List<Book>>(
          future: _searchBooksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No books found for this search.',
                      style: TextStyle(color: Colors.white70)));
            } else {
              final booksWithCovers = snapshot.data!
                  .where((book) => book.coverUrl != null)
                  .toList(); // Filter for covers
              if (booksWithCovers.isEmpty) {
                return const Center(
                  child: Text('No books with covers found for this search.',
                      style: TextStyle(color: Colors.white70)),
                );
              }
              return SizedBox(
                height: 250, // Height for horizontal book list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: booksWithCovers.length,
                  itemBuilder: (context, index) {
                    final book = booksWithCovers[index];
                    return BookCard(book: book); // Re-using BookCard
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

// Re-using BookCard and BestSellerBookItem as they are generic enough
// Make sure BookCard and BestSellerBookItem classes are accessible (e.g., in home.dart or separate file)

// If BookCard and BestSellerBookItem were defined outside MyHomePage, ensure they are imported.
// For this response, I'm assuming they are still in home.dart and will be copied over.

// Copy BookCard and BestSellerBookItem from home.dart if you want them in a separate common file
// For example, in lib/widgets/book_display_widgets.dart if you create it.

/*
// Example of how BookCard might be structured if you move it
// lib/widgets/book_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:praktikum_1/models/book_model.dart';
import 'package:praktikum_1/view/book_detail.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(book: book),
          ),
        );
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: book.coverUrl != null
                  ? CachedNetworkImage(
                      imageUrl: book.coverUrl!,
                      width: 130,
                      height: 180,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 130,
                        height: 180,
                        color: Colors.grey[800],
                        child: const Icon(Icons.book, color: Colors.grey),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 130,
                        height: 180,
                        color: Colors.grey[800],
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    )
                  : Container(
                      width: 130,
                      height: 180,
                      color: Colors.grey[800],
                      child: const Icon(Icons.book_outlined, color: Colors.grey),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
