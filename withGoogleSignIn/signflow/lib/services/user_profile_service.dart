import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; 
import 'package:signflow/services/user_data_service.dart'; 

class UserProfileService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserDataService _userDataService =
      UserDataService(); 

  Map<String, String?> getCurrentUserData() {
    final user = _firebaseAuth.currentUser;
    return {'username': user?.displayName, 'email': user?.email};
  }

  Future<Map<String, dynamic>> loadStreakData() async {
    return await _userDataService
        .loadStreakData(); 
  }

  Future<void> updateProfile(
    String newName,
    String newEmail,
    String currentPassword,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      if (newName != user.displayName) {
        await user.updateDisplayName(newName);
      }

      if (newEmail != user.email) {
        await user.updateEmail(newEmail);
      }

      final userDocRef = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        await userDocRef.update({
          'displayName': newName,
          'email': newEmail,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('Firestore document updated successfully.');
      } else {
        await userDocRef.set({
          'uid': user.uid,
          'displayName': newName,
          'email': newEmail,
          'createdAt': FieldValue.serverTimestamp(),
        });
        debugPrint('New Firestore document created.');
      }

      await user.reload();
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase Auth error during profile update: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint('General error during profile update: $e');
      rethrow;
    }
  }
}
