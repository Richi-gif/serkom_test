// lib/view/book_detail_page.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:praktikum_1/service/book/book_model.dart';
import 'package:praktikum_1/service/book/book_service.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;
  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late Future<Book> _detailedBookFuture;
  final BookService _bookService = BookService();
  bool _showFullDescription = false;

  @override
  void initState() {
    super.initState();
    _detailedBookFuture = _bookService.getBookDetails(widget.book.key ?? '', currentCoverUrl: widget.book.coverUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          // Bookmark icon
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.bookmark_border, color: Colors.white),
          ),
        ],
      ),
      body: FutureBuilder<Book>(
        future: _detailedBookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading details: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text('No book details found.',
                    style: TextStyle(color: Colors.white70)));
          } else {
            final detailedBook = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Book Cover
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: detailedBook.coverUrl != null
                        ? CachedNetworkImage(
                            imageUrl: detailedBook.coverUrl!,
                            width: 200, // Larger size for detail page
                            height: 300,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 200,
                              height: 300,
                              color: Colors.grey[800],
                              child: const Icon(Icons.book, color: Colors.grey, size: 50),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 200,
                              height: 300,
                              color: Colors.grey[800],
                              child: const Icon(Icons.book_outlined, color: Colors.grey, size: 50),
                            ),
                          )
                        : Container(
                            width: 200,
                            height: 300,
                            color: Colors.grey[800],
                            child: const Icon(Icons.book_outlined, color: Colors.grey, size: 50),
                          ),
                  ),
                  const SizedBox(height: 20),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      detailedBook.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Author
                  Text(
                    'by ${detailedBook.author}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Rating, Pages, Language
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoColumn(
                            'Rating', detailedBook.rating?.toStringAsFixed(1) ?? 'N/A'),
                        _buildInfoColumn(
                            'Pages', detailedBook.pages?.toString() ?? 'N/A'),
                        _buildInfoColumn(
                            'Language', detailedBook.language ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detailedBook.description ?? 'No description available.',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15,
                          ),
                          maxLines: _showFullDescription ? null : 4,
                          overflow: _showFullDescription
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                        if (detailedBook.description != null && detailedBook.description!.length > 200) // Simple check for long text
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showFullDescription = !_showFullDescription;
                              });
                            },
                            child: Text(
                              _showFullDescription ? 'Read Less' : 'Read More',
                              style: const TextStyle(color: Color(0xFFF09E54)), // Orange accent
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Price and Get Now Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "\$15.20", // Hardcoded price as per image
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implement "Get Now" logic (e.g., purchase, download)
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50), // Green color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Get Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Column _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}