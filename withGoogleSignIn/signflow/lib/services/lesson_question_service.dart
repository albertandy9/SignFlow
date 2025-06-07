import 'dart:math';

class LessonQuestionService {
  List<String> generateQuestions(String correctAnswer, String category) {
    final Map<String, List<String>> categoryQuestions = {
      'family': ['Father', 'Mother', 'Siblings', 'Brother', 'Sister'],
      'greetings': [
        'Hello',
        'Goodbye',
        'Nice to meet you',
        'Good morning',
        'Good night',
      ],
      'feelings': ['Happy', 'Sad', 'Hungry', 'Tired', 'Angry'],
      'food': ['Drink', 'Eat', 'Thank You', 'Please', 'Water'],
      'expressions': ['Yes', 'No', 'Welcome', 'Sorry', 'Excuse me'],
      'condition': ['How are you', 'I\'m fine', 'So so', 'Good', 'Bad'],
      'color': ['Purple', 'Red', 'Yellow', 'Blue', 'Green'],
      'interaction': ['Me', 'You', 'Help', 'Please', 'Thank you'],
      'animal': ['Cat', 'Dog', 'Bird', 'Fish', 'Horse'],
    };

    final questions =
        categoryQuestions[category] ?? ['Option 1', 'Option 2', 'Option 3'];
    final result = <String>[];

    result.add(correctAnswer);

    for (var question in questions) {
      if (question.toLowerCase() != correctAnswer.toLowerCase() &&
          result.length < 3) {
        result.add(question);
      }
    }

    while (result.length < 3) {
      String genericOption = 'Option ${result.length + 1}';
      if (!result.contains(genericOption)) {
        result.add(genericOption);
      } else {
        result.add('Another Option ${Random().nextInt(100)}');
      }
    }

    result.shuffle(Random());
    return result;
  }
}
