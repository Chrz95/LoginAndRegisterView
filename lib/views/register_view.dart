import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_exceptions.dart';
import 'package:learningdart/services/auth/auth_service.dart';
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
                    await AuthService.firebase().createUser(
                      email: emailtext,
                      password: pwdtext,
                    );
                    await AuthService.firebase().sendEmailVerification();
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  } on WeakPasswordAuthException {
                    await showErrorDialog(context, 'Weak Password');
                  } on EmailAlreadyinUseAuthException {
                    await showErrorDialog(context, 'Email already in use');
                  } on InvalidEmailAuthException {
                    await showErrorDialog(
                        context, 'Invalid Email Address Error');
                  } on GenericAuthException {
                    await showErrorDialog(context, 'Failed to register');
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
