import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:my_notes/constants/routes.dart";
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
          future: Firebase.initializeApp(
              // options: DefaultFirebaseOptions.currentPlataform;
              ),
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
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          final user = FirebaseAuth.instance.currentUser;
                          await user?.sendEmailVerification();
                          Navigator.of(context).pushNamed(verifyEmailRoute);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "weak-password") {
                            await showErrorDialog(
                              context,
                              "Your password is too weak",
                            );
                          } else if (e.code == "email-already-in-use") {
                            await showErrorDialog(
                              context,
                              "Email already in use",
                            );
                          } else if (e.code == "invalid email") {
                            await showErrorDialog(
                              context,
                              "Invalid Email entered",
                            );
                          } else {
                            await showErrorDialog(
                              context,
                              "Error: ${e.code}",
                            );
                          }
                        } catch (e) {
                          await showErrorDialog(
                            context,
                            e.toString(),
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
