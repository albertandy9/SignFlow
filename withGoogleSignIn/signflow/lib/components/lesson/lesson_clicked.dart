import 'package:flutter/material.dart';
import 'package:signflow/screens/lessons_page.dart';
import 'package:signflow/components/lesson/lessons_video.dart';
import 'package:signflow/model/unit_model.dart';
import 'package:signflow/style/app_color.dart';
import 'package:flutter/services.dart';
import 'package:signflow/style/text.dart'; 
import 'package:signflow/components/lesson/lesson_question.dart'; 

class Lessonclicked extends StatelessWidget {
  const Lessonclicked({
    super.key,
    required this.lesson,
    required this.unit,
    required this.chapter,
    required this.lessonIndex,
    this.onHpUpdate,
  });

  final Lesson lesson;
  final int unit;
  final int chapter;
  final int lessonIndex;
  final Function(int)? onHpUpdate;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.surface,
        systemNavigationBarColor: AppColors.surface,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      // Back to lesson page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Lessons(
                                unit: unit,
                                chapter: chapter,
                                temp: 0,
                                onHpUpdate: onHpUpdate,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(right: 20),
                      backgroundColor: AppColors.transparent,
                      shadowColor: AppColors.transparent,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: AppColors.icon,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    AppText.enText['learn_new_sign']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      height: 0.1,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  child: LessonVideoPlayer(videoPath: lesson.videoPath),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      side: const BorderSide(
                        color: AppColors.lessonButtonBorder,
                        width: 2,
                      ),
                      backgroundColor: AppColors.transparent,
                      shadowColor: AppColors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      lesson.title,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  margin: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Lessonquestion(
                                lesson: lesson,
                                unit: unit,
                                chapter: chapter,
                                lessonIndex: lessonIndex,
                                onHpUpdate: onHpUpdate,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      backgroundColor: AppColors.unitLabelBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      AppText.enText['continue_button']!,
                      style: const TextStyle(color: AppColors.textOnPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
