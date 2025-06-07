import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart'; 

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Existing: Email/Password Sign In
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

  // Existing: Email/Password Create User
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
        await _updateUserFirestore(user); 
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

  // New: Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null) {
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        await _updateUserFirestore(userCredential.user!);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase Auth Error during Google sign-in: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint('General error during Google sign-in: $e');
      rethrow;
    }
  }

  Future<UserCredential?> signInWithMicrosoft() async {
    debugPrint('Microsoft sign-in attempted: This is a placeholder.');
    throw UnsupportedError('Microsoft sign-in is not yet implemented.');
  }

  // Existing: Change Password
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

  // Existing: Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<void> _updateUserFirestore(User user) async {
    final userDocRef = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDocRef.get();

    if (!docSnapshot.exists) {
      await userDocRef.set({
        'uid': user.uid,
        'displayName':
            user.displayName ?? user.email?.split('@')[0] ?? 'New User',
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'unlockedLesson': 0,
        'completedChapters': [],
        'completedLessons': [],
        'userHp': 3, 
        'currentStreak': 0,
        'loginDays': [],
        'lastLoginDay': 0,
        'lastLoginYear': 0,
      });
      debugPrint('New user document created in Firestore for UID: ${user.uid}');
    } else {
      await userDocRef.update({
        'displayName': user.displayName ?? user.email?.split('@')[0],
        'email': user.email,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint(
        'Existing user document updated in Firestore for UID: ${user.uid}',
      );
    }
  }
}
