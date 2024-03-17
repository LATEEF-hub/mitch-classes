import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:modernlogintute/components/my_button.dart';
import 'package:modernlogintute/components/my_textfields.dart';
import 'package:modernlogintute/components/square_tile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //creating controls for the TEXTEDIT FIELD
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Sign in method
  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //pop the loading circle after LOGIN
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading CIRCLE
      Navigator.pop(context);
      //Wrong email
      if (e.code == 'user-not-found') {
        //show error
        wrongEmailMessage();
      }

      //Wrong Password
      else if (e.code == 'wrong-password') {
        //error msg
        wrongPasswordMessage();
      }
    }
  }

  //wrong email message
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text(
            'Incorrect Email',
          ),
        );
      },
    );
  }

  //Wrong password message
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text(
            'Incorrect Password',
          ),
        );
      },
    );
  }

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
                controller: emailController,
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
                  Text('Not a member?'),
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
