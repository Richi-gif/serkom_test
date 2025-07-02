// lib/widget/loan_list_item.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LoanListItem extends StatelessWidget {
  final Map<String, dynamic> loanData;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LoanListItem({
    super.key,
    required this.loanData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2C2C), // Darker grey for card background
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: (loanData['coverUrl'] != null &&
                  loanData['coverUrl'].isNotEmpty)
              ? CachedNetworkImage(
                  imageUrl: loanData['coverUrl'],
                  width: 50,
                  height: 75,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[800]),
                  errorWidget: (context, url, error) => Container(
                    width: 50,
                    height: 75,
                    color: Colors.grey[800],
                    child: const Icon(Icons.book, color: Colors.grey),
                  ),
                )
              : Container(
                  width: 50,
                  height: 75,
                  color: Colors.grey[800],
                  child: const Icon(Icons.book_outlined, color: Colors.grey),
                ),
        ),
        title: Text(
          loanData['title'] ?? 'No Title',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "${loanData['borrower']} - ${loanData['borrowDate']}",
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit,
                  color: Color(0xFFF09E54)), // Accent color
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red.shade400),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
