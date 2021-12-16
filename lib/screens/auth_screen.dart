import 'package:flutter/material.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void authUser(
    String email,
    String username,
    String password,
    bool isLogIn,
  ) {
    // use firebase sdk to login/sigup a user not http module 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor, body: AuthForm(authUser));
  }
}
