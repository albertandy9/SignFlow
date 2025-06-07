import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/components/common/button.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/services/auth_service.dart'; 

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  String? errorMessage;
  final AuthService _authService = AuthService(); 

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: AppText.enText['email_address_hint']!,
              labelText: AppText.enText['email_label']!,
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.email_outlined),
              prefixIconColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: AppColors.primary,
            obscureText: obsecurePass,
            decoration: InputDecoration(
              hintText: AppText.enText['password_hint']!,
              labelText: AppText.enText['password_label']!,
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.lock_outline),
              prefixIconColor: AppColors.primary,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obsecurePass = !obsecurePass;
                  });
                },
                icon: Icon(
                  obsecurePass
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color:
                      obsecurePass
                          ? AppColors.textPrimary.withOpacity(0.38)
                          : AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                errorMessage!,
                style: AppTextStyles.completedText.copyWith(color: Colors.red),
              ),
            ),
          Button(
            width: double.infinity,
            title: AppText.enText['signIn_button']!,
            onPressed: () async {
              setState(() {
                errorMessage = null;
              });

              try {
                await _authService.signInWithEmailAndPassword(
                  _emailController.text.trim(),
                  _passController.text.trim(),
                );
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, 'main');
                }
              } catch (e) {
                debugPrint('Login gagal: $e');
                setState(() {
                  errorMessage = AppText.enText['login_error_wrong'];
                });
              }
            },
            disable: false,
          ),
        ],
      ),
    );
  }
}