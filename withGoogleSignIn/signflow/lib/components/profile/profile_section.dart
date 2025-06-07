import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart';

class ProfileSection extends StatelessWidget {
  final String? username;
  final String? email;

  const ProfileSection({super.key, this.username, this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      width: double.infinity,
      color: AppColors.background,
      child: Column(
        children: [
          if (username != null && username!.isNotEmpty)
            Text(
              username!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          if (email != null && email!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              email!,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ), 
            ),
          ],
        ],
      ),
    );
  }
}
