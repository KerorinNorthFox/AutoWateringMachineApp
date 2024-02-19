import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:souzouseisaku/Utils/utils.dart';
import 'package:souzouseisaku/Screens/login_screen.dart';
import 'package:souzouseisaku/Screens/home_screen.dart';


bool isTest = false;
bool isDelete = false;


// 起点
void main() async {
  await dotenv.load(fileName: '.env'); // 環境変数のファイル読み込み

  if (isDelete){
    deleteStorage(isAll: true);
  } else if (isTest){
    test();
  } else {
    final data = await readStorage();
    runApp(MyApp(data: data));
  }
}


// テストしたいコードを書く
void test() async {
  final uri = Uri.https(dotenv.get("URL"), "/api/auth");
  dynamic resJson;
  // try{
    await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': "m20nakatani1m@tokuyama.ksen-ac.jp",
        "password": "neko",
      }),
    ).then((value) {
      if (value == null) {
        print("resはnull");
        return;
      }
      resJson = jsonDecode(value.body);
      print(resJson["is_success"]);
    });
  // } on FormatException catch (e) {
  //   print(e);
  // }
}


// the root widget
class MyApp extends StatelessWidget {
  final LoginData data;

  const MyApp({
    required this.data,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    Widget mainWidget;
    // トークンがもうあるときそのままHomeScreenへ
    if (data.token != "") {
      mainWidget = HomeScreen(token: data.token);
      // メアドとパスワードがあるときそれを保持してLoginScreenへ
    } else if (data.email != "" || data.password != "") {
      mainWidget = LoginScreen(email: data.email, password: data.password);
      // 何もデータがないとき
    } else {
      mainWidget = const LoginScreen();
    }

    return MaterialApp(
      title: 'neko',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: mainWidget
    );
  }
}


