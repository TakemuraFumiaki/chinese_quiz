import 'package:flutter/material.dart';
import 'history_manager.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    List<Map<String, dynamic>> data = await HistoryManager.loadHistory();
    setState(() {
      history = data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("履歴")),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("スコア: ${history[index]['score']} / 10"),
            subtitle: Text("日時: ${history[index]['date']}"),
          );
        },
      ),
    );
  }
}
