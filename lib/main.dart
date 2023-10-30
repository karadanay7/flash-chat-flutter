import 'package:flutter/material.dart';
import 'package:sadi/screens/welcome_screen.dart';
import 'package:sadi/screens/login_screen.dart';
import 'package:sadi/screens/registration_screen.dart';
import 'package:sadi/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: WelcomeScreen.id,
      routes:{
        WelcomeScreen.id: (context)=> const WelcomeScreen(),
        LoginScreen.id: (context)=> LoginScreen(),
        RegistrationScreen.id:(context) => RegistrationScreen(),
        ChatScreen.id: (context) => const ChatScreen(),

      },
    );
  }
}
