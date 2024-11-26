import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/login_Screen/AuthService/AuthService.dart';
import 'package:quiz_app/login_Screen/loginPage/login.dart';
import 'package:quiz_app/views/quiz_category.dart';

class Signup_Page extends StatelessWidget {
  final AuthService _authService = AuthService(); // Use AuthService

  Signup_Page({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passController = TextEditingController();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/bg img 5.jpg',
          fit: BoxFit.fill,
        ),
        Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign up",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    SizedBox(height: 40),
                    // Email input
                    Container(
                      width: size.width * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff1c2341),
                          hintText: "Email",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: size.width * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff1c2341),
                          hintText: "password",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: Icon(Icons.visibility_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: size.width * 0.8,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          final email = _emailController.text.trim();
                          final password = _passController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            // Show error for empty fields
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please fill out all fields.")),
                            );
                            return;
                          }

                          // Validate email format
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please enter a valid email address.")),
                            );
                            return;
                          }

                          try {
                            // Sign up user
                            UserCredential? userCredential = await _authService
                                .signUpWithEmailandPassword(email, password);

                            if (userCredential != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Sign up successful!")),
                              );

                              // Navigate to the QuizCategory screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuizCategory()),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            // Handle specific Firebase errors
                            String errorMessage;
                            switch (e.code) {
                              case 'weak-password':
                                errorMessage = "The password is too weak.";
                                break;
                              case 'email-already-in-use':
                                errorMessage =
                                    "This email is already registered.";
                                break;
                              default:
                                errorMessage = "Error: ${e.message}";
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMessage)),
                            );
                          } catch (e) {
                            // General error handling
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Error signing up: ${e.toString()}")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 13, 147, 130)),
                        child: const Text("SIGN UP",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an Account?",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          Text(
                            " Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    OrDivider(),
                    // Google sign-in button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            print("object");
                            try {
                              User? user =
                                  await _authService.signInWithGoogle();
                              print("Google Singing ${user}");

                              // If sign-in is successful, navigate to HomePage
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuizCategory()),
                              );
                              print('Google sign-in success');
                            } catch (e) {
                              print(e.toString());

                              // Show error message in Snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to sign in with Google: ${e.toString()}')),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              "assets/google (2).png",
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

// OR Divider Widget
class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.7,
      child: Row(
        children: <Widget>[
          buildDivider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              textAlign: TextAlign.center,
              "OR",
              style:
                  TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Color.fromARGB(246, 60, 59, 66),
        height: 1.5,
      ),
    );
  }
}
