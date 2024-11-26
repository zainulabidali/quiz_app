import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  get userState => null;

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // User canceled the sign-in.
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Specific FirebaseAuthException handling
      print('Sign in error: ${e.message}');
      return null;
    } catch (e) {
      // General error handling
      print('Error signing in: ${e.toString()}');
      return null;
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Sign up error: ${e.message}');
      return null;
    } catch (e) {
      print('Error signing up: ${e.toString()}');
      return null;
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("Successfully signed out");
    } catch (e) {
      print('Error signing out: ${e.toString()}');
    }
  }

  // Get the currently authenticated user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if a user is signed in
  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }
}
