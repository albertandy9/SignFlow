import 'package:flutter/material.dart';
import 'package:signflow/main_layout.dart';
import 'package:signflow/screens/auth_page.dart';
import 'package:signflow/utils/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:signflow/screens/lessons_page.dart';
import 'package:signflow/style/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'SignFlow',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Config.primaryColor,
          border: Config.outLineBorder,
          focusedBorder: Config.focusBorder,
          errorBorder: Config.errorBorder,
          enabledBorder: Config.outLineBorder,
          floatingLabelStyle: const TextStyle(color: Config.primaryColor),
          prefixIconColor: AppColors.textPrimary.withOpacity(0.38),
        ),
        scaffoldBackgroundColor: AppColors.surface,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.navbarBackground,
          selectedItemColor: AppColors.navbarSelectedItem,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: AppColors.navbarUnselectedItem,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        'main': (context) => const MainLayout(),
        '/lessons': (context) => const Lessons(unit: 1, chapter: 1, temp: 0),
      },
    );
  }
}
