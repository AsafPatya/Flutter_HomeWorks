import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'Screens/startup_name_generator_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_wrapper/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    checkFirebase();
    return ChangeNotifierProvider(
      create: (ctx) => AuthRepository.instance(),
      child: MaterialApp(
        title: 'Startup Name Generator',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        home: RandomWordsScreen(),
      )
    );
  }
}

void checkFirebase() {
  FirebaseApp app = Firebase.app();
  FirebaseOptions options = app.options;
  if (options != null) {
    print('Firebase is connected to ${options.projectId}');
  } else {
    print('Firebase is not connected');
  }
}



