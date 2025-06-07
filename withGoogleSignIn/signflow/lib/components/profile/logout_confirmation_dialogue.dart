import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';

Future<void> showLogoutConfirmationDialog(
  BuildContext context,
  VoidCallback onConfirm,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.surface, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppText.enText['dialog_logout_title']!,
          style: const TextStyle(
            color: AppColors.textPrimary,
          ), 
        ),
        content: Text(
          AppText.enText['dialog_logout_content']!,
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              side: const BorderSide(
                color: AppColors.cancelLogoutButton,
              ), 
              foregroundColor: AppColors.cancelLogoutButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              AppText.enText['dialog_logout_cancel']!,
            ), 
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onConfirm();
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.confirmLogoutButton, 
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              AppText.enText['dialog_logout_confirm']!,
            ),
          ),
        ],
      );
    },
  );
}
