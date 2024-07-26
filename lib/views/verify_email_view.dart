import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Verify Email"),
        ),
        body: Center(
          child: Column(
            children: [
              const Text("Verify your email", style: TextStyle(fontSize: 30.0)),
              TextButton(
                onPressed: () async {
                  final userCredential = FirebaseAuth.instance.currentUser;
                  await userCredential?.sendEmailVerification();
                },
                child: const Text("Send Email Verification"),
              )
            ],
          ),
        ));
  }
}
