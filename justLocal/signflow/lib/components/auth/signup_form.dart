import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/components/common/button.dart';
import 'package:signflow/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.createUserWithEmailAndPassword(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passController.text.trim(),
      );

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, 'main');
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? AppText.enText['signup_error_general']!),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppText.enText['signup_error_unexpected']!)),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = AppText.enText;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: text['full_name_label']!,
              hintText: text['full_name_hint']!,
              prefixIcon: const Icon(Icons.person),
              prefixIconColor: AppColors.primary,
            ),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? text['name_empty_error']
                        : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: text['email_label']!,
              hintText: text['email_address_hint']!,
              prefixIcon: const Icon(Icons.email_outlined),
              prefixIconColor: AppColors.primary,
            ),
            validator:
                (value) =>
                    value == null || !value.contains('@')
                        ? text['email_wrong']
                        : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passController,
            obscureText: _obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: text['password_label']!,
              hintText: text['password_hint']!,
              prefixIcon: const Icon(Icons.lock_outline),
              prefixIconColor: AppColors.primary,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color:
                      _obscurePassword
                          ? AppColors.textPrimary.withOpacity(0.38)
                          : AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator:
                (value) =>
                    value == null || value.length < 6
                        ? text['password_wrong']
                        : null,
          ),
          const SizedBox(height: 24),
          Button(
            width: double.infinity,
            title: text['signUp_button']!,
            disable: _isLoading,
            onPressed: _register,
          ),
        ],
      ),
    );
  }
}
