// lib/view/search_book_page.dart

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:praktikum_1/service/book/book_model.dart';

class SearchBookPage extends StatefulWidget {
  const SearchBookPage({super.key});

  @override
  State<SearchBookPage> createState() => _SearchBookPageState();
}

class _SearchBookPageState extends State<SearchBookPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _bookResults = [];
  bool _isLoading = false;
  bool _hasSearched = false; // To track if a search has been performed

  Future<void> _searchBooks(String keyword) async {
    if (keyword.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    final url = Uri.parse("https://openlibrary.org/search.json?q=$keyword");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final docs = data['docs'] as List;
        setState(() {
          _bookResults = docs.map((d) => Book.fromJson(d)).toList();
        });
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C), // Dark background
      appBar: AppBar(
        title: const Text("Cari Judul Buku"),
        backgroundColor: const Color(0xFF1C1C1C), // Dark AppBar
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Masukkan judul buku...",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide:
                      const BorderSide(color: Color(0xFFF09E54), width: 1.5),
                ),
              ),
              onSubmitted: _searchBooks,
            ),
          ),
          if (_isLoading)
            const Expanded(
                child: Center(
                    child: CircularProgressIndicator(
              color: Colors.white,
            )))
          else if (_hasSearched && _bookResults.isEmpty)
            const Expanded(
                child: Center(
                    child: Text("Buku tidak ditemukan.",
                        style: TextStyle(color: Colors.white70))))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _bookResults.length,
                itemBuilder: (context, index) {
                  final book = _bookResults[index];
                  return Card(
                    color: const Color(0xFF2C2C2C),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: book.coverUrl != null
                            ? CachedNetworkImage(
                                imageUrl: book.coverUrl!,
                                width: 50,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey[800]),
                                errorWidget: (context, error, stackTrace) =>
                                    Container(
                                        width: 50,
                                        color: Colors.grey[800],
                                        child: const Icon(Icons.book,
                                            color: Colors.grey)),
                              )
                            : Container(
                                width: 50,
                                color: Colors.grey[800],
                                child: const Icon(Icons.book_outlined,
                                    color: Colors.grey)),
                      ),
                      title: Text(book.title,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(book.author,
                          style: TextStyle(color: Colors.grey[400])),
                      onTap: () {
                        Navigator.pop(context, book);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
