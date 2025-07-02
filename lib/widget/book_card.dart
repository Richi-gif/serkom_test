// lib/widget/book_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:praktikum_1/service/book/book_model.dart'; // Adjust path if necessary
import 'package:praktikum_1/view/book_detail.dart'; // Adjust path if necessary

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
        width: 130, // Fixed width for each card
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
                      height: 180, // Fixed height for cover
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
                        child: const Icon(Icons.broken_image,
                            color: Colors.grey), // Changed to broken_image icon
                      ),
                    )
                  : Container(
                      width: 130,
                      height: 180,
                      color: Colors.grey[800],
                      child:
                          const Icon(Icons.book_outlined, color: Colors.grey),
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
