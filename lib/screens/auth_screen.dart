import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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
    XFile? image,
    bool isLogIn,
    BuildContext importedCtx,
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

      final refPath = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(userCredential.user!.uid + '.jpg');
      // ref points to the bucket in firebase which stores the images, child is the folder name, if not there it creates
      // it in storage section of firebase,
      // then in that folder another child stores the .jpg file with the name of the image as the user id

      await refPath.putFile(
        // storing the image in the bucket in firebase storage
        File(image!.path),
      );

      final dpUrl = await refPath.getDownloadURL();
      // gets the image url

      await FirebaseFirestore.instance
          .collection('users')
          // creating new collection with messages in firebase
          .doc(userCredential.user!.uid)
          // this gives the user id
          .set(
        {
          // saving some extra data in the firebase
          'username': username,
          'email': email,
          'dpUrl': dpUrl,
          // storing the dp so that later to access it we can just use the url but not the whole process of getting url again
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
      Scaffold.of(importedCtx).showSnackBar(
        // but this context should come from where we are showing the snackbar which is not in this file, so importing
        // with constructor
        SnackBar(
          content: Text(message),
        ),
      );
      setState(
        () {
          _isLoading = false;
        },
      );
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
