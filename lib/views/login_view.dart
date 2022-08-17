import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_exceptions.dart';
import 'package:learningdart/services/auth/auth_service.dart';

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController email;

  late TextEditingController password;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Column(
          children: [
            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "E-mail"),
            ),
            TextField(
                controller: password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(hintText: "Password")),
            TextButton(
                onPressed: (() async {
                  final emailtext = email.text;
                  final pwdtext = password.text;
                  try {
                    await AuthService.firebase()
                        .logIn(email: emailtext, password: pwdtext);
                    final user = AuthService.firebase().currentUser;
                    if (user?.isEmailVerified ?? false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        notesRoute,
                        (route) => false,
                      );
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (route) => false,
                      );
                    }
                  } on UserNotFoundAuthException {
                    await showErrorDialog(context, 'User not found');
                  } on WrongPasswordAuthException {
                    await showErrorDialog(context, 'Wrong credentials');
                  } on GenericAuthException {
                    await showErrorDialog(context, 'Authentication Error');
                  }
                }),
                child: const Text('Login')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false,
                  );
                },
                child: const Text("Not registered yet? Register here!"))
          ],
        ));
  }
}
