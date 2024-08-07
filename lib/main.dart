import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/views/home_view.dart';
import 'package:my_notes/views/login_view.dart';
import 'package:my_notes/views/notes_view.dart';
import "package:my_notes/views/register_view.dart";
import 'package:my_notes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: "Flutter Notes App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        notesRoute: (context) => const NotesView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
      home: const HomeView()));
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.done):
                final user = AuthService.firebase().currentUser;
                if (user != null) {
                  if (user.isEmailVerified) {
                    print("You are verified");
                  } else {
                    print("You need to verify your email");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/verify-email", (route) => false);
                  }
                }
                return const Text("Done");
              default:
                return const Text("Loading...");
            }
          }),
    );
  }
}
