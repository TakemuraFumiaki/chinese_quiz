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
  {
    "question": "早上好 のピン音は？",
    "correct": "zǎo shàng hǎo",
    "options": ["zǎo shàng hǎo", "zào shàng hǎo", "zǎo xià hǎo", "zào xià hǎo"],
    "meaning": "おはよう",
    "example": "早上好！你今天怎么样？(おはよう！今日はどうですか？)"
  },
  {
    "question": "再见 のピン音は？",
    "correct": "zàijiàn",
    "options": ["zàijiàn", "zài jiàn", "zài jiān", "zàī jiàn"],
    "meaning": "さようなら",
    "example": "再见！下次见！(さようなら！また会いましょう！)"
  },
  {
    "question": "请问 のピン音は？",
    "correct": "qǐng wèn",
    "options": ["qǐng wèn", "qīn wèn", "qǐng wēn", "qīng wèn"],
    "meaning": "すみません、質問があります",
    "example": "请问，最近如何？(すみません、最近どうですか？)"
  },
  {
    "question": "对不起 のピン音は？",
    "correct": "duìbuqǐ",
    "options": ["duìbuqǐ", "duī bù qǐ", "duì bù qí", "duì bù qī"],
    "meaning": "ごめんなさい",
    "example": "对不起，我迟到了。(ごめんなさい、遅れました。)"
  },
  {
    "question": "我很好 のピン音は？",
    "correct": "wǒ hěn hǎo",
    "options": ["wǒ hěn hǎo", "wǒ hèn hǎo", "wǒ hěn hāo", "wǒ hěn hāo"],
    "meaning": "私は元気です",
    "example": "我很好，谢谢！(私は元気です、ありがとう！)"
  },
  {
    "question": "你吃了吗？ のピン音は？",
    "correct": "nǐ chī le ma",
    "options": ["nǐ chī le ma", "nī chī le ma", "nǐ chī mǎ", "nǐ chí le ma"],
    "meaning": "ご飯を食べましたか？",
    "example": "你吃了吗？我刚刚吃完。(ご飯を食べましたか？私は今食べ終わりました。)"
  },
  {
    "question": "我爱你 のピン音は？",
    "correct": "wǒ ài nǐ",
    "options": ["wǒ ài nǐ", "wǒ āi nǐ", "wǒ ài nī", "wǒ ài nī"],
    "meaning": "愛してる",
    "example": "我爱你，一生一世。(私はあなたを愛しています、一生涯。)"
  },
  {
    "question": "妈妈 のピン音は？",
    "correct": "māmā",
    "options": ["māmā", "màma", "māma", "mámā"],
    "meaning": "お母さん",
    "example": "妈妈，我爱你！(お母さん、私はあなたを愛しています！)"
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



class ExplanationScreen extends StatelessWidget {
  final Map<String, dynamic> question;
  final String? resultIcon;
  final String? userAnswer;  // ユーザーの回答
  final VoidCallback onNext; // 次の問題に進むためのコールバック
  final int correctCount; // correctCount を追加
  final bool isLastQuestion; // 最後の問題かどうかを判定するフラグ

  ExplanationScreen({
    required this.question,
    required this.resultIcon,
    required this.userAnswer,
    required this.onNext,
    required this.correctCount, // 必須の引数として追加
    required this.isLastQuestion, // 最後の問題かどうか
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('解説')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              // 最後の問題の場合
              if (isLastQuestion)
                ElevatedButton(
                  onPressed: () {
                    // 結果を確認するボタンでResultScreenに遷移
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(correctCount: correctCount),
                      ),
                    );
                  },
                  child: Text('結果を確認する'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


