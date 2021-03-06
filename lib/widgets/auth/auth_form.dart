import 'package:chat_app/widgets/upload_picked_image.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String username,
    String passoword,
    XFile? userImageFile,
    bool isLogIn,
    BuildContext ctx,
  ) submitFn;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  // to access the filled up from outside build function
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  var _isLogIn = false;
  XFile? _pickedImage;

  void onSubmitted() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    // unfocuses from any text field

    if (_pickedImage == null && !_isLogIn) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please upload your Profile Picture',
          ),
          duration: const Duration(
            seconds: 3,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        // trim() ignores the blank spaces
        _userName.trim(),
        _userPassword.trim(),
        _pickedImage,
        _isLogIn,
        context,
      );
    }
  }

  void imagePicker(XFile? image) {
    _pickedImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              // to access the filled up from outside build function
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //dont take as much space as possible but as minimum as needed
                children: <Widget>[
                  if (!_isLogIn) UploadImage(imagePicker),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'please enter valid email address';
                      }
                      return null;
                    },
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    onSaved: (value) {
                      _userEmail = value as String;
                    },
                  ),
                  if (!_isLogIn)
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'please enter username of atleast 4 characters';
                        }
                        return null;
                      },
                      key: ValueKey('username'),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userName = value as String;
                      },
                    ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'please enter a password of atleast 7 characters long';
                      }
                      return null;
                    },
                    key: ValueKey('password'),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    // hidden(*****)
                    onSaved: (value) {
                      _userPassword = value as String;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading == true) CircularProgressIndicator(),
                  if (widget.isLoading == false)
                    RaisedButton(
                      onPressed: onSubmitted,
                      child: Text(_isLogIn ? 'LogIn' : 'SignUp'),
                    ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _isLogIn = !_isLogIn;
                      });
                    },
                    child: Text(
                      _isLogIn
                          ? 'Create New Account'
                          : 'I already have an account',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
