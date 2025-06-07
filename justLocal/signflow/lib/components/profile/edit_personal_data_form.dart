import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/services/user_profile_service.dart';

class EditPersonalDataForm extends StatefulWidget {
  const EditPersonalDataForm({super.key});

  @override
  State<EditPersonalDataForm> createState() => _EditPersonalDataFormState();
}

class _EditPersonalDataFormState extends State<EditPersonalDataForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  final UserProfileService _userProfileService =
      UserProfileService(); 

  @override
  void initState() {
    super.initState();
    final userData = _userProfileService.getCurrentUserData();
    _firstNameController.text = userData['username'] ?? '';
    _emailController.text = userData['email'] ?? '';
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final newName = _firstNameController.text.trim();
    final newEmail = _emailController.text.trim();
    final currentPassword = _passwordController.text.trim();

    if (currentPassword.isEmpty) {
      setState(() {
        _errorMessage = AppText.enText['fill_all_data_error']!; 
        _isLoading = false;
      });
      return;
    }

    try {
      await _userProfileService.updateProfile(
        newName,
        newEmail,
        currentPassword,
      ); 

      if (context.mounted) {
        _showSnackBar(
          AppText.enText['profile_update_success']!,
        ); // Using AppText
        Navigator.pop(context, true);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'wrong-password') {
          _errorMessage = AppText.enText['password_wrong']!;
        } else if (e.code == 'user-not-found') {
          _errorMessage = AppText.enText['email_wrong']!;
        } else if (e.code == 'invalid-email') {
          _errorMessage =
              AppText
                  .enText['email_wrong']!; 
        } else {
          _errorMessage =
              e.message ??
              AppText.enText['failed_update_profile']!; 
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            '${AppText.enText['unexpected_error']!} ${e.toString()}'; 
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppText.enText['edit_personal_data_title']!,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            Text(
              AppText.enText['name_label']!, 
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.profileText,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            Text(
              AppText.enText['email_label_edit']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.profileText,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            Text(
              AppText.enText['current_password_edit_label']!, 
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.profileText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppText.enText['password_to_update_email_hint']!, 
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed:
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: AppColors.dangerColor,
                  ),
                ),
              ),

            const SizedBox(height: 24),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.saveChangesButton, 
                  foregroundColor: AppColors.textOnPrimary, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(
                          color: AppColors.textOnPrimary,
                        ) 
                        : Text(
                          AppText
                              .enText['save_changes_button']!, 
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
