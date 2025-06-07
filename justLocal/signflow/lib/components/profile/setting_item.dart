import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart';

Widget buildSettingsItem({
  IconData? icon,
  Widget? leadingWidget,
  required String title,
  Widget? trailing,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading:
        leadingWidget ??
        Icon(icon, size: 24, color: AppColors.profileText),
    title: Text(
      title,
      style: const TextStyle(color: AppColors.profileText),
    ),
    trailing:
        trailing ??
        const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: AppColors.primary,
        ),
    onTap: onTap,
  );
}
