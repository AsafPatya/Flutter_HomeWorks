import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_wrapper/auth_repository.dart';
import '../firebase_wrapper/storage_repository.dart';
import '../Screens/saved_suggestions_screen.dart';
import '../Screens/suggestions_screen.dart';
import '../data/util.dart';
import '../data/global_data.dart' as global_data;
import '../data/login_data.dart' as login_data;

class LoginScreen extends StatefulWidget {
  final AuthRepository _authRepository;
  final SavedSuggestionsStore _savedSuggestions;
  LoginScreen(this._authRepository, this._savedSuggestions);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _txtEmail = TextEditingController(text: login_data.emptyString);
  TextEditingController _txtPassword = TextEditingController(text: login_data.emptyString);

  String? _lastButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(login_data.appBarLogin,
          style: TextStyle(color: global_data.secondaryColor)
        ),
      ),
      body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: global_data.paddingSize),
              child: Text(login_data.welcomeMessage,
                  style: TextStyle(fontSize: global_data.fontSize),
                  textAlign: TextAlign.center
              ),
            ),
            Padding(
              child: TextField(
                controller: _txtEmail,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: login_data.initialHintEmail),
              ),
              padding: EdgeInsets.all(global_data.paddingSize),
            ),
            Padding(
              child: TextField(
                controller: _txtPassword,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: login_data.initialHintPassword),
              ),
              padding: EdgeInsets.all(global_data.paddingSize),
            ),
            widget._authRepository.status == Status.Authenticating && _lastButtonPressed == login_data.loginButton ?
              Center(child: CircularProgressIndicator()) :
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tryLogin();
                    _lastButtonPressed = login_data.loginButton; // Set the last button pressed to 'login'
                  });
                },
                child: Text(login_data.loginButtonText),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                ),
              ),
            widget._authRepository.status == Status.Authenticating && _lastButtonPressed == login_data.signUpButton ?
            Center(child: CircularProgressIndicator()) :
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _trySignIn();
                  _lastButtonPressed = login_data.signUpButton; // Set the last button pressed to 'signup'
                });
              },
              child: Text(login_data.signupButtonText),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 40),
              ),
            ),
          ],
        )
      );
  }

  void _tryLogin() async{
    if (await widget._authRepository.signIn(_txtEmail.text, _txtPassword.text)){
      await widget._savedSuggestions.pullSaved();
      await widget._savedSuggestions.pushSaved();
      Navigator.of(context).pop(context);
    } else {
      setState(() {
        displaySnackBar(context, login_data.loginSnackbarErrorMessage);
      });
    }
  }

  void _trySignIn() async{
    if (await widget._authRepository.signUp(_txtEmail.text, _txtPassword.text) != null){
      Navigator.of(context).pop(context);
    } else {
      displaySnackBar(context, login_data.loginSnackbarErrorMessage);
    }
  }
}
