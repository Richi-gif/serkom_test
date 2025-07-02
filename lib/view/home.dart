import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart'; // Keep if you use other icons, not strictly needed for this UI
import 'package:praktikum_1/application/login/view/login.dart';
import 'package:praktikum_1/service/book/book_model.dart'; // Make sure path is correct: lib/service/book/book_model.dart
import 'package:praktikum_1/service/book/book_service.dart'; // Make sure path is correct: lib/service/book/book_service.dart
import 'package:praktikum_1/view/book_detail.dart'; // Make sure path is correct: lib/view/book_detail.dart
// import 'package:praktikum_1/view/notification.dart'; // Removed as bell icon is gone
import 'package:praktikum_1/widget/navigation.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For better image loading

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BookService _bookService = BookService();
  late Future<List<Book>> _popularBooksFuture;
  late Future<List<Book>> _bestSellerBooksFuture;
  final TextEditingController _searchController = TextEditingController();

  // Hardcoded categories for demonstration, matching the image idea
  final List<String> _categories = [
    'Religion',
    'Horror',
    'Drama',
    'Fantasy',
    'Science Fiction',
    'Mystery',
    'Romance',
  ];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  void _fetchBooks() {
    setState(() {
      // Using more specific queries to get better results
      _popularBooksFuture =
          _bookService.searchBooks('ramadan'); // Example query based on image
      _bestSellerBooksFuture = _bookService
          .searchBooks('muslim women diary'); // Another example query
    });
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _popularBooksFuture = _bookService.searchBooks(query);
        _bestSellerBooksFuture =
            Future.value([]); // Clear best sellers on search
      });
    } else {
      _fetchBooks(); // Reload default if search is empty
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C), // Dark background from image
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C), // Dark background
        elevation: 0, // No shadow
        // Moved Profile Picture to leading property
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Add some padding
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                    "assets/photo-1534528741775-53994a69daeb.webp"), // Your existing asset
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // App Title (BOOKS)
        title: const Text(
          "BOOKS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true, // This centers the title within the AppBar
        actions: const [
          // If you need any actions/icons on the right, place them here.
          // For now, it's empty as per the last request.
          SizedBox(
              width:
                  40), // Placeholder to balance leading if needed, or remove if not desired.
          // An alternative is to just omit the 'actions' property entirely if no widgets are needed.
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C), // Darker grey for search bar
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        _fetchBooks(); // Reload default books
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onSubmitted: _performSearch,
                ),
              ),

              const SizedBox(height: 20),

              // Popular Category Section
              const Text(
                "Popular category",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 40, // Height for horizontal category list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFF2C2C2C), // Darker grey for categories
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          _categories[index],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Popular Books Section
              FutureBuilder<List<Book>>(
                future: _popularBooksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No popular books found.',
                            style: TextStyle(color: Colors.white70)));
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 250, // Height for horizontal book list
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final book = snapshot.data![index];
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

              // Best Seller Section
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
                      // TODO: Navigate to a "See All" best sellers page
                    },
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        color: Color(0xFFF09E54), // Orange accent color
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
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No best seller books found.',
                            style: TextStyle(color: Colors.white70)));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true, // Important for nested ListView
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling for this list
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final book = snapshot.data![index];
                        return BestSellerBookItem(book: book);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(selectedIndex: 0),
    );
  }
}

// Widget for a single book card in Popular Books (horizontal list)
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
                        child:
                            const Icon(Icons.book_outlined, color: Colors.grey),
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

// Widget for a single best seller book item (vertical list)
class BestSellerBookItem extends StatelessWidget {
  final Book book;
  const BestSellerBookItem({super.key, required this.book});

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
                        child:
                            const Icon(Icons.book_outlined, color: Colors.grey),
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
