import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:my_notes/constants/routes.dart";
import "package:my_notes/utilities/show_error_dialog.dart";

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text("Login"),
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
                child: Column(
                  children: [
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
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          final user = FirebaseAuth.instance.currentUser;
                          if (user?.emailVerified ?? false) {
                            // email is verified already
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              notesRoute,
                              (route) => false,
                            );
                          } else {
                            // email is not verified yet
                            Navigator.of(context).pushNamed(
                              verifyEmailRoute,
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "user-not-found") {
                            await showErrorDialog(
                              context,
                              "User not found",
                            );
                          } else if (e.code == "wrong-password") {
                            await showErrorDialog(
                              context,
                              "Wrong password",
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
                      child: const Text("Login"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).popAndPushNamed(registerRoute);
                      },
                      child: const Text("No account? Register Here"),
                    ),
                  ],
                ),
              );
            default:
              return const Text('loading');
          }
        },
      ),
    );
  }
}
