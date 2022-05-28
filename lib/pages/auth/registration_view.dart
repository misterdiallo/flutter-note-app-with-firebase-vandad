import 'package:flutter/material.dart';
import 'package:my_notes/config/constant/routes.dart';
import 'package:my_notes/services/auth/auth_functions.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  checkRegistration() async {
    if (_formKey.currentState!.validate()) {
      // final name = _nameController.text;
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      await AuthFunctions().registerUser(
        context,
        name,
        email,
        password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "REGISTER",
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
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      hintText: "Enter your name",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      // Return null if the entered email is valid
                      return null;
                    },
                  ),
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
                    onFieldSubmitted: (value) => checkRegistration(),
                    decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      errorMaxLines: 2,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      // Check if the entered email has the right format
                      if (!RegExp(
                              r'^(?:(?=.*[a-z])(?:(?=.*[A-Z])(?=.*[\d\W])|(?=.*\W)(?=.*\d))|(?=.*\W)(?=.*[A-Z])(?=.*\d)).{8,}$')
                          .hasMatch(value)) {
                        return 'Password must have at least one capital letter, one number, one special character, and one small letter.';
                      }
                      // Return null if the entered email is valid
                      return null;
                    },
                  ),
                ],
              ),
            ),
            TextButton(
              child: const Text("Register"),
              onPressed: () => checkRegistration(),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              child: const Text("Already Have Account"),
              onPressed: () async {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    routerRoute, (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
