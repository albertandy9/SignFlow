import 'package:signflow/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:signflow/services/auth_service.dart'; 
import 'package:signflow/main_layout.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 

class SocialButton extends StatelessWidget {
  final String social;

  const SocialButton({super.key, required this.social});

  // New: Handle social login tap
  Future<void> _handleSocialLogin(BuildContext context) async {
    final AuthService _authService = AuthService();
    UserCredential? userCredential; 
    try {
      if (social == 'google') {
        userCredential = await _authService.signInWithGoogle();
      } else if (social == 'microsoft') {
        userCredential = await _authService.signInWithMicrosoft();
      }

      if (userCredential != null &&
          userCredential.user != null &&
          context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
          (route) => false,
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login with ${social.toUpperCase()} cancelled or failed.',
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        String message =
            'Failed to login with ${social.toUpperCase()}: ${e.message ?? "Unknown error."}';
        if (e.code == 'account-exists-with-different-credential') {
          message =
              'An account already exists with the same email address but different sign-in credentials. Please try signing in with your existing method.';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to login with ${social.toUpperCase()}: ${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: const BorderSide(width: 1, color: Colors.grey),
        ),
        onPressed:
            () => _handleSocialLogin(
              context,
            ), // <<< Panggil fungsi handler di sini
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/authimg/$social.png', width: 20, height: 20),
            const SizedBox(width: 8),
            Text(
              social.toUpperCase(),
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
