import 'package:flutter/material.dart';
import 'package:signflow/screens/lessons_page.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/style/text.dart'; 
import 'package:signflow/services/progress_service.dart'; 

class ChapterTitle extends StatelessWidget {
  final int unit;
  final int chapter;
  final String title;
  final bool completed;
  final bool locked;
  final Function(String)? onChapterComplete; 

  ChapterTitle({
    Key? key,
    required this.unit,
    required this.chapter,
    required this.title,
    required this.completed,
    required this.locked,
    this.onChapterComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: locked ? 0.4 : 1.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.chapterCardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed:
                  locked
                      ? null
                      : () async {
                        final progressService = ProgressService();
                        final progressData = await progressService.loadProgress(
                          3,
                        );
                        final unlockedLesson =
                            progressData['unlockedLesson'] as int;

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => Lessons(
                                  unit: unit,
                                  chapter: chapter,
                                  temp: 0,
                                  onChapterComplete:
                                      onChapterComplete, // 
                                ),
                            settings: RouteSettings(
                              arguments: {'unlockedLesson': unlockedLesson},
                            ),
                          ),
                        );
                      },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.chapterLabelBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${AppText.enText['chapter_label_prefix']!}$chapter',
                            style: AppTextStyles.chapterLabel,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(title, style: AppTextStyles.chapterTitle),
                        const SizedBox(height: 4),
                        if (completed)
                          Row(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                color: AppColors.trophyColor,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppText.enText['chapter_completed_text']!,
                                style: AppTextStyles.completedText,
                              ),
                            ],
                          ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            completed
                                ? AppColors.successColor
                                : AppColors.playButton,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        completed ? Icons.check : Icons.play_arrow,
                        color: AppColors.textOnPrimary,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (locked) const Icon(Icons.lock, color: AppColors.shadow, size: 40),
        ],
      ),
    );
  }
} 
