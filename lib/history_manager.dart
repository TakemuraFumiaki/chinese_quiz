import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'history_manager.dart'; // これを追加


class HistoryManager {
  static const String historyKey = "quiz_history";

  static Future<void> saveResult(int correctCount) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(historyKey) ?? [];
    
    String result = jsonEncode({
      "date": DateTime.now().toString(),
      "score": correctCount,
    });

    history.add(result);
    await prefs.setStringList(historyKey, history);
  }

  // static Future<List<Map<String, dynamic>>> loadHistory() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<String> history = prefs.getStringList(historyKey) ?? [];
    
  //   return history.map((item) => jsonDecode(item)).toList();
  // }

    static Future<List<Map<String, dynamic>>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(historyKey) ?? [];

    return history.map((item) => Map<String, dynamic>.from(jsonDecode(item))).toList();
  }
}
