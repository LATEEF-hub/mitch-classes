import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/my_textfields.dart';
import 'package:modernlogintute/components/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //creating controls for the TEXTEDIT FIELD
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //Sign in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                height: 10,
              ),
              // password Textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                labelText: 'Password',
              ),
              const SizedBox(
                height: 10,
              ),
              //Forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //Sign in
              SignInButton(
                onTap: signUserIn,
              ),
              const SizedBox(
                height: 25,
              ),

              // Or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.8,
                        color: Colors.green[400],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        'Or Continue with',
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.8,
                        color: Colors.green[400],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              //google + apple SignIn
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //google button
                  SquareTile(
                    imagePath: 'lib/images/google.png',
                  ),
                  SizedBox(
                    width: 15,
                  ),

                  // apple button
                  SquareTile(
                    imagePath: 'lib/images/apple.png',
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member?'),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Register now',
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
