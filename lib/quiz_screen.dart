import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'question_data.dart';  // ここでquestion_data.dartをインポート
import 'explanation_screen.dart';  // ExplanationScreenをインポート

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
                if (selectedAnswer != null) 
                  ElevatedButton(
                    onPressed: selectedAnswer != null ? () {
                      // 解説を見るボタンが押されたときにアニメーションを消す
                      setState(() {
                        showEffect = false;  // アニメーションを非表示に設定
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
                            correctCount: correctCount, // correctCount を渡す
                            isLastQuestion: currentQuestionIndex == questions.length - 1, // 最後の問題かどうか
                          ),
                        ),
                      ).then((_) {
                        // 解説画面から戻った後にアニメーションを消す
                        setState(() {
                          showEffect = false;
                        });
                      });
                    } : null,
                    child: Text("解説を見る"),
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
