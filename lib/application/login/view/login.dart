import 'package:flutter/material.dart';
// import 'package:icons_plus/icons_plus.dart'; // Not directly used in this design
import 'package:praktikum_1/view/home.dart';
import 'package:praktikum_1/application/register/view/register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praktikum_1/application/login/bloc/login_bloc.dart';
import 'package:praktikum_1/application/login/bloc/login_event.dart';
import 'package:praktikum_1/application/login/bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true; // Set to true to initially hide password
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD), // Light warm background
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(
              0xFFFDFDFD), // Ensure container background is consistent
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is LoginSuccess) {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => MyHomePage()));
              } else if (state is LoginFailure) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                  ),
                );
              }
            },
            child: Column(
              children: <Widget>[
                // Top Illustration
                Container(
                  width: double.infinity,
                  height: 250, // Adjust height as needed
                  alignment: Alignment.center, // Center the image
                  child: Image.asset(
                    'assets/buku.png', // Your book illustration image
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20), // Space between image and tabs

                // Login / Signup Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[
                          200], // Light background for the segmented control
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Stay on Login page (already here)
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xFFF09E54), // Warm orange for active tab
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .white, // White text for active tab
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors
                                    .transparent, // Transparent for inactive tab
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Signup",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[
                                        700], // Darker grey for inactive text
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40.0), // Space between tabs and form

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0), // Padding for the form elements
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Field
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                          hintText:
                              '20231067@student.itk.ac.id', // Placeholder from image
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          filled: true,
                          fillColor: Colors.grey[
                              100], // Light grey background for text field
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: 16.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // More rounded corners
                            borderSide: BorderSide.none, // No border line
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Color(0xFFF09E54),
                                width: 1.5), // Orange accent border on focus
                          ),
                          suffixIcon: email.text.isNotEmpty
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                              : null, // Checkmark only if text is present
                        ),
                        onChanged: (text) {
                          setState(() {
                            // Trigger rebuild to show/hide checkmark
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),

                      // Password Field
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: password,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          hintText: '********', // Placeholder from image
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: 16.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Color(0xFFF09E54),
                                width: 1.5), // Orange accent border on focus
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            child: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implement forgot password logic
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Color(
                                  0xFFF09E54), // Purple accent for links/forgot password as in original image
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final emailText = email.text.trim();
                            final passwordText = password.text.trim();
                            print(emailText);
                            print(passwordText);
                            if (emailText.isNotEmpty &&
                                passwordText.isNotEmpty) {
                              context.read<LoginBloc>().add(
                                    LoginRequested(
                                      email: emailText,
                                      password: passwordText,
                                    ),
                                  );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFFF09E54), // Purple for the main button
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Removed the "Don't have an account? Signup" section
                      const SizedBox(height: 20.0), // Bottom padding
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
