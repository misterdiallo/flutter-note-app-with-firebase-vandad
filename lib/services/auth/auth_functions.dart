import 'package:flutter/material.dart';
import 'package:my_notes/config/app_constante.dart';
import 'package:my_notes/pages/router_page.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/utilities/dialogs/error_dialog.dart';

class AuthFunctions {
  //! Login function
  Future loginUser(BuildContext context, String email, String password) async {
    Object returnValue;
    try {
      final login = await AuthService.firebase()
          .logIn(username: email, password: password);
      returnValue = login;
    } on UserNotFoundAuthException {
      returnValue = "User not found.";
    } on WrongPasswordAuthException {
      returnValue = "The password is incorrect.";
    } on InvalidEmailAuthException {
      returnValue = "Invalid Email";
    } on UserDisabledAuthException {
      returnValue = "Account disabled! Contact the Administrator.";
    } on TooManyRequestAuthException {
      returnValue = "Too many request! Try again later.";
    } on GenericAuthException {
      returnValue = "Unknow error occured.";
    }
    print(returnValue.toString());
    print(returnValue.runtimeType);
    if (returnValue.runtimeType != String) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(
              builder: (BuildContext context) => RouterPage(
                    title: appName,
                  )),
          (Route<dynamic> route) => false);
    } else {
      await showErrorDialog(
        context: context,
        text: returnValue.toString(),
      );
    }
  }

  //! Register function
  Future registerUser(
      BuildContext context, String name, String email, String password) async {
    Object returnValue;
    try {
      returnValue = await AuthService.firebase().createUserByEmail(
        name: name,
        email: email,
        password: password,
      );
      await AuthService.firebase().updateDisplayName(name);
      await AuthService.firebase().sendEmailVerification();
    } on EmailAlreadyUseAuthException {
      returnValue = "Email address is already taken.";
    } on WeakPasswordAuthException {
      returnValue = "Password is too weak.";
    } on InvalidEmailAuthException {
      returnValue = "Email not valid.";
    } on UserDisabledAuthException {
      returnValue = "Account disabled! Contact the Administrator.";
    } on TooManyRequestAuthException {
      returnValue = "Too many request! Try again later.";
    } on GenericAuthException {
      returnValue = "Unknow error occured.";
    }
    if (returnValue.runtimeType != String) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(
              builder: (BuildContext context) => RouterPage(
                    title: appName,
                  )),
          (Route<dynamic> route) => false);
    } else {
      await showErrorDialog(
        context: context,
        text: returnValue.toString(),
      );
    }
  }
}
