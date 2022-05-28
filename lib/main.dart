import 'package:flutter/material.dart';

import 'package:my_notes/config/app_constante.dart';
import 'package:my_notes/config/constant/routes.dart';
import 'package:my_notes/pages/auth/login_view.dart';
import 'package:my_notes/pages/auth/registration_view.dart';
import 'package:my_notes/pages/auth/verify_email_view.dart';
import 'package:my_notes/pages/bloc/home_bloc_page.dart';
import 'package:my_notes/pages/notes/create_update_note_view.dart';
import 'package:my_notes/pages/notes/note_view.dart';

import 'pages/router_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: RouterPage(title: appName),
      home: const BlocHomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegistrationView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        notesRoute: (context) => const NoteView(),
        createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        routerRoute: (context) => RouterPage(
              title: appName,
            ),
      },
    ),
  );
}
// BF6A-3EEB

