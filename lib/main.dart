import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import './screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // with import firebase_core
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        // all the token management for login and logout is managed by firebaseauth package and authstatechanges
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return ChatScreen();
          }
          return AuthScreen();
        },
      ),
    );
  }
}
