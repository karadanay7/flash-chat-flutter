import 'package:sadi/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sadi/components/rounded_button.dart';
import 'package:sadi/screens/chat_screen.dart';
import 'package:sadi/screens/welcome_screen.dart';
import 'package:sadi/service/auth_service.dart';

// ignore: use_key_in_widget_constructors
class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email correctly';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                  //Do something with the user input.
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password correctly';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value!;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title: 'Login',
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      final result =
                          await authService.signInWithEmail(email, password);
                      if (result == 'success') {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => ChatScreen()),
                          (route) => false,
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content: Text(result!),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Go Back'))
                              ], // Display the error message
                            );
                          },
                        );
                      }
                    }
                  }),
              RoundedButton(
                title: 'Anonymous',
                color: Colors.lightBlueAccent,
                onPressed: () {
                  final result = authService.signInAnonymous();
                  if (result != null) {
                    Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                  } else {
                    print('hata ile karsilasildi');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
