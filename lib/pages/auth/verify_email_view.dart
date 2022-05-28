import 'package:flutter/material.dart';
import 'package:my_notes/config/constant/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  late TextEditingController _codeEmailController;
  @override
  void initState() {
    _codeEmailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _codeEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "VERIFICATION EMAIL SENT",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              Text(
                "Before we start coding, \n Please confirm your email address.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.overline,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        TextButton(
          child: const Text("Resend verfication email"),
          onPressed: () async {
            await AuthService.firebase().sendEmailVerification();
          },
        ),
        const SizedBox(
          height: 10,
        ),
        IconButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  routerRoute, (Route<dynamic> route) => false);
            },
            icon: const Icon(Icons.refresh))
      ],
    );
  }
}
