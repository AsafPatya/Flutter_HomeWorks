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
  final double fontSize = 16;
  final double paddingSize = 16;
  TextEditingController _txtEmail = TextEditingController(text: "");
  TextEditingController _txtPassword = TextEditingController(text: "");
  final LoginData loginData = LoginData();
  final AuthRepository _authRepository = AuthRepository.instance();

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
              padding: EdgeInsets.only(top: paddingSize),
              child: Text(loginData.welcomeMessage,
                  style: TextStyle(fontSize: fontSize),
                  textAlign: TextAlign.center
              ),
            ),
            Padding(
              child: TextField(
                controller: _txtEmail,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: loginData.initialHintEmail),
              ),
              padding: EdgeInsets.all(paddingSize),
            ),
            Padding(
              child: TextField(
                controller: _txtPassword,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: loginData.initialHintPassword),
              ),
              padding: EdgeInsets.all(paddingSize),
            ),
            ElevatedButton(
              onPressed: () {
                _tryLogin();
              },
              child: Text(loginData.loginButtonText),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 40),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _trySignIn();
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
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return RandomWordsScreen();})
      );
    } else {
      _showLoginSnackbar(context, loginData.loginSnackbarErrorMessage);
    }
  }

  void _trySignIn() async{
    if (await _authRepository.signUp(_txtEmail.text, _txtPassword.text) != null){
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return RandomWordsScreen();})
      );
    } else {
      _showLoginSnackbar(context, loginData.loginSnackbarErrorMessage);
    }
  }
}
