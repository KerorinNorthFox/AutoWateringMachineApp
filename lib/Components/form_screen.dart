import 'package:flutter/material.dart';


class FormScreen extends StatelessWidget{
  final Widget? topButton;
  final Widget child;
  final LinearGradient gradient;

  const FormScreen({
    Key? key,
    required this.topButton,
    required this.gradient,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration( // bgのデザイン
          gradient: gradient // グラデーション
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 30),
                child: topButton,
              ),
            ),
            Center(
              child: Card(
                color: Colors.white60,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: child
                )
              )
            ),
          ]
        )
      )
    );
  }
}