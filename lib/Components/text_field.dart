import 'package:flutter/material.dart';


class LoginTextField extends StatelessWidget {
  const LoginTextField({
    Key? key,
    required this.child
  }) : super(key: key);

  final TextFormField child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 6, left: 12, right: 12),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)
      ),
      child: child
    );
  }
}


