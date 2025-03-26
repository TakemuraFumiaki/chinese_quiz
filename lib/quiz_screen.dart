import 'package:flutter/material.dart';
import 'result_screen.dart';

final List<Map<String, dynamic>> questions = [
  {
    "question": "你好 のピン音は？",
    "correct": "nǐ hǎo",
    "options": ["nǐ hǎo", "nǐ hā", "nǐ hòu", "nī hǎo"],
    "meaning": "こんにちは",
    "example": "你好！你好吗？(こんにちは！お元気ですか？)"
  },
  {
    "question": "谢谢 のピン音は？",
    "correct": "xièxiè",
    "options": ["xièxiè", "xiāxiā", "xièxiā", "xiěxiě"],
    "meaning": "ありがとう",
    "example": "谢谢你！（ありがとう！）"
  },
];

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int correctCount = 0;
  int streakCount = 0;
  String? selectedAnswer;
  bool showEffect = false;
  late AnimationController _controller;
  String? resultIcon;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void checkAnswer(String answer) async {
    setState(() {
      selectedAnswer = answer;
      if (answer == questions[currentQuestionIndex]["correct"]) {
        correctCount++;
        streakCount++;
        resultIcon = "⭕";  // ◯を正解として設定
        showEffect = true;
        _controller.forward(from: 0.0);
      } else {
        streakCount = 0;
        resultIcon = "❌";  // ❌を不正解として設定
        showEffect = true;
        _controller.forward(from: 0.0);
      }
    });

    // 1秒後にエフェクトを消す
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      showEffect = false;
    });

    // 解説画面に遷移
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExplanationScreen(
          question: questions[currentQuestionIndex],
          userAnswer: selectedAnswer,  // ユーザーの回答を渡す
          resultIcon: resultIcon,
          onNext: nextQuestion, // 次の問題に進むためのコールバック
        ),
      ),
    );
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedAnswer = null;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(correctCount: correctCount),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var question = questions[currentQuestionIndex];
    List<String> shuffledOptions = List.from(question["options"]);
    shuffledOptions.shuffle();

    return Scaffold(
      appBar: AppBar(title: Text("クイズ")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("問題 ${currentQuestionIndex + 1} / ${questions.length}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Text(question["question"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Column(
                  children: shuffledOptions.map<Widget>((option) {
                    bool isSelected = selectedAnswer == option;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ElevatedButton(
                        onPressed: selectedAnswer == null ? () => checkAnswer(option) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? (option == question["correct"] ? Colors.green : Colors.red)
                              : Colors.yellow[100],  // 背景色を薄い黄色に変更
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(option, style: TextStyle(fontSize: 18)),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                // 次へボタンは削除
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExplanationScreen(
                          question: questions[currentQuestionIndex],
                          resultIcon: resultIcon,
                          userAnswer: selectedAnswer, // ユーザーの回答を渡す
                          onNext: nextQuestion, // 次の問題に進むためのコールバック
                        ),
                      ),
                    );
                  },
                  child: Text("解説"),
                ),
              ],
            ),
          ),
          if (showEffect)
            Center(
              child: ScaleTransition(
                scale: _controller,
                child: Icon(
                  resultIcon == "⭕" ? Icons.check_circle : Icons.cancel,
                  size: 100,
                  color: resultIcon == "⭕" ? Colors.green : Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 解説画面
class ExplanationScreen extends StatelessWidget {
  final Map<String, dynamic> question;
  final String? resultIcon;
  final String? userAnswer;  // ユーザーの回答
  final VoidCallback onNext; // 次の問題に進むためのコールバック

  ExplanationScreen({required this.question, required this.resultIcon, required this.userAnswer, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('解説')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,  // 左寄せに変更
            children: [
              Text('質問: ${question["question"]}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Text('あなたの回答: ${userAnswer ?? "未回答"}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text('正解: ${question["correct"]}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text('意味: ${question["meaning"]}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text('例文: ${question["example"]}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 問題画面に戻る
                },
                child: Text('問題画面に戻る'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  onNext(); // 次の問題に進む
                  Navigator.pop(context); // 解説画面を閉じて問題画面に戻る
                },
                child: Text('次の問題'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
