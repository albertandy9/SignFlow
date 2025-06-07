import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart';

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
    this.isLoggedIn = false,
    this.onHpIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarBackground,
      leading: Padding( 
        padding: const EdgeInsets.only(bottom: 5.0), 
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.appBarLogoBackground,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: ClipOval(
            child: Image.asset(
              'assets/AppIcons/logo.jpg',
              fit: BoxFit.contain, 
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 36,
                );
              },
            ),
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