import 'package:flutter/material.dart';
import 'result_screen.dart';  // ResultScreenをインポート

class ExplanationScreen extends StatelessWidget {
  final Map<String, dynamic> question;
  final String? resultIcon;
  final String? userAnswer;
  final VoidCallback onNext;
  final int correctCount;
  final bool isLastQuestion;

  ExplanationScreen({
    required this.question,
    required this.resultIcon,
    required this.userAnswer,
    required this.onNext,
    required this.correctCount,
    required this.isLastQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('解説')),
      body: Padding(
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
            // 最後の問題の場合、「次の問題」ボタンを表示しない
            if (!isLastQuestion)
              ElevatedButton(
                onPressed: () {
                  onNext(); // 次の問題に進む
                  Navigator.pop(context); // 解説画面を閉じて問題画面に戻る
                },
                child: Text('次の問題'),
              ),
            // 最後の問題の場合、結果確認ボタンを表示
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
    );
  }
}
