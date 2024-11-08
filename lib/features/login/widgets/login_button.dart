import 'package:flutter/material.dart';

/*
Widget: LoginButton

Wenn der Nutzer sich einloggen möchte, klickt er auf diesen LoginButton.
Dem Button wird eine Funktion im Konstruktur übergeben, um diese Funktion 
beim Klicken des Buttons,
also bei "onPressed", auszuführen.

*/
class LoginButton extends StatelessWidget {
  final Function() login;
  const LoginButton({super.key, required this.login});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => login(),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        "Login",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
