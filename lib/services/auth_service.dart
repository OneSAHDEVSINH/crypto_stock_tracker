import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();  // Notify listeners when authentication state changes
    });
  }

  // Register with email and password
  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;  // No error
    } catch (e) {
      return _getErrorMessage(e);  // Return error message
    }
  }

  // Login with email and password
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;  // No error
    } catch (e) {
      return _getErrorMessage(e);  // Return error message
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Return a user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'The email is already in use by another account.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'weak-password':
          return 'The password is too weak.';
        default:
          return 'An undefined Error happened.';
      }
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
