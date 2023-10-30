import 'package:firebase_auth/firebase_auth.dart';
import 'package:sadi/constants.dart';
import 'package:flutter/material.dart';
import 'package:sadi/components/rounded_button.dart';
import 'package:sadi/screens/login_screen.dart';

// ignore: use_key_in_widget_constructors
class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

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
                title: 'Register',
                color: Colors.blueAccent,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      var userResult =
                          await firebaseAuth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      formKey.currentState!.reset();

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Registration is completed. Redirecting to login page'

                          ),

                        ),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, LoginScreen.id);
                      // ignore: avoid_print
                      print(userResult.user!.uid);
                    } catch (e) {
                      // ignore: avoid_print
                      print(e.toString());
                    }
                  } else {}
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
