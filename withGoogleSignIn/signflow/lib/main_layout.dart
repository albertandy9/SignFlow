import 'package:flutter/material.dart';
import 'package:signflow/components/common/appbar.dart';
import 'package:signflow/components/common/navbar.dart'; 
import 'package:signflow/screens/dictionary_page.dart';
import 'package:signflow/screens/home_page.dart';
import 'package:signflow/screens/profile_page.dart';
import 'package:signflow/services/progress_service.dart';
import 'package:signflow/services/user_data_service.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/style/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  int _currentHp = 3;
  int _currentStreak = 0;
  bool _isLoggedIn = false;
  final int _maxHp = 3;

  final GlobalKey<HomepageState> _homePageKey = GlobalKey<HomepageState>();
  final ProgressService _progressService = ProgressService();
  late final UserDataService _userDataService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userDataService = UserDataService(maxHp: _maxHp);
    _checkLoginStatusAndLoadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLoginStatusAndLoadData();
    }
  }

  Future<void> _checkLoginStatusAndLoadData() async {
    final user = FirebaseAuth.instance.currentUser;
    final bool currentlyLoggedIn = user != null;

    bool shouldRebuild = false;
    if (_isLoggedIn != currentlyLoggedIn) {
      _isLoggedIn = currentlyLoggedIn;
      shouldRebuild = true;
    }

    if (_isLoggedIn) {
      final progressData = await _progressService.loadProgress(_maxHp);
      final streakData = await _userDataService.loadStreakData();

      if (_currentHp != progressData['userHp']) {
        _currentHp = progressData['userHp'];
        shouldRebuild = true;
      }
      if (_currentStreak != streakData['currentStreak']) {
        _currentStreak = streakData['currentStreak'];
        shouldRebuild = true;
      }
    } else {
      if (_currentHp != _maxHp || _currentStreak != 0) {
        _currentHp = _maxHp;
        _currentStreak = 0;
        shouldRebuild = true;
      }
    }

    if (shouldRebuild && mounted) {
      setState(() {});
    }
  }

  void _updateUserHp(int newHp) {
    setState(() {
      _currentHp = newHp;
    });
  }

  Future<void> _checkLoginStreakAndReload() async {
    await _userDataService.checkLoginStreak(
      (newHp) => _updateUserHp(newHp),
      context,
    );
    _checkLoginStatusAndLoadData();
  }

  void _handleHpIconTap() async {
    if (_selectedIndex == 0 && _homePageKey.currentState != null) {
      final result = await _homePageKey.currentState!.showHpStatusDialog();
      if (result == true && mounted) {
        _checkLoginStatusAndLoadData();
      }
    } else {
      setState(() {
        _selectedIndex = 0;
      });
      Future.delayed(const Duration(milliseconds: 50), () async {
        final result = await _homePageKey.currentState?.showHpStatusDialog();
        if (result == true && mounted) {
          _checkLoginStatusAndLoadData();
        }
      });
    }
  }

  List<Widget> get _pages => [
    Homepage(
      key: _homePageKey,
      currentHp: _currentHp,
      onHpUpdate: _updateUserHp,
    ),
    const DictionaryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        currentHp: _currentHp,
        maxHp: _maxHp,
        currentStreak: _currentStreak,
        isLoggedIn: _isLoggedIn,
        onHpIconTap: _handleHpIconTap,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            tooltip: AppText.enText['reset_progress_tooltip']!,
            onPressed: _resetAllProgress,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _checkLoginStatusAndLoadData();
        },
      ),
    );
  }

  Future<void> _resetAllProgress() async {
    await _userDataService.resetProgress(context, _updateUserHp);
    _checkLoginStatusAndLoadData();
  }
}
