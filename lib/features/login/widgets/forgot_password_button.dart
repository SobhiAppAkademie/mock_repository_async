import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Handle "forgot password" logic here
      },
      child: const Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}
