import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "dart:developer" as devtools show log;

enum MenuAction { logout }

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  final Text homeTitle = const Text("Home");
  final Text registerButton = const Text(
    "Register here",
    style: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),
  );
  final String registerRoute = "/register";
  final Text loginButton = const Text(
    "Login here",
    style: TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),
  );
  final String loginRoute = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: homeTitle,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      "/login",
                      (_) => false,
                    );
                  }
                  devtools.log(shouldLogout.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(children: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(registerRoute);
            },
            child: registerButton),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(loginRoute);
            },
            child: loginButton)
      ]),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Log Out"))
        ],
      );
    },
  ).then((value) => value ?? false);
}
