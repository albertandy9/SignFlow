import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; 

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase Auth Error during sign-in: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint('General error during sign-in: $e');
      rethrow;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);

        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'displayName': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await user.reload();
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase Auth Error during sign-up: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint('General error during sign-up: $e');
      rethrow;
    }
  }

  // Method to change user password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user signed in',
      );
    }
    if (user.email == null) {
      throw FirebaseAuthException(
        code: 'no-email',
        message: 'User email not found',
      );
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase Auth Error during password change: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint('General error during password change: $e');
      rethrow;
    }
  }

  // New: Method to sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
