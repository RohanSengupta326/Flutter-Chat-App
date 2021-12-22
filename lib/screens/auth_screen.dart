import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void authUser(
    String email,
    String username,
    String password,
    bool isLogIn,
    BuildContext ctx,
  ) async {
    // use firebase sdk to login/sigup a user not http module
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogIn) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      FirebaseFirestore.instance
          .collection('users')
          // creating new collection with messages in firebase
          .doc(userCredential.user!.uid)
          // this gives the user id
          .set(
        {
          // saving some extra data in the firebase
          'username': username,
          'email': email,
        },
      );

      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (err) {
      var message = 'Sorry!, some error ocurred!';
      if (err.message != null) {
        message = err.message as String;
      }
      Scaffold.of(ctx).showSnackBar(
        // but this context should come from where we are showing the snackbar which is not in this file, so importing
        // with constructor
        SnackBar(
          content: Text(message),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(authUser, _isLoading),
    );
  }
}
