import 'package:flutter/material.dart';
import 'package:modernlogintute/components/my_textfields.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //creating controls for the TEXTEDIT FIELD
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              //App Logo
              const Icon(
                Icons.lock,
                size: 100,
              ),
              //Space between logo and form
              const SizedBox(
                height: 50,
              ),
              //Welcome, back, you have been missed
              const Text(
                'Welcome back you\'ve being missed!',
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
              const SizedBox(
                height: 50,
              ),
              //Username Textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                labelText: 'Username',
                obscureText: false,
              ),
              const SizedBox(
                height: 25,
              ),
              // password Textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                labelText: 'Password',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
