import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final int currentHp;
  final int maxHp;
  final int currentStreak;
  final bool isLoggedIn; 
  final VoidCallback? onHpIconTap;

  const CustomAppBar({
    Key? key,
    this.actions,
    this.currentHp = 3,
    this.maxHp = 3,
    this.currentStreak = 0,
    this.isLoggedIn =
        false, 
    this.onHpIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarBackground,
      leading: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.appBarLogoBackground,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          AppText.enText['app_logo_text']!,
          style: const TextStyle(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onHpIconTap,
          child: Row(
            children: [
              const Icon(Icons.favorite, color: AppColors.hpIconColor),
              Text(
                ' $currentHp/$maxHp',
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Icon(
          Icons.local_fire_department,
          color: isLoggedIn ? AppColors.primary : AppColors.streakIconColor,
        ),
        Text(
          ' $currentStreak',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        const SizedBox(width: 16),
        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
