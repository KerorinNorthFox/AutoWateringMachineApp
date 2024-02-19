import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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


// ダイアログ表示
void dialog(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 16
          ),
        ),
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