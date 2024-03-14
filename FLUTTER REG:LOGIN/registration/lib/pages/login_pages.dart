import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: const SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              //App Logo
              Icon(
                Icons.lock,
                size: 100,
              ),
              //Space between logo and form
              SizedBox(
                height: 50,
              ),
              //Welcome, back, you have been missed
              Text(
                'Welcome back you\'ve being missed!',
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
              SizedBox(
                height: 25,
              )

              //Username Textfield
            ],
          ),
        ),
      ),
    );
  }
}
