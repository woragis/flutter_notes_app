import 'package:flutter/material.dart';
import "package:my_notes/constants/routes.dart";
import "package:my_notes/services/auth/auth_exceptions.dart";
import "package:my_notes/services/auth/auth_service.dart";
import "package:my_notes/utilities/show_error_dialog.dart";

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Center(
                  child: Column(children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: "Enter your email here"),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: "Enter your password here"),
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          await AuthService.firebase().createUser(
                            email: email,
                            password: password,
                          );
                          AuthService.firebase().sendEmailVerification();
                          Navigator.of(context).pushNamed(verifyEmailRoute);
                        } on WeakPasswordAuthException {
                          await showErrorDialog(
                            context,
                            "Your password is too weak",
                          );
                        } on EmailAlreadyInUseAuthException {
                          await showErrorDialog(
                            context,
                            "Email already in use",
                          );
                        } on InvalidEmailAuthException {
                          await showErrorDialog(
                            context,
                            "Invalid Email entered",
                          );
                        } on GenericAuthException {
                          await showErrorDialog(
                            context,
                            "Failed to Register",
                          );
                        }
                      },
                      child: const Text("Register"),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).popAndPushNamed(loginRoute);
                        },
                        child: const Text("Already Registered? Login Here"))
                  ]),
                );
              default:
                return const Text('loading');
            }
          }),
    );
  }
}
