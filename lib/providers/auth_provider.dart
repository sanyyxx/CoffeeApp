import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        int retries = 3;
        int delay = 1000;

        while (retries > 0) {
          try {
            await _firestore.collection('users').doc(credential.user!.uid).set({
              'name': name,
              'email': email,
              'bonusPoints': 0,
              'createdAt': FieldValue.serverTimestamp(),
            });
            print('User data saved to Firestore for UID: ${credential.user!.uid}');
            return true;
          } catch (firestoreError) {
            if (firestoreError.toString().contains('unavailable') && retries > 0) {
              retries--;
              print('Retrying Firestore write after $delay ms: $firestoreError');
              await Future.delayed(Duration(milliseconds: delay));
              delay *= 2;
            } else {
              print('Firestore error during sign-up: $firestoreError');
              await credential.user!.delete(); // Откат: удаляем пользователя
              return false;
            }
          }
        }
      }
      return false;
    } catch (authError) {
      print('Authentication error during sign-up: $authError');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}