import 'package:flutter/material.dart';

class AppColors {
  // Base Palette
  static const Color primary = Color(0xFFF5A623); 
  static const Color secondary = Color(0xFFEF6C00); 
  static const Color accent = Color(0xFFFFF5E1); 
  static const Color background = Color(0xFFF9EBD7); 
  static const Color surface = Colors.white;
  static const Color shadow = Colors.grey;
  static const Color transparent = Colors.transparent;

  // Text & Icon
  static const Color textPrimary = Colors.black;
  static const Color textOnPrimary = Colors.white;
  static const Color icon = Colors.white;
  static Color textSecondary = Colors.grey.shade500;
  static const Color streakIconColor = Colors.grey;
  static const Color profileText = Colors.black87;

  // Buttons
  static const Color playButton = primary;
  static const Color unitButtonBackground = primary;
  static const Color lessonButtonBorder = primary;
  static const Color correctButton = secondary;
  static const Color restoreHpButton = Colors.blue;
  static const Color restoreHpButtonDisabled = Colors.grey;
  static const Color closeButton = Colors.black54;
  static const Color successColor = Colors.green;
  static const Color dangerColor = Colors.red;
  static const Color submitButton = correctButton;
  static const Color purchaseButtonEnabled = correctButton;
  static const Color purchaseButtonDisabled = Colors.grey;
  static const Color purchaseListItemIcon = Colors.red;
  static const Color logoutButton = Colors.orange;
  static const Color logoutButtonBorder = Colors.orange;
  static const Color saveChangesButton = Colors.orange;
  static const Color confirmLogoutButton =
      Colors.red; 
  static const Color cancelLogoutButton =
      primary; 

  // Labels & Chips
  static const Color unitLabelBackground = secondary;
  static const Color chapterLabelBackground = primary;
  static const Color chipColor = secondary;
  static const Color headerColor = primary;
  static const Color trialBadgeBackground = Colors.deepOrange;
  static const Color mostPopularLabel =
      Colors.orange; 

  // Tile & Cards
  static const Color tileBackground = surface;
  static const Color tileShadow = shadow;
  static const Color chapterCardBackground = Color(0xFFF5EEE1);
  static const Color profileCardBackground = surface;
  static Color profileCardBorder = Colors.grey.shade300;
  static Color paymentPlanCardSelectedBackground = primary.withOpacity(
    0.05,
  ); 
  static const Color purchaseHistoryCardBackground =
      surface; 

  // Other
  static const Color separatorColor = surface;
  static const Color videoPlaceholder = Colors.red;
  static const Color optionBackground = transparent;
  static const Color optionText = textPrimary;
  static const Color hpIconColor = Colors.red;
  static const Color trophyColor = Colors.orange;
  static const Color certificateBorder = Colors.orange;
  static const Color certificateBackground = Color(0xFFFFF1DC);
  static const Color certificateIcon =
      primary; 
  static const Color certificateDownloadButton =
      primary; 
  static const Color purchaseHistorySubscriptionIcon =
      Colors.blue; 

  // Gradients
  static const Color gradientStart = background;
  static const Color gradientEnd = accent;

  // AppBar and Navbar Colors
  static const Color appBarBackground = surface;
  static const Color appBarLogoBackground = textPrimary;
  static const Color navbarBackground = primary;
  static const Color navbarSelectedItem = surface;
  static Color navbarUnselectedItem = Colors.grey.shade700;

  // Streak Calendar Page specific colors
  static const Color streakDayLogged = Colors.green; 
  static Color streakDayToday = primary.withOpacity(0.1); 
  static Color streakDayNotLogged = Colors.grey; 
  static Color streakHeader = primary; 
}
