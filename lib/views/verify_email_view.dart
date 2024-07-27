import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';

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
              const Text(
                  "We have sent you an email verification. Please open it to verify your account."),
              const Text(
                  "If you have NOT received the email please click resend or confirm if your email is correct",
                  style: TextStyle(fontSize: 30.0)),
              TextButton(
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                },
                child: const Text("Re-Send Email Verification"),
              ),
              TextButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (_) => false,
                  );
                },
                child: const Text("Restart"),
              )
            ],
          ),
        ));
  }
}
