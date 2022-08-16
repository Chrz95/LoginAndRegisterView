import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;
import 'package:learningdart/constants/routes.dart';

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
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailtext, password: pwdtext);
                    devtools.log(userCredential.toString());
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/notes/',
                      (route) => false,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "user-not-found") {
                      devtools.log("User not found");
                    } else if (e.code == "wrong-password") {
                      devtools.log("wrong password");
                    }
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
