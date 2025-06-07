class Lessonsstructure {
  final int unit;
  final int chapter;
  final int lesson;
  final String lessonTitle;
  final List<String> listQuestion;
  final String videoPath;

  Lessonsstructure({
    required this.unit,
    required this.chapter,
    required this.lesson,
    required this.lessonTitle,
    required this.listQuestion,
    required this.videoPath,
  });
}