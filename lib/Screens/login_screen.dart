import 'package:flutter/material.dart';
import '../Data/login_data.dart';
import '../firebase_wrapper/auth_repository.dart';
import '../Screens/saved_suggestions_screen.dart';
import 'package:english_words/english_words.dart';
import '../Screens/startup_name_generator_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _txtEmail = TextEditingController(text: "");
  TextEditingController _txtPassword = TextEditingController(text: "");
  final LoginData loginData = LoginData();
  final AuthRepository _authRepository = AuthRepository.instance();
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
            _authRepository.status == Status.Authenticating && _lastButtonPressed == 'login'?
              Center(child: CircularProgressIndicator()) :
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tryLogin();
                    _lastButtonPressed = 'login'; // Set the last button pressed to 'login'
                  });
                },
                child: Text(loginData.loginButtonText),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                ),
              ),
            _authRepository.status == Status.Authenticating && _lastButtonPressed == 'signup'?
            Center(child: CircularProgressIndicator()) :
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _trySignIn();
                  _lastButtonPressed = 'signup'; // Set the last button pressed to 'signup'
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

  void _showLoginSnackbar(BuildContext context, String textToShow) {
    final snackBar = SnackBar(content: Text(textToShow));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _tryLogin() async{
    if (await _authRepository.signIn(_txtEmail.text, _txtPassword.text)){
      Navigator.of(context).pop(context);
    } else {
      _showLoginSnackbar(context, loginData.loginSnackbarErrorMessage);
    }
  }

  void _trySignIn() async{
    if (await _authRepository.signUp(_txtEmail.text, _txtPassword.text) != null){
      Navigator.of(context).pop(context);
    } else {
      _showLoginSnackbar(context, loginData.loginSnackbarErrorMessage);
    }
  }
}
