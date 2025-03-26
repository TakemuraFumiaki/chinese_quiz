import 'dart:math';

class Question {
  final String chinese;
  final String pinyin;

  Question(this.chinese, this.pinyin);
}

class QuestionData {
  static final List<Question> _questions = [
    Question("你好", "nǐ hǎo"),
    Question("谢谢", "xiè xiè"),
    Question("再见", "zài jiàn"),
    Question("中国", "zhōng guó"),
    Question("日本", "rì běn"),
    Question("老师", "lǎo shī"),
    Question("学生", "xué shēng"),
    Question("天气", "tiān qì"),
    Question("朋友", "péng yǒu"),
    Question("工作", "gōng zuò"),
  ];

  static List<Question> getRandomQuestions(int count) {
    _questions.shuffle(Random());
    return _questions.take(count).toList();
  }
}
