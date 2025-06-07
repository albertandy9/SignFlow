import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:signflow/model/unit_model.dart';
import 'package:signflow/services/lesson_question_service.dart'; 

Future<List<Unit>> loadUnitsFromAssets() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  final lessonPaths =
      manifestMap.keys
          .where(
            (path) =>
                path.startsWith('assets/lessons/') && path.endsWith('.mp4'),
          )
          .toList();

  Map<String, Map<String, List<String>>> unitChapterMap = {};

  for (var path in lessonPaths) {
    final parts = path.split('/');
    if (parts.length >= 5) {
      final unitName = parts[2]; // e.g., unit1
      final chapterName = parts[3]; // e.g., feelings

      unitChapterMap.putIfAbsent(unitName, () => {});
      unitChapterMap[unitName]!.putIfAbsent(chapterName, () => []);
      unitChapterMap[unitName]![chapterName]!.add(path);
    }
  }

  List<Unit> units = [];
  final LessonQuestionService questionService =
      LessonQuestionService(); // Instantiate here

  final sortedUnits =
      unitChapterMap.keys.toList()..sort((a, b) {
        final numA = int.parse(a.replaceAll('unit', ''));
        final numB = int.parse(b.replaceAll('unit', ''));
        return numA.compareTo(numB);
      });

  for (var unitKey in sortedUnits) {
    final unitNumber = int.parse(unitKey.replaceAll('unit', ''));
    final chapterMap = unitChapterMap[unitKey]!;

    List<Chapter> chapters = [];
    int chapterIndex = 1;

    final sortedChapters = chapterMap.keys.toList()..sort();

    for (var chapterName in sortedChapters) {
      final lessonPaths = chapterMap[chapterName]!;
      lessonPaths.sort();

      List<Lesson> lessons = [];

      for (var lessonPath in lessonPaths) {
        final lessonTitle = _extractLessonTitle(lessonPath);
        final questions = questionService.generateQuestions(
          lessonTitle,
          chapterName,
        ); 

        lessons.add(
          Lesson(
            title: lessonTitle,
            videoPath: lessonPath,
            questions: questions,
          ),
        );
      }

      chapters.add(
        Chapter(
          number: chapterIndex++,
          title: _formatChapterTitle(chapterName),
          lessons: lessons,
        ),
      );
    }

    units.add(
      Unit(number: unitNumber, title: "Unit $unitNumber", chapters: chapters),
    );
  }

  return units;
}

String _extractLessonTitle(String path) {
  final fileName = path.split('/').last.split('.').first;
  return fileName
      .replaceAll('_', ' ')
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

String _formatChapterTitle(String chapterName) {
  return chapterName[0].toUpperCase() + chapterName.substring(1);
}
