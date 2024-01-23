import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  final bool isLogin = false;

  const HomeScreen({
    required this.token,
    Key? key
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  String username = "";
  String email = "";
  String id = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "username: $username",
              style: const TextStyle(
                fontSize: 24
              ),
            ),
            Text(
              "email: $email",
              style: const TextStyle(
                fontSize: 24
              ),
            ),
            Text(
              "id: $id",
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            TextButton(
              child: const Text(
                "Get Account Info",
                style: TextStyle(
                    fontSize: 24
                ),
              ),
              onPressed: () async {
                // await getInfo();
              },
            )
          ],
        ),
      )
    );
  }
}