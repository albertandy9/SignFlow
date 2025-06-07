import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/services/user_data_service.dart';
import 'package:signflow/services/progress_service.dart';
import 'package:signflow/main_layout.dart';

class StreakCalendarPage extends StatefulWidget {
  const StreakCalendarPage({super.key});

  @override
  State<StreakCalendarPage> createState() => _StreakCalendarPageState();
}

class _StreakCalendarPageState extends State<StreakCalendarPage> {
  Map<String, bool> loginDays = {};
  int currentStreak = 0;
  int currentHp = 3;
  final int maxHp = 3;
  int lastLoginDayOfYear = 0;
  int lastLoginYear = 0;
  bool _isProcessingStreak = false;

  final UserDataService _userDataService = UserDataService();
  final ProgressService _progressService = ProgressService();

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final streakData = await _userDataService.loadStreakData();
    final userHp = await _progressService.getCurrentUserHp(maxHp);

    if (mounted) {
      setState(() {
        loginDays = streakData['loginDays'];
        currentStreak = streakData['currentStreak'];
        lastLoginDayOfYear = streakData['lastLoginDay'] as int? ?? 0;
        lastLoginYear = streakData['lastLoginYear'] as int? ?? 0;
        currentHp = userHp;
      });
    }
  }

  void _updateCalendarAndStreakInternal() async {
    if (_isProcessingStreak) return;

    setState(() {
      _isProcessingStreak = true;
    });

    final result = await _userDataService.checkLoginStreak((newHp) {
      if (mounted) {
        setState(() {
          currentHp = newHp;
        });
      }
    }, context);

    await _loadAllData();

    if (result['hpBonusEarned'] == true) {
      _showHpBonusDialog(
        result['finalCurrentStreak'] as int,
        result['currentHpAfterBonus'] as int,
      );
    }

    setState(() {
      _isProcessingStreak = false;
    });

    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 300));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainLayout(),
        ),
        (route) => false, 
      );
    }
  }

  void _showHpBonusDialog(int bonusStreak, int hpAfterBonus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Row(
            children: [
              const Icon(
                Icons.favorite,
                color: AppColors.hpIconColor,
                size: 30,
              ),
              const SizedBox(width: 10),
              Text(AppText.enText['hp_bonus_title']!),
            ],
          ),
          content: Text(
            '${AppText.enText['hp_bonus_content_prefix']!}$currentStreak${AppText.enText['hp_bonus_content_suffix_1']!}$currentHp${AppText.enText['hp_bonus_content_suffix_2']!}$maxHp',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppText.enText['ok_button']!),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final List<DateTime> fullMonthDates = [];
    for (int i = 0; i < daysInMonth; i++) {
      fullMonthDates.add(firstDayOfMonth.add(Duration(days: i)));
    }

    final int firstWeekdayOfMonth = firstDayOfMonth.weekday;
    final int emptyCellsStart = firstWeekdayOfMonth - 1;

    final DateTime streakStartDate = _userDataService.getStreakStartDate(
      currentStreak,
      lastLoginDayOfYear,
      lastLoginYear,
    );

    final List<DateTime> displayDatesForMiniStreak = [];
    for (int i = 0; i < 7; i++) {
      displayDatesForMiniStreak.add(streakStartDate.add(Duration(days: i)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('MMMM y').format(now)),
        backgroundColor: AppColors.streakHeader,
        foregroundColor: AppColors.textOnPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainLayout()),
              (route) => false,
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppText.enText['current_streak_display']!}$currentStreak${AppText.enText['days_suffix']!}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final List<String> shortDayNames = [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun',
                    ];
                    return Center(
                      child: Text(
                        shortDayNames[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 1.0,
                        ),
                    itemCount: fullMonthDates.length + emptyCellsStart,
                    itemBuilder: (context, index) {
                      if (index < emptyCellsStart) {
                        return Container();
                      }

                      final day = fullMonthDates[index - emptyCellsStart];
                      final dayKey = DateFormat('yyyy-MM-dd').format(day);
                      final isToday =
                          DateFormat('yyyy-MM-dd').format(now) == dayKey;
                      final isLoggedIn = loginDays.containsKey(dayKey);

                      Color circleColor;
                      Widget circleChild;

                      bool isPartofCurrentDisplayedStreak =
                          displayDatesForMiniStreak.any(
                            (d) => DateFormat('yyyy-MM-dd').format(d) == dayKey,
                          );

                      if (isPartofCurrentDisplayedStreak) {
                        final int dayIndexInDisplayedStreak =
                            displayDatesForMiniStreak.indexOf(day);
                        if (dayIndexInDisplayedStreak == 6) {
                          circleColor = AppColors.hpIconColor;
                          circleChild = const Icon(
                            Icons.favorite,
                            color: AppColors.textOnPrimary,
                            size: 16,
                          );
                        } else if (isLoggedIn) {
                          circleColor = AppColors.primary;
                          circleChild = const Icon(
                            Icons.local_fire_department,
                            color: AppColors.textOnPrimary,
                            size: 20,
                          );
                        } else if (isToday) {
                          circleColor = AppColors.streakDayToday;
                          circleChild = Text(
                            day.day.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          );
                        } else {
                          circleColor = AppColors.streakDayNotLogged;
                          circleChild = Text(
                            day.day.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                      } else {
                        if (isLoggedIn) {
                          circleColor = AppColors.streakDayLogged.withOpacity(
                            0.5,
                          );
                          circleChild = const Icon(
                            Icons.local_fire_department,
                            color: AppColors.textOnPrimary,
                            size: 20,
                          );
                        } else if (isToday) {
                          circleColor = AppColors.streakDayToday;
                          circleChild = Text(
                            day.day.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          );
                        } else {
                          circleColor = AppColors.streakDayNotLogged;
                          circleChild = Text(
                            day.day.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: circleColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color:
                                isToday
                                    ? AppColors.primary
                                    : AppColors.transparent,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [circleChild],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed:
                        _isProcessingStreak
                            ? null
                            : _updateCalendarAndStreakInternal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child:
                        _isProcessingStreak
                            ? const CircularProgressIndicator(
                              color: AppColors.textOnPrimary,
                            )
                            : Text(AppText.enText['update_calendar_button']!),
                  ),
                ),
              ],
            ),
          ),
          if (_isProcessingStreak)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}