import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import '../global/util.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

import '../Data/login_data.dart';
import '../firebase_wrapper/auth_repository.dart';
import '../Screens/saved_suggestions_screen.dart';
import '../Screens/suggestions_screen.dart';
import '../firebase_wrapper/storage_repository.dart';
import '../global/constants.dart' as gc; // GlobalConst


class LoginScreen extends StatefulWidget {
  final AuthRepository _authRepository;
  final SavedSuggestionsStore _savedSuggestions;
  LoginScreen(this._authRepository, this._savedSuggestions);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _txtEmail = TextEditingController(text: "");
  TextEditingController _txtPassword = TextEditingController(text: "");
  final LoginData loginData = LoginData();

  String? _lastButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loginData.appBarLogin,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: loginData.paddingSize),
              child: Text(loginData.welcomeMessage,
                  style: TextStyle(fontSize: loginData.fontSize),
                  textAlign: TextAlign.center
              ),
            ),
            Padding(
              child: TextField(
                controller: _txtEmail,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: loginData.initialHintEmail),
              ),
              padding: EdgeInsets.all(loginData.paddingSize),
            ),
            Padding(
              child: TextField(
                controller: _txtPassword,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: loginData.initialHintPassword),
              ),
              padding: EdgeInsets.all(loginData.paddingSize),
            ),
            widget._authRepository.status == Status.Authenticating && _lastButtonPressed == loginData.loginButton ?
              Center(child: CircularProgressIndicator()) :
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tryLogin();
                    _lastButtonPressed = loginData.loginButton; // Set the last button pressed to 'login'
                  });
                },
                child: Text(loginData.loginButtonText),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                ),
              ),
            widget._authRepository.status == Status.Authenticating && _lastButtonPressed == loginData.signUpButton ?
            Center(child: CircularProgressIndicator()) :
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _trySignIn();
                  _lastButtonPressed = loginData.signUpButton; // Set the last button pressed to 'signup'
                });
              },
              child: Text(loginData.signupButtonText),
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
      displaySnackBar(context, loginData.loginSnackbarErrorMessage);
    }
  }

  void _trySignIn() async{
    if (await widget._authRepository.signUp(_txtEmail.text, _txtPassword.text) != null){
      Navigator.of(context).pop(context);
    } else {
      displaySnackBar(context, loginData.loginSnackbarErrorMessage);
    }
  }
}
