import 'package:flutter/material.dart';
import 'package:praktikum_1/service/book/book_service.dart';
import 'package:praktikum_1/service/book/book_model.dart';
import 'package:praktikum_1/widget/book_card.dart';

class SearchBukuWidget extends StatefulWidget {
  final String initialQuery;
  final BookService bookService;
  final void Function(String query) onSearchSubmit;
  final VoidCallback onClearSearch;

  const SearchBukuWidget({
    super.key,
    required this.initialQuery,
    required this.bookService,
    required this.onSearchSubmit,
    required this.onClearSearch,
  });

  @override
  State<SearchBukuWidget> createState() => _SearchBukuWidgetState();
}

class _SearchBukuWidgetState extends State<SearchBukuWidget> {
  late TextEditingController _controller;
  List<Book> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.isNotEmpty) {
      _searchBooks(widget.initialQuery);
    }
  }

  Future<void> _searchBooks(String query) async {
    setState(() {
      _isLoading = true;
    });
    final results = await widget.bookService.searchBooks(query);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
    widget.onSearchSubmit(query);
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _searchResults = [];
    });
    widget.onClearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search input
        TextField(
          controller: _controller,
          onSubmitted: _searchBooks,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Cari buku...",
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: _clearSearch,
            ),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),

        if (_isLoading)
          const Center(child: CircularProgressIndicator(color: Colors.white))
        else if (_searchResults.isNotEmpty)
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final book = _searchResults[index];
                return BookCard(book: book);
              },
            ),
          ),
      ],
    );
  }
}
