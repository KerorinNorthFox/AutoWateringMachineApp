import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:souzouseisaku/Screens/home_screen.dart';
import 'package:souzouseisaku/Screens/login_screen.dart';
import 'package:souzouseisaku/Screens/register_screen.dart';


class LoginData{
  String email = "";
  String password = "";
  String token = "";
}


class RegisterData extends LoginData{
  String username = "";
}


// ストレージからデータを読み込む
// token、email、passwordを読み込んで、そのdataを返す
Future<LoginData> readStorage() async {
  const storage = FlutterSecureStorage();
  LoginData data = LoginData();

  final String? token = await storage.read(key: "token");
  final String? email = await storage.read(key: "email");
  final String? password = await storage.read(key: "password");

  data.email = (email != null) ? email : "";
  data.password = (password != null) ? password : "";
  data.token = (token != null) ? token : "";

  return data;
}


// ストレージに書き込む
void writeStorage(LoginData data) {
  const storage = FlutterSecureStorage();
  storage.write(key: "email", value: data.email);
  storage.write(key: "password", value: data.password);
  storage.write(key: "token", value: data.token);
}


// ストレージのキーを削除
void deleteStorage({bool isAll = false}) {
  const storage = FlutterSecureStorage();
  storage.delete(key: "token");
  if (isAll) {
    storage.delete(key: "email");
    storage.delete(key: "password");
  }
  print("Delete successfully");
}


void logout() {
  const storage = FlutterSecureStorage();
  storage.delete(key: "token");
}


// RegisterScreenへの画面遷移
void navigateToRegister(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterScreen()));
}


// LoginScreenへの画面遷移
void navigateToLogin(BuildContext context) {
  Navigator.of(context).pop();
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
}


// HomeScreenへの画面遷移
void navigateToHome(BuildContext context, String token) {
  Navigator.of(context).pop();
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(token: token,)));
}


// ログイン処理
Future<bool> login(BuildContext context, LoginData ld) async {
  final uri = Uri.https(dotenv.get("URL"), "/api/auth");
  dynamic resJson;

  try{
    // /api/authへpost
    await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': ld.email,
        "password": ld.password,
      }),
    ).then((value) { // responseが帰ってきたら
      resJson = jsonDecode(value.body);
      if (resJson["is_success"] == "true"){
        // ストレージに書き込み TODO: 書き込みするかを選択できるようにする
        LoginData data = LoginData();
        data.email = ld.email;
        data.password = ld.password;
        data.token = resJson["token"];
        writeStorage(data);
        // HomeScreenへ移動
        navigateToHome(context, resJson["token"]);
        dialog(context, "ログインしました");
        return true;
      } else {
        dialog(context, resJson["message"]);
      }
    });

  } catch (e) { // ログインが失敗した時の処理
    dialog(context, "エラーが発生しました :\n$e");
  }
  return false;
}


// アカウント登録処理
Future<bool> register(BuildContext context, RegisterData data) async {
  final uri = Uri.https(dotenv.get("URL"), "/api/register");
  dynamic resJson;

  try{
    await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": data.username,
        'email': data.email,
        "password": data.password,
      }),
    ).then((value) {
      resJson = jsonDecode(value.body);
      if (resJson["is_success"] == "true"){
        Navigator.of(context).pop();
        dialog(context, "アカウントを作成しました");
        return true;
      } else {
        dialog(context, resJson["message"]);
      }
    });

  } catch (e) {
    dialog(context, "エラーが発生しました :\n$e");

  }
  return false;
}


// ダイアログ表示
void dialog(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(text),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  );
}