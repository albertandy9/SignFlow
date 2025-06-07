import 'package:flutter/material.dart';
import 'package:signflow/model/unit_model.dart';
import 'package:signflow/components/lesson/unit_title.dart';
import 'package:signflow/components/lesson/lesson_loader.dart';
import 'package:signflow/screens/purchase_hp_page.dart'; 
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/services/progress_service.dart';

class Homepage extends StatefulWidget {
  final int currentHp;
  final Function(int)? onHpUpdate;

  const Homepage({super.key, required this.currentHp, this.onHpUpdate});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  late Future<List<Unit>> futureUnits;
  Set<String> completedChapters = {};
  int unlockedLesson = 0;
  final int maxHp = 3;
  final ProgressService _progressService = ProgressService();

  @override
  void initState() {
    super.initState();
    futureUnits = loadUnitsFromAssets();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final progressData = await _progressService.loadProgress(maxHp);
    setState(() {
      unlockedLesson = progressData['unlockedLesson'];
      completedChapters = progressData['completedChapters'];
    });

    widget.onHpUpdate?.call(progressData['userHp']);
  }

  Future<bool?> showHpStatusDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.favorite,
                color: AppColors.hpIconColor,
                size: 30,
              ),
              const SizedBox(width: 10),
              Text(AppText.enText['hp_status_title']!),
            ],
          ),
          content: Text(
            '${AppText.enText['hp_current_status']!} ${widget.currentHp}/$maxHp',
          ),
          actions: [
            TextButton(
              onPressed:
                  widget.currentHp == maxHp
                      ? null
                      : () async {
                        final purchaseResult = await _navigateToPurchaseHp(
                          context,
                        );
                        if (purchaseResult == true) {
                          if (mounted)
                            Navigator.of(
                              context,
                            ).pop(true); 
                        } else {
                          if (mounted)
                            Navigator.of(
                              context,
                            ).pop(false); 
                        }
                      },
              style: TextButton.styleFrom(
                backgroundColor:
                    widget.currentHp == maxHp
                        ? AppColors.restoreHpButtonDisabled
                        : AppColors.restoreHpButton,
                foregroundColor: AppColors.textOnPrimary,
              ),
              child: Text(AppText.enText['restore_hp_button']!),
            ),
            TextButton(
              onPressed:
                  () => Navigator.of(
                    context,
                  ).pop(false), 
              child: Text(AppText.enText['close_button']!),
            ),
          ],
        );
      },
    );
    return result; 
  }

  Future<bool?> _navigateToPurchaseHp(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PurchaseHpPage(
              currentHp: widget.currentHp,
              onHpUpdate: widget.onHpUpdate,
              maxHp: maxHp,
            ),
      ),
    );

    if (result == true) {
      _showSnackBar(AppText.enText['hp_restore_success']!);
      return true; 
    }
    return false; 
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.successColor),
    );
  }

  bool isUnitLocked(int unit, List<Unit> allUnits) {
    if (unit == 1) return false;

    final previousUnit = allUnits.firstWhere((u) => u.number == unit - 1);
    for (var chapter in previousUnit.chapters) {
      final chapterKey = '${previousUnit.number}-${chapter.number}';
      if (!completedChapters.contains(chapterKey)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
      ),
      child: FutureBuilder<List<Unit>>(
        future: futureUnits,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final units = snapshot.data ?? [];

          return ListView(
            children:
                units.map((unit) {
                  return UnitTitle(
                    unit.title,
                    unit.number,
                    unit.chapters.map((chapter) {
                      return {
                        'chapter': chapter.number,
                        'title': chapter.title,
                      };
                    }).toList(),
                    Icons.book,
                    isLocked: isUnitLocked(unit.number, units),
                    completedChapters: completedChapters,
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
