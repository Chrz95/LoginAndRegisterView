import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learningdart/constants/routes.dart';
import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
          title: const Text("Register"),
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
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailtext,
                      password: pwdtext,
                    );
                    final user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == "weak-password") {
                      await showErrorDialog(context, 'Weak password');
                    } else if (e.code == "email-already-in-use") {
                      await showErrorDialog(context, 'Email already in use');
                    } else if (e.code == "invalid-email") {
                      await showErrorDialog(context, 'Invalid email');
                    } else {
                      await showErrorDialog(context, 'Error: ${e.code}');
                    }
                  } catch (e) {
                    await showErrorDialog(context, e.toString());
                  }
                  //print(userCredential);
                }),
                child: const Text('Register')),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text("Already registered? Login here!"))
          ],
        ));
  }
}
