import 'package:flutter/material.dart';
import 'package:signflow/components/lesson/lesson_clicked.dart';
import 'package:signflow/model/unit_model.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart';

class Lessontitle extends StatelessWidget {
  const Lessontitle({
    super.key,
    required this.lessons,
    required this.title,
    required this.lesson,
    required this.unit,
    required this.chapter,
    required this.lessonIndex,
    required this.isUnlocked,
    required this.isCompleted,
    required this.onLessonComplete,
    this.onHpUpdate,
  });

  final int lessons;
  final String title;
  final Lesson lesson;
  final int unit;
  final int chapter;
  final int lessonIndex;
  final bool isUnlocked;
  final bool isCompleted;
  final VoidCallback onLessonComplete;
  final Function(int)? onHpUpdate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            isUnlocked
                ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Lessonclicked(
                            lesson: lesson,
                            unit: unit,
                            chapter: chapter,
                            lessonIndex: lessonIndex,
                            onHpUpdate: onHpUpdate,
                          ),
                    ),
                  );
                }
                : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          backgroundColor:
              isUnlocked
                  ? AppColors.primary
                  : AppColors.restoreHpButtonDisabled, 
          side: BorderSide(
            color:
                isUnlocked
                    ? AppColors.lessonButtonBorder
                    : AppColors.shadow.withOpacity(0.4), 
            width: 2,
          ),
          shadowColor: AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isUnlocked
                        ? AppColors.surface
                        : AppColors.shadow.withOpacity(0.3), 
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.play_arrow,
                color:
                    isUnlocked
                        ? AppColors.lessonButtonBorder
                        : AppColors.shadow.withOpacity(0.4), 
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppText.enText['lesson_prefix']!}$lessons', 
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isUnlocked
                              ? AppColors.textPrimary
                              : AppColors.textSecondary, 
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          isUnlocked
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isCompleted)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.successColor,
                  size: 20,
                ),
              ),
            Icon(
              Icons.arrow_forward,
              color:
                  isUnlocked
                      ? AppColors.playButton
                      : AppColors.shadow.withOpacity(0.4), 
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
