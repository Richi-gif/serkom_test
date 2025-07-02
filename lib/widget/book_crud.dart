import 'package:cloud_firestore/cloud_firestore.dart';

class BookCrud {
  final CollectionReference bookCollection =
      FirebaseFirestore.instance.collection('book_loans');

  Future<List<Map<String, dynamic>>> getBooks() async {
    final snapshot = await bookCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> addBook(Map<String, dynamic> book) async {
    await bookCollection.add(book);
  }

  Future<void> updateBook(String docId, Map<String, dynamic> book) async {
    await bookCollection.doc(docId).update(book);
  }

  Future<void> deleteBook(String docId) async {
    await bookCollection.doc(docId).delete();
  }
}
