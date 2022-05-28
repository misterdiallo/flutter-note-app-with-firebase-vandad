import 'package:flutter/material.dart';
import 'package:my_notes/pages/auth/login_view.dart';
import 'package:my_notes/pages/auth/layout_view.dart';
import 'package:my_notes/pages/notes/note_view.dart';
import 'package:my_notes/services/auth/auth_service.dart';

import 'auth/verify_email_view.dart';
import 'home/home_view.dart';

// ignore: must_be_immutable
class RouterPage extends StatefulWidget {
  String title;
  RouterPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  bool isLogged = false;
  @override
  Widget build(BuildContext context) {
    Widget widget;
    return Scaffold(
      body: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                // return const RegistrationView();
                final user = AuthService.firebase().currentUser;
                if (user == null) {
                  widget = const LoginView();
                  break;
                } else {
                  if (user.isEmailVerified) {
                    isLogged = true;

                    widget = const HomeView();
                    break;
                  } else {
                    widget = const VerifyEmailView();
                    break;
                  }
                }
              default:
                widget = const Center(
                  child: CircularProgressIndicator(),
                );
            }
            return isLogged ? const NoteView() : LayoutView(widget: widget);
          }),
    );
  }
}
