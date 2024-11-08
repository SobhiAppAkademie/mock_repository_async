import 'package:flutter/material.dart';
import 'package:mock_async_repo/features/login/logic/user_service.dart';
import 'package:mock_async_repo/features/login/schema/server_user_response.dart';
import 'package:mock_async_repo/features/login/screens/user_screen.dart';
import 'package:mock_async_repo/features/login/widgets/email_field.dart';
import 'package:mock_async_repo/features/login/widgets/forgot_password_button.dart';
import 'package:mock_async_repo/features/login/widgets/login_button.dart';

import '../schema/user.dart';
import '../widgets/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Das MockUserRepository ist im UserService definiert.
  // Hier wird die login-Methode aufgerufen, um eine Antwort von unserem
  // MockUserRepository zu erhalten.
  final userService = UserService();

  // Wenn das Login erfolgreich war, speichern wir die Nachricht
  // in dieser Variable und zeigen sie auf dem Screen an.
  String? successMessage;

  // Wenn das Login fehlgeschlagen ist, speichern wir die Nachricht
  // in dieser Variable und zeigen sie auf dem Screen an.
  String? errorMessage;

  // Loading State
  bool isLoading = false;

  /*
    Hier erfolgt die Logik des Logins.
    Es wird eine Anfrage an unseren "fiktiven Server" simuliert.
    Mit "success" prüfen wir, ob das Login erfolgreich war oder nicht.
    Falls ja: Erfolgsmeldung anzeigen.
    Falls nein: Fehlermeldung anzeigen.

    Hinweis: Die Methode ist als async markiert. Flutter mag es nicht,
             wenn man den BuildContext aus dem Stateful-Widget benutzt,
             da es sein kann, dass das Widget nicht mehr existiert und im
             Hintergrund diese Methode ausgeführt wird. Deshalb übergeben
             wir der Funktion den BuildContext aus dem 
             @override
             Widget build(BuildContext context),
             um sicherzustellen, dass keine Probleme während der Laufzeit
             entstehen.
  */
  void handleLogin(BuildContext context) async {
    // Hier setzen wir den State zurück. Falls der Nutzer vorher eine falsche
    // Eingabe getätigt hat und z.B. die Fehlermeldung noch angezeigt wird,
    // setzen wir den State zurück und zeigen das Lade-Symbol an.

    setState(() {
      errorMessage = null;
      successMessage = null;
      isLoading = true;
    });

    // Simulieren die Server-Abfrage. Hier erhält man ein "ServerUserResponse", das die folgenden
    // Daten enthält: (Siehe mock_user_repository.dart)
    //      • User? -> Wenn die Abfrage erfolgreich war, wird ein User mitgegeben
    //      • success -> Gibt an, ob die Abfrage erfolgreich war
    //      • errorMessage? -> Wenn die Abfrage nicht erfolgreich war, kann eine Fehlermeldung mitgegeben werden
    // Wo wird die E-Mail/Passwort übergeben? (Die Controller für die Textfelder sind im UserService definiert)
    //      -> Schau dir das E-Mail- und Passwort-TextField an.
    //      -> Dort werden die TextEditingController vom UserService übergeben.
    //      -> Somit können wir aus der "login"-Methode direkt den Text abrufen.
    ServerUserResponse response = await userService.login();

    // Wenn die Abfrage erfolgreich war
    if (response.success) {
      // Überprüfen ob der User ein Admin ist
      // Wenn Ja: "Willkommen Admin" anzeigen
      // Wenn Nein: "Willkommen User" anzeigen
      setState(() => successMessage =
          "Willkommen ${response.user!.isAdmin ? "Admin" : "User"}");

      // Wir zeigen die Erfolgsmeldung 1 Sekunde an und navigieren
      // auf unseren User-Screen
      await Future.delayed(const Duration(seconds: 1));

      // Navigation zum User-Screen.
      // Hinweis: Auch hier verwenden wir eine separat Funktion, da diese Funktion mit
      // async markiert ist und Flutter es nicht mag, den BuildContext
      // innerhalb einer async-Funktion zu nutzen.
      // Information: Schaue dir die Funktion "navigateToUserScreen" an, die benötigt
      // nämlich den context.

      navigateToUserScreen(response.user!);
    } else {
      // Wenn die Abfrage nicht erfolgreich war, wird die Fehlermeldung vom Server
      // in unsere lokale Variable gesetzt, um sie auf dem Screen anzuzeigen.
      setState(() => errorMessage = response.errorMessage);
    }

    setState(() => isLoading = false);
  }

  // Navigieren zu unserem User-Screen und übergeben den eingeloggten User
  void navigateToUserScreen(User user) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UserScreen(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or icon
              const Icon(
                Icons.lock_outline,
                size: 100,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 40),

              // Email TextField
              EmailField(emailController: userService.emailController),
              const SizedBox(height: 20),

              // Password TextField
              PasswordField(passwordController: userService.passwordController),
              const SizedBox(height: 30),

              if (successMessage != null)
                Text(
                  successMessage!,
                  style: const TextStyle(color: Colors.green),
                ),

              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),

              if (isLoading) const CircularProgressIndicator(),

              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                  width: double.infinity,
                  child: LoginButton(
                    login: () => handleLogin(context),
                  )),

              const SizedBox(height: 20),

              // Forgot Password Text
              const ForgotPasswordButton()
            ],
          ),
        ),
      ),
    );
  }
}
