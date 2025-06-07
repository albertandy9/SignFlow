import 'package:flutter/material.dart';
import 'package:signflow/style/app_color.dart'; 
import 'package:signflow/style/text.dart'; 

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Navbar({Key? key, required this.currentIndex, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: AppColors.navbarBackground, 
      selectedItemColor: AppColors.navbarSelectedItem, 
      unselectedItemColor: AppColors.navbarUnselectedItem, 
      showSelectedLabels: true,
      showUnselectedLabels: false,
      elevation: 10,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppText.enText['navbar_home']!,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.book),
          label: AppText.enText['navbar_dictionary']!,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_circle),
          label: AppText.enText['navbar_profile']!, 
        ),
      ],
    );
  }
}
