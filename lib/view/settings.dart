// lib/view/settings.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:praktikum_1/application/login/view/login.dart';
import 'package:praktikum_1/widget/navigation.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User? _user;

  @override
  void initState() {
    super.initState();
    // Get the current user from Firebase Auth
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    // Navigate to login screen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _confirmSignOut() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text("Konfirmasi Logout",
            style: TextStyle(color: Colors.white)),
        content: Text("Apakah Anda yakin ingin keluar?",
            style: TextStyle(color: Colors.grey[300])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: Colors.grey[300])),
          ),
          TextButton(
            onPressed: _signOut,
            child: Text("Logout", style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C), // Dark background
      appBar: AppBar(
        title: const Text(
          "AKUN SAYA",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C1C1C),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30.0),
                // Profile Section
                Container(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/photo-1534528741775-53994a69daeb.webp"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        _user?.displayName ?? "Pengguna", // Display user's name
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _user?.email ?? "", // Display user's email
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
                // Settings Options
                Column(
                  children: [
                    _buildSettingsItem(
                      icon: FontAwesome.user_pen_solid,
                      title: "Pengaturan Akun",
                      onTap: () {
                        // TODO: Implement account settings page navigation
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsItem(
                      icon: FontAwesome.bell_solid,
                      title: "Notifikasi",
                      onTap: () {
                        // TODO: Implement notification settings page
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsItem(
                      icon: FontAwesome.arrow_right_from_bracket_solid,
                      title: "Logout",
                      onTap: _confirmSignOut,
                      titleColor: Colors.red.shade400, // Make logout red
                      iconColor: Colors.red.shade400,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(selectedIndex: 2),
    );
  }

  // Helper widget for creating styled settings items
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color(0xFF2C2C2C), // Dark item background
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? const Color(0xFFF09E54)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor ?? Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Bootstrap.chevron_right, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
