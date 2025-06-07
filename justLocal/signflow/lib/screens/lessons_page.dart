import 'package:flutter/material.dart';
import 'package:signflow/main_layout.dart';
import 'package:signflow/components/lesson/lesson_title.dart';
import 'package:signflow/model/unit_model.dart';
import 'package:signflow/components/lesson/lesson_loader.dart';
import 'package:signflow/style/app_color.dart';
import 'package:flutter/services.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/services/progress_service.dart';

class Lessons extends StatefulWidget {
  const Lessons({
    super.key,
    required this.unit,
    required this.chapter,
    required this.temp,
    this.onChapterComplete,
    this.onHpUpdate,
  });

  final int unit;
  final int chapter;
  final int temp;
  final Function(String)? onChapterComplete;
  final Function(int)? onHpUpdate;

  @override
  State<Lessons> createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  List<Unit> allUnits = [];
  List<Lesson> currentLessons = [];
  String chapterTitle = '';
  Set<String> completedLessons = {};
  bool chapterCompleted = false;
  final ProgressService _progressService = ProgressService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final units = await loadUnitsFromAssets();
    final progressData = await _progressService.loadProgress(3);

    if (mounted) {
      setState(() {
        allUnits = units;
        completedLessons = progressData['completedLessons'];

        final currentUnit = units.firstWhere((u) => u.number == widget.unit);
        final currentChapter = currentUnit.chapters.firstWhere(
          (c) => c.number == widget.chapter,
        );
        currentLessons = currentChapter.lessons;
        chapterTitle = currentChapter.title;

        _checkChapterCompletion();
      });
    }
  }

  Future<void> onLessonComplete(int lessonIndex) async {
    await _progressService.saveLessonProgress(
      widget.unit,
      widget.chapter,
      lessonIndex,
    );
    await loadData(); 
  }

  void _checkChapterCompletion() async {
    bool allLessonsCompleted = await _progressService.checkIsChapterCompleted(
      widget.unit,
      widget.chapter,
      currentLessons,
    );

    if (allLessonsCompleted && !chapterCompleted) {
      if (mounted) {
        setState(() {
          chapterCompleted = true;
        });
      }

      await _progressService.markChapterCompleted(widget.unit, widget.chapter);

      final chapterKey = '${widget.unit}-${widget.chapter}';
      widget.onChapterComplete?.call(chapterKey);

      _showChapterCompletedDialog();
    }
  }

  void _showChapterCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: AppColors.trophyColor,
                size: 30,
              ),
              const SizedBox(width: 10),
              Text(AppText.enText['chapter_completed_title']!),
            ],
          ),
          content: Text(
            '${AppText.enText['chapter_completed_congratulations']!}$chapterTitle${AppText.enText['chapter_completed_trophy']!}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLayout()),
                  (route) => false,
                );
              },
              child: Text(AppText.enText['great_button']!),
            ),
          ],
        );
      },
    );
  }

  Future<bool> isLessonUnlocked(int lessonIndex) async {
    return await _progressService.isLessonUnlocked(
      widget.unit,
      widget.chapter,
      lessonIndex,
      allUnits,
    );
  }

  bool isLessonCompleted(int lessonIndex) {
    final lessonKey = '${widget.unit}-${widget.chapter}-$lessonIndex';
    return completedLessons.contains(lessonKey);
  }

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

    if (allUnits.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 10),
              Text(AppText.enText['loading_lessons']!),
            ],
          ),
        ),
      );
    }

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
          child: Column(
            children: [
              // Header
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.headerColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainLayout(),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.transparent,
                              shadowColor: AppColors.transparent,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: AppColors.icon,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.chipColor,
                            ),
                            child: Text(
                              'UNIT ${widget.unit} - ${AppText.enText['chapter_label_prefix']!.trim()}${widget.chapter}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 5),
                        child: Text(
                          chapterTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        "${AppText.enText['learn_new_sign']!} ${currentLessons.length}${AppText.enText['lessons_in_chapter']!}",
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Lesson list
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: List.generate(currentLessons.length, (i) {
                    final lesson = currentLessons[i];
                    final isCompleted = isLessonCompleted(i);

                    return FutureBuilder<bool>(
                      future: isLessonUnlocked(i),
                      builder: (context, snapshot) {
                        final isUnlocked = snapshot.data ?? false;

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: isUnlocked ? 1.0 : 0.4,
                              child: Lessontitle(
                                lessons: i + 1,
                                title: lesson.title,
                                lesson: lesson,
                                unit: widget.unit,
                                chapter: widget.chapter,
                                lessonIndex: i,
                                isUnlocked: isUnlocked,
                                isCompleted: isCompleted,
                                onLessonComplete: () => onLessonComplete(i),
                                onHpUpdate: widget.onHpUpdate,
                              ),
                            ),
                            if (!isUnlocked)
                              const Positioned(
                                child: Icon(
                                  Icons.lock,
                                  color: AppColors.shadow,
                                  size: 40,
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
