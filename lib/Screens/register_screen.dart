import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progress_state_button/progress_button.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:email_validator/email_validator.dart';

import 'package:souzouseisaku/Utils/utils.dart';
import 'package:souzouseisaku/Components/form_screen.dart';
import "package:souzouseisaku/Components/text_field.dart";
import 'package:souzouseisaku/Components/stylish_button.dart';


// ユーザー登録画面
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  String username = ""; // ユーザー名
  String email = ""; // メアド
  String password = ""; // パスワード

  bool hidePassword = true; // パスワードの表示非表示
  bool _isDisabled = false; // ボタンの無効化

  ButtonState _buttonState = ButtonState.idle; // ボタンの状態

  final _formKey = GlobalKey<FormState>();

  void _setStateIdle(){
    setState(() {
      _isDisabled = false;
      _buttonState = ButtonState.idle;
    });
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
      ).then((res) {
        resJson = jsonDecode(res.body);
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


  @override
  Widget build(BuildContext context){
    return FormScreen(
      topButton: Opacity(
        opacity: _isDisabled ? 0.4 : 1.0,
        child: StylishButton(
          onTap: _isDisabled ? () => () : () => Navigator.of(context).pop(),
          child: Text(
            "戻る",
            style: TextStyle(
              color: Colors.purpleAccent.withOpacity(0.8),
            ),
          )
        ),
      ),

      gradient: LinearGradient(
        begin: FractionalOffset.topLeft, // 左上から
        end: FractionalOffset.bottomRight, // 右下へ
        colors: [
          const Color(0xffe4a972).withOpacity(0.6),
          const Color(0xff9941d8).withOpacity(0.6),
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
              "Register",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),

            LoginTextField(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ユーザー名を入力してください';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: "ユーザー名"
                ),
                onChanged: (String value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
            ),

            LoginTextField(
              child: TextFormField(
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
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                }
              )
            ),

            LoginTextField(
              child: TextFormField(
                obscureText: hidePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'パスワードを入力してください';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  labelText: "パスワード",
                  suffixIcon: IconButton(
                    icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
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
                  text: "登録",
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
                  RegisterData data = RegisterData();
                  data.username = username;
                  data.email = email;
                  data.password = password;
                  isSuccess = await register(context, data);
                }

                if (!isSuccess) {
                  _setStateIdle();
                }

              }
            )
          ],
        ),
      ),
    );
  }
}