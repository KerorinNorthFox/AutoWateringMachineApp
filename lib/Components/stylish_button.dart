import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';


class StylishButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const StylishButton({
    Key? key,
    required this.child,
    required this.onTap,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineGradientButton(
      gradient: const LinearGradient(
        begin: FractionalOffset.topLeft, // 左上から
        end: FractionalOffset.bottomRight,
        colors: [
          Colors.blueAccent,
          Colors.purpleAccent,
          Colors.orangeAccent
        ]
      ),
      strokeWidth: 2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      radius: const Radius.circular(8),
      onTap: onTap,
      child: child,
    );
  }
}