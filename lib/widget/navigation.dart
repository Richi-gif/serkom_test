import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:praktikum_1/view/books.dart';
import 'package:praktikum_1/view/home.dart';
import 'package:praktikum_1/view/settings.dart';

class CustomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  const CustomNavigationBar({required this.selectedIndex, super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  void _onItemTapped(int index) {
    if (index == widget.selectedIndex) {
      return;
    }

    Widget nextPage = const MyHomePage();

    switch (index) {
      case 0:
        nextPage = const MyHomePage();
        break;
      case 1:
        nextPage = const BooksPage();
        break;
      case 2:
        nextPage = const Settings();
        break;
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 12,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(FontAwesome.house_chimney_solid, 'Beranda', 0),
          _buildNavItem(FontAwesome.book_open_solid, 'Buku', 1),
          _buildNavItem(FontAwesome.user_solid, 'Akun Saya', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = widget.selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFF881FFF) : Colors.grey),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF881FFF) : Colors.grey,
                fontSize: 14, // Set font size here
              ),
            ),
          ],
        ),
      ),
    );
  }
}
