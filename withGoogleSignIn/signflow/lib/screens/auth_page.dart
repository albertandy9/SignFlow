import 'package:flutter/material.dart';
import 'package:signflow/components/auth/login_form.dart';
import 'package:signflow/components/auth/signup_form.dart';
import 'package:signflow/components/common/social_button.dart'; 
import 'package:signflow/utils/config.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/style/app_color.dart'; 

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppText.enText['welcome_text']!,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                isSignIn
                    ? AppText.enText['signIn_text']!
                    : AppText.enText['register_text']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Column(
                  children: [
                    isSignIn ? const LoginForm() : const SignUpForm(),
                    const SizedBox(height: 25),
                    if (isSignIn)
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            AppText.enText['forgot-password']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  AppColors
                                      .textPrimary, 
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  AppText.enText['social-login']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textSecondary, 
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SocialButton(social: 'google'),
                  SizedBox(height: 10),
                  SocialButton(social: 'microsoft'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    isSignIn
                        ? AppText.enText['signUp_text']!
                        : AppText.enText['registered_text']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSignIn = !isSignIn;
                      });
                    },
                    child: Text(
                      isSignIn
                          ? AppText.enText['signUp_button']!
                          : AppText.enText['signIn_button']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
