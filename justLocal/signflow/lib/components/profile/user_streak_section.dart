import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';

class UserStreakSection extends StatefulWidget {
  final int currentStreak;
  final Map<String, bool> loginDays;

  const UserStreakSection({
    super.key,
    required this.currentStreak,
    required this.loginDays,
  });

  @override
  State<UserStreakSection> createState() => _UserStreakSectionState();
}

class _UserStreakSectionState extends State<UserStreakSection> {
  final List<String> _fixedShortDayNames = [
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
    'S',
  ];

  @override
  Widget build(BuildContext context) {
    DateTime streakStartDate;
    if (widget.currentStreak == 0) {
      streakStartDate = DateTime.now().subtract(
        const Duration(days: 0),
      ); 
    } else {
      streakStartDate = DateTime.now().subtract(
        Duration(days: widget.currentStreak - 1),
      );
    }

    final List<DateTime> displayDates = [];
    for (int i = 0; i < 7; i++) {
      displayDates.add(streakStartDate.add(Duration(days: i)));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.profileCardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.profileCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '${AppText.enText['streak_current']!}${widget.currentStreak}${AppText.enText['days_suffix']!}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final currentDisplayDate = displayDates[index];
              final dayNameIndex =
                  (currentDisplayDate.weekday -
                      1);
              if (dayNameIndex < 0 ||
                  dayNameIndex >= _fixedShortDayNames.length)
                return const SizedBox();

              return Text(
                _fixedShortDayNames[dayNameIndex],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      (DateFormat('yyyy-MM-dd').format(currentDisplayDate) ==
                              DateFormat('yyyy-MM-dd').format(DateTime.now()))
                          ? FontWeight.bold
                          : FontWeight.normal,
                  color:
                      (DateFormat('yyyy-MM-dd').format(currentDisplayDate) ==
                              DateFormat('yyyy-MM-dd').format(DateTime.now()))
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final date = displayDates[index];
              final dayKey = DateFormat('yyyy-MM-dd').format(date);
              final isLogged = widget.loginDays.containsKey(dayKey);
              final isToday =
                  dayKey == DateFormat('yyyy-MM-dd').format(DateTime.now());

              Color circleColor;
              Widget circleChild;
              bool isBonusDayIndicator = false;
              if (index == 6) {
                isBonusDayIndicator = true;
              }

              if (isBonusDayIndicator) {
                circleColor = AppColors.hpIconColor;
                circleChild = const Icon(
                  Icons.favorite,
                  color: AppColors.textOnPrimary,
                  size: 18,
                );
              } else if (isLogged) {
                circleColor = AppColors.primary;
                circleChild = const Icon(
                  Icons.local_fire_department,
                  color: AppColors.textOnPrimary,
                  size: 18,
                );
              } else if (isToday) {
                circleColor =
                    AppColors
                        .streakDayToday;
                circleChild = Text(
                  date.day.toString(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else {
                circleColor =
                    AppColors
                        .streakDayNotLogged;
                circleChild = Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: circleColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: circleChild,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
