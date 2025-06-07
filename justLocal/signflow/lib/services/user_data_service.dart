import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/services/progress_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  final int maxHp;
  final ProgressService _progressService;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? get _currentUserUid => _firebaseAuth.currentUser?.uid;

  UserDataService({this.maxHp = 3}) : _progressService = ProgressService();

  Future<Map<String, dynamic>> loadStreakData() async {
    final uid = _currentUserUid;
    if (uid == null) {
      return {
        'currentStreak': 0,
        'loginDays':
            <String, bool>{}, 
        'lastLoginDay': 0,
        'lastLoginYear': 0,
      };
    }

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final List<dynamic> storedLoginDays =
            data['loginDays'] as List<dynamic>? ?? [];
        final Map<String, bool> loginDaysMap = Map.fromIterable(
          storedLoginDays.cast<String>(),
          key: (item) => item,
          value:
              (item) =>
                  true, 
        );

        return {
          'currentStreak': data['currentStreak'] as int? ?? 0,
          'loginDays': loginDaysMap, 
          'lastLoginDay': data['lastLoginDay'] as int? ?? 0,
          'lastLoginYear': data['lastLoginYear'] as int? ?? 0,
        };
      } else {
        await _firestore.collection('users').doc(uid).set({
          'currentStreak': 0,
          'loginDays': [], 
          'lastLoginDay': 0,
          'lastLoginYear': 0,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        return {
          'currentStreak': 0,
          'loginDays': <String, bool>{},
          'lastLoginDay': 0,
          'lastLoginYear': 0,
        };
      }
    } catch (e) {
      debugPrint('Error loading streak data from Firestore: $e');
      return {
        'currentStreak': 0,
        'loginDays': <String, bool>{},
        'lastLoginDay': 0,
        'lastLoginYear': 0,
      };
    }
  }

  Future<void> saveStreakData(
    int currentStreak,
    int lastLoginDay,
    int lastLoginYear,
    Map<String, bool> loginDays, 
  ) async {
    final uid = _currentUserUid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      'currentStreak': currentStreak,
      'lastLoginDay': lastLoginDay,
      'lastLoginYear': lastLoginYear,
      'loginDays':
          loginDays.keys.toList(), 
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>> checkLoginStreak(
    Function(int) onHpUpdate,
    BuildContext context,
  ) async {
    final uid = _currentUserUid;
    if (uid == null) {
      return {
        'hpBonusEarned': false,
        'currentHpAfterBonus': null,
        'finalCurrentStreak': 0,
      };
    }

    final now = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(now);
    final todayDayOfYear = _getDayOfYear(now);
    final todayYear = now.year;

    final Map<String, dynamic> streakData = await loadStreakData();
    Map<String, bool> loginDays = streakData['loginDays'];
    int currentStreak = streakData['currentStreak'];
    int lastLoginDay = streakData['lastLoginDay'];
    int lastLoginYear = streakData['lastLoginYear'];
    int currentHp = await _progressService.getCurrentUserHp(maxHp);

    bool hpBonusEarnedThisCheck = false;
    int currentHpAfterBonus = currentHp;

    if (loginDays.containsKey(todayKey)) {
      debugPrint('Already logged in today. Streak maintained.');
      return {
        'hpBonusEarned': false,
        'currentHpAfterBonus': currentHp,
        'finalCurrentStreak': currentStreak,
      };
    }

    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayDayOfYear = _getDayOfYear(yesterday);
    final yesterdayYear = yesterday.year;

    bool isConsecutive = false;
    if (lastLoginYear == yesterday.year && lastLoginDay == yesterdayDayOfYear) {
      isConsecutive = true;
    } else if (lastLoginYear == yesterdayYear &&
        todayDayOfYear == 1 &&
        lastLoginDay == _getDayOfYear(DateTime(lastLoginYear, 12, 31))) {
      isConsecutive = true;
    }

    loginDays[todayKey] = true;
    lastLoginDay = todayDayOfYear;
    lastLoginYear = todayYear;

    if (isConsecutive) {
      currentStreak++;
    } else {
      currentStreak = 1;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppText.enText['streak_reset']!)),
        );
      }
    }

    await saveStreakData(currentStreak, lastLoginDay, lastLoginYear, loginDays);

    if (currentStreak > 0 && currentStreak % 7 == 0) {
      if (currentHp < maxHp) {
        currentHpAfterBonus = currentHp + 1;
        await _progressService.saveUserHp(currentHpAfterBonus);
        onHpUpdate(currentHpAfterBonus);
        hpBonusEarnedThisCheck = true;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppText.enText['streak_reward_hp']!} $currentStreak ${AppText.enText['streak_reward_hp_suffix']!}',
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppText.enText['streak_reward_full_hp']!} $currentStreak ${AppText.enText['streak_reward_full_hp_suffix']!}',
              ),
            ),
          );
        }
      }
    }

    return {
      'hpBonusEarned': hpBonusEarnedThisCheck,
      'currentHpAfterBonus': currentHpAfterBonus,
      'finalCurrentStreak': currentStreak,
    };
  }

  Future<Map<String, dynamic>> updateCalendarAndStreak(
    Function(int) onHpUpdate,
    BuildContext context,
  ) async {
    final result = await checkLoginStreak(onHpUpdate, context);
    return result;
  }

  int _getDayOfYear(DateTime date) {
    return date.difference(DateTime(date.year, 1, 1)).inDays + 1;
  }

  DateTime getStreakStartDate(
    int currentStreak,
    int lastLoginDayOfYear,
    int lastLoginYear,
  ) {
    if (currentStreak == 0) {
      return DateTime.now().add(const Duration(days: 1));
    }

    DateTime lastLoginDate;
    try {
      lastLoginDate = DateTime(
        lastLoginYear,
        1,
        1,
      ).add(Duration(days: lastLoginDayOfYear - 1));
    } catch (e) {
      debugPrint(
        "Error reconstructing lastLoginDate: $e. Using DateTime.now() as fallback.",
      );
      lastLoginDate = DateTime.now();
    }

    return lastLoginDate.subtract(Duration(days: currentStreak - 1));
  }

  Future<void> resetProgress(
    BuildContext context,
    Function(int) onHpUpdate,
  ) async {
    final uid = _currentUserUid;
    if (uid == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tidak ada pengguna yang login untuk mereset progres.',
            ),
          ),
        );
      }
      return;
    }

    await _firestore.collection('users').doc(uid).update({
      'unlockedLesson': 0,
      'completedChapters': [],
      'completedLessons': [],
      'userHp': maxHp,
      'currentStreak': 0,
      'loginDays': [],
      'lastLoginDay': 0,
      'lastLoginYear': 0,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final purchasesSnapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('purchases')
            .get();
    for (QueryDocumentSnapshot doc in purchasesSnapshot.docs) {
      await doc.reference.delete();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('unlocked_lesson');
    await prefs.remove('completed_chapters');
    await prefs.remove('user_hp');
    await prefs.remove('login_days');
    await prefs.remove('current_streak');
    await prefs.remove('last_login_day');
    await prefs.remove('last_login_year');
    await prefs.remove('purchase_history');

    onHpUpdate(maxHp);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppText.enText['progress_reset_success']!)),
      );
    }
  }
}
