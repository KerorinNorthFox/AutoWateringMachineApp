import 'package:flutter/material.dart';

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


  @override
  Widget build(BuildContext context) {
    return FormScreen(
      topButton: Opacity(
        opacity: _isDisabled ? 0.4 : 1.0,
        child: StylishButton(
          onTap: _isDisabled ? () => () : () => navigateToRegister(context),
          child: Text(
            "Register",
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
                  labelText: "Email Address"
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
                  labelText: 'Password',
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
                  text: "login",
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