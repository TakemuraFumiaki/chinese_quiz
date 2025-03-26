import 'package:flutter/material.dart';
import 'history_manager.dart'; // HistoryManager をインポート
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int correctCount;

  ResultScreen({required this.correctCount});

  @override
  Widget build(BuildContext context) {
    int score = correctCount * 10; // 10点 × 正解数

    // テスト結果を保存
    HistoryManager.saveResult(correctCount);

    return Scaffold(
      appBar: AppBar(title: Text("結果")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("テスト終了！", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text("正解数: $correctCount / 10", style: TextStyle(fontSize: 20)),
            Text("スコア: $score 点", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text("ホームへ戻る"),
            ),
          ],
        ),
      ),
    );
  }
}
