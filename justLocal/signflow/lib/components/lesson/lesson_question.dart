import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signflow/components/lesson/lessons_video.dart';
import 'package:signflow/model/unit_model.dart';
import 'package:signflow/style/app_color.dart';
import 'package:signflow/main_layout.dart';
import 'package:signflow/screens/lessons_page.dart';
import 'package:signflow/style/text.dart';
import 'package:signflow/services/progress_service.dart';
import 'package:signflow/services/lesson_question_service.dart';
import 'package:signflow/components/lesson/lesson_loader.dart'; 

class Lessonquestion extends StatefulWidget {
  const Lessonquestion({
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
  State<Lessonquestion> createState() => _LessonquestionState();
}

class _LessonquestionState extends State<Lessonquestion> {
  String? answeredQuestion;
  late List<String> shuffledList;
  bool? isCorrect;
  List<Unit> allUnits =
      []; 
  List<Lesson> currentLessons = []; 
  int userHp = 3;
  final int maxHp = 3;

  final ProgressService _progressService = ProgressService();
  final LessonQuestionService _questionService = LessonQuestionService();

  @override
  void initState() {
    super.initState();
    _loadAllUnitsAndCurrentLessons();
    _loadUserHp(); 
  }

  String _getChapterCategory(int chapterNumber) {
    switch (chapterNumber) {
      case 1:
        return 'family';
      case 2:
        return 'greetings';
      case 3:
        return 'feelings';
      case 4:
        return 'food';
      case 5:
        return 'expressions';
      case 6:
        return 'condition';
      case 7:
        return 'color';
      case 8:
        return 'interaction';
      case 9:
        return 'animal';
      default:
        return 'general';
    }
  }

  Future<void> _loadUserHp() async {
    userHp = await _progressService.getCurrentUserHp(maxHp);
    if (mounted) {
      setState(() {}); 
    }
  }

  Future<void> _decreaseHp() async {
    await _progressService.decreaseHp(maxHp);
    final updatedHp = await _progressService.getCurrentUserHp(
      maxHp,
    ); 
    if (mounted) {
      setState(() {
        userHp = updatedHp;
      });
      widget.onHpUpdate?.call(updatedHp); 
    }
  }

  Future<void> _loadAllUnitsAndCurrentLessons() async {
    final units = await loadUnitsFromAssets();
    if (mounted) {
      setState(() {
        allUnits = units;
        final currentUnit = units.firstWhere((u) => u.number == widget.unit);
        currentLessons =
            currentUnit.chapters
                .firstWhere((c) => c.number == widget.chapter)
                .lessons;
        shuffledList = _questionService.generateQuestions(
          widget.lesson.title,
          _getChapterCategory(widget.chapter),
        );
      });
    }
  }

  void checkAnswer() async {
    final correctAnswer = widget.lesson.title.toLowerCase();
    final selectedAnswer = (answeredQuestion ?? "").toLowerCase();

    setState(() {
      isCorrect = selectedAnswer == correctAnswer;
    });

    if (!isCorrect!) {
      await _decreaseHp(); 
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text(
                isCorrect!
                    ? AppText.enText['correct_answer_dialog_title']!
                    : AppText.enText['wrong_answer_dialog_title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isCorrect!
                        ? AppText.enText['correct_answer_message']!
                        : AppText.enText['wrong_answer_message']!,
                  ),
                  if (!isCorrect!) 
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: AppColors.hpIconColor,
                            size: 28,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$userHp/$maxHp', 
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              actions: [
                if (isCorrect!)
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.correctButton,
                    ),
                    onPressed: () {
                      _handleCorrectAnswer();
                    },
                    child: Text(
                      AppText.enText['continue_button']!,
                      style: const TextStyle(color: AppColors.textOnPrimary),
                    ),
                  ),
                if (!isCorrect!)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); 
                      if (userHp <= 0) {
                        _showHpEmptyDialog();
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      AppText.enText['try_again_button']!,
                      style: const TextStyle(color: AppColors.textOnPrimary),
                    ),
                  ),
              ],
            ),
      );
    });
  }

  void _showHpEmptyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Row(
            children: [
              const Icon(
                Icons.favorite_border,
                color: AppColors.hpIconColor,
                size: 30,
              ),
              const SizedBox(width: 10),
              Text(AppText.enText['hp_empty_title']!),
            ],
          ),
          content: Text(AppText.enText['hp_empty_message']!),
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
              child: Text(AppText.enText['okay_button']!),
            ),
          ],
        );
      },
    );
  }

  void _handleCorrectAnswer() async {
    await _progressService.saveLessonProgress(
      widget.unit,
      widget.chapter,
      widget.lessonIndex,
    );
    if (!context.mounted) return;
    Navigator.pop(context); // Close dialog

    if (widget.lessonIndex == currentLessons.length - 1) {
      await _progressService.markChapterCompleted(widget.unit, widget.chapter);
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
          (route) => false,
        );
      }
    } else {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => Lessons(
                  unit: widget.unit,
                  chapter: widget.chapter,
                  temp: 0,
                  onHpUpdate: widget.onHpUpdate,
                ),
          ),
        );
      }
    }
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => Lessons(
                                unit: widget.unit,
                                chapter: widget.chapter,
                                temp: 0,
                                onHpUpdate: widget.onHpUpdate,
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
                    AppText.enText['answer_question_title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.5,
                      height: 0.1,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  width: double.infinity,
                  child: LessonVideoPlayer(videoPath: widget.lesson.videoPath),
                ),
                ...List.generate(shuffledList.length, (i) {
                  final option = shuffledList[i];
                  final isSelected = answeredQuestion == option;
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          answeredQuestion = option;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        side: const BorderSide(
                          color: AppColors.lessonButtonBorder,
                          width: 2,
                        ),
                        backgroundColor:
                            isSelected
                                ? AppColors.primary
                                : AppColors.optionBackground,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? AppColors.textOnPrimary
                                  : AppColors.optionText,
                        ),
                      ),
                    ),
                  );
                }),
                Container(
                  width: 100,
                  margin: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                    onPressed:
                        answeredQuestion == null || userHp <= 0
                            ? null
                            : checkAnswer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      backgroundColor: AppColors.submitButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      AppText.enText['submit_button']!,
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
