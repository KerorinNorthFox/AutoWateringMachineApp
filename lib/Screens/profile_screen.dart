import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:souzouseisaku/Utils/utils.dart';


class UserData extends RegisterData {
  String id = "";
}


class ProfileScreen extends StatefulWidget {
  final String token;

  const ProfileScreen({
    Key? key,
    required this.token
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  String username = "";
  String email = "";
  String id = "";

  Future<UserData?> getInfo(BuildContext context, String token) async {
    final uri = Uri.https(dotenv.get("URL"), "/api/user");
    dynamic resJson;
    UserData? data = UserData();

    try {
      await http.get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: token,
        },
      ).then((res) {
        resJson = jsonDecode(res.body);
        if (resJson["is_success"] == "true") {
          data!.username = resJson["username"];
          data!.email = resJson["email"];
          data!.id = resJson["id"];
        }else{
          data = null;
        }
      });
    } catch (e) {}

    return data;
  }

  @override
  Widget build(BuildContext context) {
    if (username == ""){
      getInfo(context, widget.token).then((data) {
        if (data != null){
          setState(() {
            username = data.username;
            email = data.email;
            id = data.id;
          });
        }
      });
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Card(
        color: Colors.white54,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Row(
                  children: [
                    Text(
                      "アカウント情報",
                      style: TextStyle(
                        fontSize: 24
                      ),
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(80, 20),
                      ),
                      child: Text(
                        "編集",
                        style: TextStyle(
                          fontSize: 14
                        ),
                      ),
                      onPressed: () {},
                    )
                  ]
                ),
              ),
              SizedBox(height: 10,),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text(
                    "ユーザー名：$username",
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text(
                    "ユーザーid：$id",
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text(
                    "メールアドレス：$email",
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}