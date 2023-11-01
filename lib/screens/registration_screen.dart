import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sadi/constants.dart';
import 'package:sadi/screens/login_screen.dart';
import 'package:sadi/components/rounded_button.dart';
import 'package:sadi/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email = '';
  late String password = '';
  bool showSpinner = false;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blueAccent,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 160.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email correctly';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value!;
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
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                if (errorMessage != null)  // Show the error message if it's not null
                  Center(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),

                RoundedButton(
                  title: 'Register',
                  color: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      errorMessage = null; // Clear the previous error message
                    });
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      if (password.isNotEmpty) {
                        // Only start the spinner if the password is not empty
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          var userResult =
                          await firebaseAuth.createUserWithEmailAndPassword(
                              email: email, password: password);
                          formKey.currentState!.reset();
                          Navigator.pushNamed(context, ChatScreen.id);
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                            if (e is FirebaseAuthException) {
                              if (e.code == 'email-already-in-use') {
                                errorMessage =
                                'Email is already in use. Please choose a different one.';
                              } else if (e.code == 'weak-password') {
                                errorMessage =
                                'Password is too weak. Please choose a stronger password.';
                              } else if (e.code == 'invalid-email') {
                                errorMessage =
                                'Invalid email format. Please enter a valid email.';
                              } else {
                                errorMessage = 'Registration failed: ${e.message}';
                              }
                            } else {
                              errorMessage = 'Registration failed: $e';
                            }
                          });
                        }
                      } else {
                        setState(() {
                          errorMessage = 'Please enter your password.';
                        });
                      }
                    }
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
