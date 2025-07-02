import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart'; // Ensure this package is in your pubspec.yaml
import 'package:http/http.dart'
    as http; // Ensure this package is in your pubspec.yaml
import 'dart:convert';

import 'package:praktikum_1/widget/navigation.dart'; // Ensure this path is correct

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final CollectionReference bookLoans =
      FirebaseFirestore.instance.collection('book_loans');

  List<Map<String, dynamic>> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final snapshot = await bookLoans.get();
    final data = snapshot.docs.map((doc) {
      final d = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'title': d['title'],
        'borrower': d['borrower'],
        'borrowDate': d['borrowDate'],
      };
    }).toList();
    setState(() {
      books = data;
      isLoading = false;
    });
  }

  Future<void> _deleteBook(String id) async {
    await bookLoans.doc(id).delete();
    _loadBooks();
  }

  // Updated _showBorrowDialogWithSearch method
  Future<void> _showBorrowDialogWithSearch() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController searchController = TextEditingController();

    List<String> bookResults = [];
    String? selectedBook;
    DateTime selectedDate = DateTime.now();

    Future<void> searchBooks(String keyword) async {
      final url = Uri.parse("https://openlibrary.org/search.json?q=$keyword");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final docs = data['docs'] as List;
        bookResults = docs
            .map((d) => d['title']?.toString() ?? "")
            .where((t) => t.isNotEmpty)
            .toSet()
            .toList();
      }
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: StatefulBuilder(
            // Use StatefulBuilder to manage internal state of the dialog
            builder: (context, setState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Pinjam Buku",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: searchController,
                      decoration:
                          const InputDecoration(labelText: "Cari Judul Buku"),
                      onSubmitted: (val) async {
                        await searchBooks(val);
                        setState(() {}); // Trigger rebuild of StatefulBuilder
                      },
                    ),
                    const SizedBox(height: 12),
                    if (bookResults.isNotEmpty)
                      DropdownButton<String>(
                        isExpanded: true,
                        value: selectedBook,
                        hint: const Text("Pilih Buku"),
                        items: bookResults
                            .map((title) => DropdownMenuItem(
                                value: title, child: Text(title)))
                            .toList(),
                        onChanged: (val) {
                          setState(() => selectedBook = val); // Trigger rebuild
                        },
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: "Nama Peminjam"),
                    ),
                    const SizedBox(height: 12),
                    TableCalendar(
                      firstDay: DateTime.utc(2020),
                      lastDay: DateTime.utc(2030),
                      focusedDay: selectedDate,
                      selectedDayPredicate: (day) =>
                          isSameDay(day, selectedDate),
                      onDaySelected: (selected, focused) {
                        // focused is also passed by table_calendar
                        setState(
                            () => selectedDate = selected); // Trigger rebuild
                      },
                      calendarStyle: const CalendarStyle(
                        selectedDecoration: BoxDecoration(
                            color: Colors.deepPurple, shape: BoxShape.circle),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal")),
                        ElevatedButton(
                          onPressed: () async {
                            if (selectedBook != null &&
                                nameController.text.isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection('book_loans')
                                  .add({
                                'title': selectedBook,
                                'borrower': nameController.text,
                                'borrowDate': selectedDate
                                    .toIso8601String()
                                    .split("T")
                                    .first,
                              });
                              Navigator.pop(context);
                              _loadBooks(); // Reload main book list
                            }
                          },
                          child: const Text("Pinjam"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Peminjaman Buku"),
        actions: [
          IconButton(
            icon: const Icon(Bootstrap.plus_circle),
            onPressed: _showBorrowDialogWithSearch,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
              ? const Center(child: Text("Belum ada data peminjaman."))
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (_, index) {
                    final book = books[index];
                    return Dismissible(
                      key: Key(book['id']),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _deleteBook(book['id']),
                      child: Card(
                        child: ListTile(
                          title: Text(book['title']),
                          subtitle: Text(
                              "${book['borrower']} - ${book['borrowDate']}"),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: const CustomNavigationBar(selectedIndex: 1),
    );
  }
}
