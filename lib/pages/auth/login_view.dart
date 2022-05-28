import 'package:flutter/material.dart';
import 'package:my_notes/config/constant/routes.dart';
import 'package:my_notes/services/auth/auth_functions.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  loginCheck() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      await AuthFunctions().loginUser(
        context,
        email,
        password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "LOGIN",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Center(
          child: Text(
            "let's start coding!",
            style: Theme.of(context).textTheme.overline,
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email address';
                  }
                  // Check if the entered email has the right format
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  // Return null if the entered email is valid
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                ),
                onFieldSubmitted: (value) => loginCheck(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your password';
                  }
                  // // Check if the entered email has the right format
                  // if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  //   return 'Please enter a valid email address';
                  // }
                  // Return null if the entered email is valid
                  return null;
                },
              ),
            ],
          ),
        ),
        TextButton(
          child: const Text("Login"),
          onPressed: () => loginCheck(),
        ),
        const SizedBox(
          height: 30,
        ),
        TextButton(
          child: const Text("Not registered yet ?"),
          onPressed: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute, (Route<dynamic> route) => false);
          },
        ),
      ],
    );
  }
}
