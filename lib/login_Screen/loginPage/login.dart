import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/login_Screen/AuthService/AuthService.dart';
import 'package:quiz_app/login_Screen/Signup_page/SignUp.dart';
import 'package:quiz_app/views/quiz_category.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/bg img 5.jpg',
            fit: BoxFit.cover,
            height: size.height,
            width: size.width,
          ),
          // Main Content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    hintText: "Email",
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _passController,
                    hintText: "Password",
                    prefixIcon: Icons.lock,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLoginButton(context),
                  const SizedBox(height: 20),
                  _buildGuestButton(),
                  const SizedBox(height: 10),
                  _buildSignUpLink(context),
                  _buildOrDivider(),
                  _buildGoogleSignInButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xff1c2341),
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          final email = _emailController.text.trim();
          final password = _passController.text.trim();

          if (email.isEmpty || password.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please fill all the fields")),
            );
            return;
          }

          try {
            UserCredential? userCredential =
                await _authService.signInWithEmail(email, password);

            if (userCredential != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => QuizCategory()),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Login failed: ${e.toString()}")),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 13, 147, 130),
        ),
        child: const Text(
          "LOGIN",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildGuestButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => QuizCategory());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 13, 147, 130),
        ),
        child: const Text(
          "GUEST",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Signup_Page()),
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an Account? ",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            "Sign Up",
            style: TextStyle(color: Colors.blue, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildOrDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "OR",
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          User? user = await _authService.signInWithGoogle();
          if (user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => QuizCategory()),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Google Sign-In failed: ${e.toString()}")),
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
    );
  }
}
