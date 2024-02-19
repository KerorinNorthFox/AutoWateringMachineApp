import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:email_validator/email_validator.dart';

import 'package:souzouseisaku/Utils/utils.dart';
import 'package:souzouseisaku/Components/form_screen.dart';
import 'package:souzouseisaku/Components/stylish_button.dart';
import "package:souzouseisaku/Components/text_field.dart";


// ログイン画面
class LoginScreen extends StatefulWidget {
  final String email; // メアド
  final String password; // パスワード

  const LoginScreen({
    this.email = "",
    this.password = "",
    Key? key
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  String email = ""; // メアド
  String password = ""; // パスワード
  bool _hidePassword = true; // パスワードを隠すか
  bool _isDisabled = false; // ボタンの無効化

  ButtonState _buttonState = ButtonState.idle; // ボタンの状態

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      email = widget.email;
      password = widget.password;
    });
  }

  void _setStateIdle(){
    setState(() {
      _isDisabled = false;
      _buttonState = ButtonState.idle;
    });
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
          LoginData data = ld;
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


  @override
  Widget build(BuildContext context) {
    return FormScreen(
      topButton: Opacity(
        opacity: _isDisabled ? 0.4 : 1.0,
        child: StylishButton(
          onTap: _isDisabled ? () => () : () => navigateToRegister(context),
          child: Text(
            "アカウント登録",
            style: TextStyle(
              color: Colors.purpleAccent.withOpacity(0.8),
            ),
          )
        ),
      ),

      gradient: LinearGradient( // グラデーション
        begin: FractionalOffset.topLeft, // 左上から
        end: FractionalOffset.bottomRight, // 右下へ
        colors: <Color>[
          Colors.greenAccent.shade200,
          Colors.blueAccent.shade200,
        ],
        stops: const [
          0.15,
          1.0,
        ]
      ),

      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white
              )
            ),

            LoginTextField(
              child: TextFormField(
                initialValue: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'メールアドレスを入力してください';
                  } else if (!EmailValidator.validate(value)) {
                    return "メールアドレスの形が違います";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail),
                  hintText: "hogehoge@mail.com",
                  labelText: "メールアドレス"
                ),
                onChanged: (String value){
                  setState(() {
                    email = value;
                  });
                }
              )
            ),

            LoginTextField(
              child: TextFormField(
                initialValue: password,
                obscureText: _hidePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'パスワードを入力してください';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  labelText: 'パスワード',
                  suffixIcon: IconButton(
                    icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    }
                  )
                ),
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                }
              )
            ),

            const SizedBox(height: 15),

            ProgressButton.icon(
              iconedButtons: const {
                ButtonState.idle: IconedButton(
                  text: "ログイン",
                  icon: Icon(Icons.login,color: Colors.white),
                  color: Colors.white54
                ),
                ButtonState.loading: IconedButton(
                    text: "Loading",
                    color: Colors.transparent
                ),
                ButtonState.fail: IconedButton(
                    text: "Failed",
                    icon: Icon(Icons.cancel,color: Colors.white),
                    color: Colors.red
                ),
                ButtonState.success: IconedButton(
                    text: "Success",
                    icon: Icon(Icons.check_circle,color: Colors.white,),
                    color: Colors.green)
              },
              state: _buttonState,
              onPressed: _isDisabled ? null : () async {
                setState(() {
                  _buttonState = ButtonState.loading;
                  _isDisabled = true;
                });

                bool isSuccess = false;
                if (_formKey.currentState!.validate()) {
                  // バリデーションを通ったらログイン処理＆画面遷移
                  LoginData data = LoginData();
                  data.email = email;
                  data.password = password;
                  isSuccess = await login(context, data);
                }

                if (!isSuccess) {
                  _setStateIdle();
                }

              }
            )
          ]
        )
      )
    );
  }
}