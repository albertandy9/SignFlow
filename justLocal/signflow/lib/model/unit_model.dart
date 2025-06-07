class Lesson {
  final String title;
  final String videoPath;
  final List<String> questions;

  Lesson({
    required this.title,
    required this.videoPath,
    required this.questions,
  });
}

class Chapter {
  final int number;
  final String title;
  final List<Lesson> lessons;

  Chapter({required this.number, required this.title, required this.lessons});
}

class Unit {
  final int number;
  final String title;
  final List<Chapter> chapters;

  Unit({required this.number, required this.title, required this.chapters});
}
