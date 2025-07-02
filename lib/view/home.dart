import 'package:flutter/material.dart';
import 'package:praktikum_1/service/book/book_model.dart';
import 'package:praktikum_1/service/book/book_service.dart';
import 'package:praktikum_1/widget/bs_book.dart';
import 'package:praktikum_1/widget/navigation.dart';
import 'package:praktikum_1/widget/search_buku.dart';
import 'package:praktikum_1/widget/book_card.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BookService _bookService = BookService();
  late Future<List<Book>> _popularBooksFuture;
  late Future<List<Book>> _bestSellerBooksFuture;
  String _currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  void _fetchBooks() {
    setState(() {
      _popularBooksFuture = _bookService.searchBooks(
          'middlemarch OR Kinder- und Hausmärchen OR The Railway Children OR Ramadan Mubarak OR Islam');
      _bestSellerBooksFuture = _bookService.searchBooks(
          'La Peste OR Ramona the Pest OR The Twits OR Bismillah OR Hajji Reflections');
    });
  }

  void _onSearchPerformed(String query) {
    setState(() {
      _currentSearchQuery = query;
      if (_currentSearchQuery.isEmpty) {
        _fetchBooks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                    "assets/photo-1534528741775-53994a69daeb.webp"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: const Text(
          "BOOKS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 40),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SearchBukuWidget(
                initialQuery: _currentSearchQuery,
                bookService: _bookService,
                onClearSearch: () => _onSearchPerformed(''),
              ),

              if (_currentSearchQuery.isEmpty) ...[
                const SizedBox(height: 20),

                const Text(
                  "Popular Books",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                FutureBuilder<List<Book>>(
                  future: _popularBooksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error loading popular books: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red)));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No popular books found.',
                              style: TextStyle(color: Colors.white70)));
                    } else {
                      final booksWithCovers = snapshot.data!
                          .where((book) => book.coverUrl != null)
                          .take(5)
                          .toList();

                      if (booksWithCovers.isEmpty) {
                        return const Center(
                          child: Text('No popular books with covers found. Try a different search.',
                              style: TextStyle(color: Colors.white70)),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: booksWithCovers.length,
                              itemBuilder: (context, index) {
                                final book = booksWithCovers[index];
                                return BookCard(book: book);
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Best seller",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                      },
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          color: Color(0xFFF09E54),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                FutureBuilder<List<Book>>(
                  future: _bestSellerBooksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error loading best seller books: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red)));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No best seller books found.',
                              style: TextStyle(color: Colors.white70)));
                    } else {
                      final booksWithCovers = snapshot.data!
                          .where((book) => book.coverUrl != null)
                          .toList();
                      if (booksWithCovers.isEmpty) {
                        return const Center(
                          child: Text('No best seller books with covers found. Try a different search.',
                              style: TextStyle(color: Colors.white70)),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount: booksWithCovers.length,
                        itemBuilder: (context, index) {
                          final book = booksWithCovers[index];
                          return BestSellerBookWidget(book: book);
                        },
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(selectedIndex: 0),
    );
  }
}