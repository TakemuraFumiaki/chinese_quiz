import 'package:flutter/material.dart';
import 'home_screen.dart';

//フラッターアプリのエントリーポインこれは Flutterアプリのエントリーポイント です。
//runApp(MyApp()) によって、MyApp というウィジェットがアプリ全体として表示されます。

void main() {
  runApp(MyApp());
}

//MaterialApp は、Flutterの基本的なUIフレームワーク（ボタンやナビゲーションバーなど）を提供するクラスです。
//home: HomeScreen(), で、アプリの最初の画面を HomeScreen に指定しています。

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '中国語の友',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
