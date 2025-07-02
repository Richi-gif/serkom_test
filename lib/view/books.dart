// lib/view/Books.dart

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:praktikum_1/service/book/book_model.dart';
import 'package:praktikum_1/view/date_picker.dart';
import 'package:praktikum_1/view/search_book_page.dart';
import 'package:praktikum_1/widget/list_item.dart';
import 'package:praktikum_1/widget/navigation.dart';

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

  // Shared text field style for dialogs
  InputDecoration _dialogTextFieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Color(0xFFF09E54), width: 1.5),
      ),
    );
  }

  // Shared button style for dialogs
  final ButtonStyle _dialogButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFF09E54),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final snapshot =
        await bookLoans.orderBy('borrowDate', descending: true).get();
    final data = snapshot.docs.map((doc) {
      final d = doc.data() as Map<String, dynamic>;
      d['id'] = doc.id;
      return d;
    }).toList();
    setState(() {
      books = data;
      isLoading = false;
    });
  }

  Future<void> _showEditDialog(Map<String, dynamic> currentLoan) async {
    TextEditingController nameController =
        TextEditingController(text: currentLoan['borrower']);
    DateTime selectedDate = DateTime.parse(currentLoan['borrowDate']);

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Edit Peminjaman",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _dialogTextFieldDecoration("Nama Peminjam"),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push<DateTime>(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DatePickerPage(initialDate: selectedDate)),
                        );
                        if (result != null) {
                          setState(() {
                            selectedDate = result;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(DateFormat('d MMMM yyyy').format(selectedDate),
                                style: const TextStyle(color: Colors.white)),
                            const Icon(Icons.calendar_today,
                                color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal",
                                style: TextStyle(color: Colors.white70))),
                        ElevatedButton(
                          style: _dialogButtonStyle,
                          onPressed: () async {
                            await bookLoans.doc(currentLoan['id']).update({
                              'borrower': nameController.text,
                              'borrowDate':
                                  DateFormat('yyyy-MM-dd').format(selectedDate),
                            });
                            Navigator.pop(context);
                            _loadBooks();
                          },
                          child: const Text("Simpan",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> _confirmDelete(String docId) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF2C2C2C),
              title: const Text("Hapus Peminjaman",
                  style: TextStyle(color: Colors.white)),
              content: Text("Apakah Anda yakin ingin menghapus data ini?",
                  style: TextStyle(color: Colors.grey[300])),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Batal",
                        style: TextStyle(color: Colors.grey[300]))),
                TextButton(
                  onPressed: () async {
                    await bookLoans.doc(docId).delete();
                    Navigator.pop(context);
                    _loadBooks();
                  },
                  child: Text("Hapus",
                      style: TextStyle(color: Colors.red.shade400)),
                ),
              ],
            ));
  }

  Future<void> _showBorrowDialog() async {
    TextEditingController nameController = TextEditingController();
    Book? selectedBook;
    DateTime selectedDate = DateTime.now();

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Pinjam Buku",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push<Book>(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchBookPage()),
                        );
                        if (result != null) {
                          setState(() {
                            selectedBook = result;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          selectedBook?.title ?? "Cari judul buku...",
                          style: TextStyle(
                              color: selectedBook != null
                                  ? Colors.white
                                  : Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _dialogTextFieldDecoration("Nama Peminjam"),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push<DateTime>(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DatePickerPage(initialDate: selectedDate)),
                        );
                        if (result != null) {
                          setState(() {
                            selectedDate = result;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(DateFormat('d MMMM yyyy').format(selectedDate),
                                style: const TextStyle(color: Colors.white)),
                            const Icon(Icons.calendar_today,
                                color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal",
                                style: TextStyle(color: Colors.white70))),
                        ElevatedButton(
                          style: _dialogButtonStyle,
                          onPressed: () async {
                            if (selectedBook != null &&
                                nameController.text.isNotEmpty) {
                              await bookLoans.add({
                                'title': selectedBook!.title,
                                'borrower': nameController.text,
                                'borrowDate': DateFormat('yyyy-MM-dd')
                                    .format(selectedDate),
                                'coverUrl': selectedBook!.coverUrl,
                              });
                              Navigator.pop(context);
                              _loadBooks();
                            }
                          },
                          child: const Text("Pinjam",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C), // Dark background
      appBar: AppBar(
        title: const Text(
          "PEMINJAMAN",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Bootstrap.plus_circle, color: Colors.white),
            onPressed: _showBorrowDialog,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : books.isEmpty
              ? const Center(
                  child: Text("Belum ada data peminjaman.",
                      style: TextStyle(color: Colors.white70)))
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  itemCount: books.length,
                  itemBuilder: (_, index) {
                    final book = books[index];
                    return LoanListItem(
                      loanData: book,
                      onEdit: () => _showEditDialog(book),
                      onDelete: () => _confirmDelete(book['id']),
                    );
                  },
                ),
      bottomNavigationBar: const CustomNavigationBar(selectedIndex: 1),
    );
  }
}
