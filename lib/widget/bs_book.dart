// lib/widget/best_seller_book.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:praktikum_1/service/book/book_model.dart'; // Adjust path if necessary
import 'package:praktikum_1/view/book_detail.dart'; // Adjust path if necessary

class BestSellerBookWidget extends StatelessWidget {
  final Book book;
  const BestSellerBookWidget({super.key, required this.book});

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
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C), // Darker grey for list items
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: book.coverUrl != null
                  ? CachedNetworkImage(
                      imageUrl: book.coverUrl!,
                      width: 70,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 70,
                        height: 100,
                        color: Colors.grey[800],
                        child: const Icon(Icons.book, color: Colors.grey),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 70,
                        height: 100,
                        color: Colors.grey[800],
                        child: const Icon(Icons.broken_image,
                            color: Colors.grey), // Changed to broken_image icon
                      ),
                    )
                  : Container(
                      width: 70,
                      height: 100,
                      color: Colors.grey[800],
                      child:
                          const Icon(Icons.book_outlined, color: Colors.grey),
                    ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'by ${book.author}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        book.rating?.toStringAsFixed(1) ?? 'N/A',
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${book.pages ?? 'N/A'} Pages',
                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // "Get Now" button - as seen in the image
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50), // Green color for "Get Now"
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Get Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}