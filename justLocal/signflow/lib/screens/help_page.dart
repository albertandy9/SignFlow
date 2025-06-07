import 'package:flutter/material.dart';
import 'package:signflow/style/text.dart'; 
import 'package:signflow/style/app_color.dart'; 

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.enText['help_page_title']!), 
        backgroundColor: AppColors.appBarBackground, 
        foregroundColor: AppColors.textPrimary, 
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppText.enText['help_page_content']!, 
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ), 
          ),
        ),
      ),
    );
  }
}
