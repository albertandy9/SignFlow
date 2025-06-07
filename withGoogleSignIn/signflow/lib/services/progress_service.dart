import 'package:flutter/foundation.dart';
import 'package:signflow/model/unit_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:signflow/model/purchase_history.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressService {
  static const _purchaseHistoryKey = 'purchase_history';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? get _currentUserUid => _firebaseAuth.currentUser?.uid;

  Future<Map<String, dynamic>> loadProgress(int maxHp) async {
    final uid = _currentUserUid;
    if (uid == null) {
      return {
        'unlockedLesson': 0,
        'completedChapters': <String>{},
        'completedLessons': <String>{},
        'userHp': maxHp,
      };
    }

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return {
          'unlockedLesson': data['unlockedLesson'] as int? ?? 0,
          'completedChapters': Set<String>.from(
            data['completedChapters'] as List? ?? [],
          ),
          'completedLessons': Set<String>.from(
            data['completedLessons'] as List? ?? [],
          ),
          'userHp': data['userHp'] as int? ?? maxHp,
        };
      } else {
        await _firestore.collection('users').doc(uid).set({
          'unlockedLesson': 0,
          'completedChapters': [],
          'completedLessons': [],
          'userHp': maxHp,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        return {
          'unlockedLesson': 0,
          'completedChapters': <String>{},
          'completedLessons': <String>{},
          'userHp': maxHp,
        };
      }
    } catch (e) {
      debugPrint('Error loading progress from Firestore: $e');
      return {
        'unlockedLesson': 0,
        'completedChapters': <String>{},
        'completedLessons': <String>{},
        'userHp': maxHp,
      };
    }
  }

  Future<void> saveUnlockedLesson(int level) async {
    final uid = _currentUserUid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      'unlockedLesson': level,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveCompletedChapters(Set<String> completedChapters) async {
    final uid = _currentUserUid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      'completedChapters': completedChapters.toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveCompletedLessons(Set<String> completedLessons) async {
    final uid = _currentUserUid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      'completedLessons': completedLessons.toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveUserHp(int hp) async {
    final uid = _currentUserUid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).update({
      'userHp': hp,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<int> getCurrentUserHp(int maxHp) async {
    final uid = _currentUserUid;
    if (uid == null) return maxHp;
    final doc = await _firestore.collection('users').doc(uid).get();
    return (doc.data()?['userHp'] as int?) ?? maxHp;
  }

  Future<void> decreaseHp(int maxHp) async {
    final uid = _currentUserUid;
    if (uid == null) return;
    int currentHp = await getCurrentUserHp(maxHp);
    if (currentHp > 0) {
      currentHp--;
      await saveUserHp(currentHp);
    }
  }

  int calculateGlobalLessonIndex(
    int unitNumber,
    int chapterNumber,
    int lessonIndex,
    List<Unit> allUnits,
  ) {
    int globalIndex = 0;

    for (var unit in allUnits) {
      if (unit.number < unitNumber) {
        for (var chapter in unit.chapters) {
          globalIndex += chapter.lessons.length;
        }
      } else if (unit.number == unitNumber) {
        for (var chapter in unit.chapters) {
          if (chapter.number < chapterNumber) {
            globalIndex += chapter.lessons.length;
          } else if (chapter.number == chapterNumber) {
            globalIndex += lessonIndex;
            break;
          }
        }
        break;
      }
    }
    return globalIndex;
  }

  Future<bool> isLessonUnlocked(
    int unitNumber,
    int chapterNumber,
    int lessonIndex,
    List<Unit> allUnits,
  ) async {
    final uid = _currentUserUid;
    if (uid == null) return false; 

    final doc = await _firestore.collection('users').doc(uid).get();
    final unlockedLesson = doc.data()?['unlockedLesson'] as int? ?? 0;
    final globalIndex = calculateGlobalLessonIndex(
      unitNumber,
      chapterNumber,
      lessonIndex,
      allUnits,
    );
    return globalIndex <= unlockedLesson;
  }

  Future<bool> checkIsChapterCompleted(
    int unitNumber,
    int chapterNumber,
    List<Lesson> lessonsInChapter,
  ) async {
    final uid = _currentUserUid;
    if (uid == null) return false;

    final doc = await _firestore.collection('users').doc(uid).get();
    final completedLessonsList = Set<String>.from(
      doc.data()?['completedLessons'] as List? ?? [],
    );

    bool allLessonsCompleted = true;
    for (int i = 0; i < lessonsInChapter.length; i++) {
      final lessonKey = '$unitNumber-$chapterNumber-$i';
      if (!completedLessonsList.contains(lessonKey)) {
        allLessonsCompleted = false;
        break;
      }
    }
    return allLessonsCompleted;
  }

  Future<void> saveLessonProgress(
    int unit,
    int chapter,
    int lessonIndex,
  ) async {
    final uid = _currentUserUid;
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data();
    Set<String> completedLessons = Set<String>.from(
      data?['completedLessons'] as List? ?? [],
    );
    int currentUnlockedLesson =
        data?['unlockedLesson'] as int? ?? 0; 

    final lessonKey = '$unit-$chapter-$lessonIndex';
    if (!completedLessons.contains(lessonKey)) {
      completedLessons.add(lessonKey);
      await saveCompletedLessons(completedLessons);
    }

    await _firestore.collection('users').doc(uid).update({
      'unlockedLesson': currentUnlockedLesson + 1, 
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markChapterCompleted(int unit, int chapter) async {
    final uid = _currentUserUid;
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    Set<String> completedChapters = Set<String>.from(
      doc.data()?['completedChapters'] as List? ?? [],
    );
    final chapterKey = '$unit-$chapter';

    if (!completedChapters.contains(chapterKey)) {
      completedChapters.add(chapterKey);
      await saveCompletedChapters(completedChapters);
    }
  }

  Future<void> savePurchase(String productName, String type) async {
    final uid = _currentUserUid;
    if (uid == null) {
      debugPrint('Error: User not logged in when trying to save purchase.');
      return;
    }

    try {
      await _firestore.collection('users').doc(uid).collection('purchases').add(
        {
          'productName': productName,
          'type': type,
          'createdAt':
              FieldValue.serverTimestamp(),
        },
      );
      debugPrint(
        'SUCCESS: Purchase saved to Firestore for user $uid: $productName',
      );
    } catch (e) {
      debugPrint('FAILED: Error saving purchase to Firestore: $e');
    }
  }

  Future<List<PurchaseHistoryItem>> loadPurchaseHistory() async {
    final uid = _currentUserUid;
    if (uid == null) {
      debugPrint('No user logged in to load purchase history.');
      return [];
    }

    try {
      final querySnapshot =
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('purchases')
              .orderBy(
                'createdAt',
                descending: true,
              ) 
              .get();

      List<PurchaseHistoryItem> historyList =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            debugPrint('Raw purchase data from Firestore: $data'); 
            return PurchaseHistoryItem.fromJson(data);
          }).toList();

      debugPrint('Loaded ${historyList.length} purchase items from Firestore.');
      return historyList;
    } catch (e) {
      debugPrint('Error loading purchase history from Firestore: $e');
      return [];
    }
  }

  Future<void> purchaseHp(
    int currentHp,
    int maxHp,
    int hpToRestore,
    Function(int)? onHpUpdate,
  ) async {
    final uid = _currentUserUid;
    if (uid == null) return;

    int newHp = currentHp + hpToRestore;
    if (newHp > maxHp) {
      newHp = maxHp;
    }

    await saveUserHp(newHp);
    onHpUpdate?.call(newHp);

    await savePurchase('HP +$hpToRestore', 'HP');
  }
}
