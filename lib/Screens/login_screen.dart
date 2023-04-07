import 'package:flutter/material.dart';
import '../Data/login.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double fontSize = 16;
  final double paddingSize = 16;
  final TextEditingController txtHeight = TextEditingController();
  final TextEditingController txtWeight = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Login login = Login();
    return Scaffold(
      appBar: AppBar(
        title: Text(login.appBarLogin,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: paddingSize),
              child: Text(login.welcomeMessage,
                  style: TextStyle(fontSize: fontSize),
                  textAlign: TextAlign.center
              ),
            ),
            Padding(
              child: TextField(
                controller: txtHeight,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: login.initialHintEmail),
              ),
              padding: EdgeInsets.all(paddingSize),
            ),
            Padding(
              child: TextField(
                controller: txtWeight,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: login.initialHintPassword),
              ),
              padding: EdgeInsets.all(paddingSize),
            ),
            ElevatedButton(
              onPressed: () {
                _showLoginSnackbar(context);
              },
              child: Text(login.loginButtonText),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40), // Sets the horizontal padding
              ),
            ),
          ],
        )
      );
  }
  void _showLoginSnackbar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Login is not implemented yet'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
