import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sadi/constants.dart';
import 'package:sadi/screens/welcome_screen.dart';
import 'package:sadi/service/auth_service.dart';
import 'package:sadi/components/rounded_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sadi/screens/chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final authService = AuthService();
  bool showSpinner = false;
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
            Navigator.pushReplacementNamed(context, WelcomeScreen.id);
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
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
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
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                if (errorMessage != null)
                  Center(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                RoundedButton(
                  title: 'Login',
                  color: Colors.lightBlueAccent,
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
                          var userResult = await firebaseAuth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          if (userResult.user != null) {
                            // Login successful, navigate to the chat screen
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => ChatScreen()),
                                  (route) => false,
                            );
                          } else {
                            setState(() {
                              errorMessage = 'An error occurred during login.';
                              showSpinner = false;
                            });
                          }
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            showSpinner = false;
                            errorMessage = 'Login failed: ${e.message}';
                          });
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                            errorMessage = 'An error occurred: $e';
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
