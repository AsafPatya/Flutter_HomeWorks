import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'screens/suggestions_screen.dart';
import 'screens/login_screen.dart';
import 'firebase_wrapper/auth_repository.dart';
import 'firebase_wrapper/storage_repository.dart';
import 'data/global_data.dart' as global_data;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthRepository>(
              create: (_) => AuthRepository.instance()),
          ChangeNotifierProxyProvider<AuthRepository, SavedSuggestionsStore>(
            create: (BuildContext context) => SavedSuggestionsStore.instance(Provider.of<AuthRepository>(context, listen: false)),
            update: (BuildContext context, AuthRepository auth, SavedSuggestionsStore? saved) => saved!..updates(auth)
          )
        ],
        child: MaterialApp(
          title: global_data.appTitle,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: global_data.primaryColor,
              foregroundColor: global_data.secondaryColor,
            ),
          ),
          home:  SuggestionScreen(),
        ));
  }
}

