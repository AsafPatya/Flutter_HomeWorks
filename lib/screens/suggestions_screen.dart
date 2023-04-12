import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'saved_suggestions_screen.dart';
import '../Data/suggestions_data.dart';
import '../firebase_wrapper/auth_repository.dart';
import '../global/util.dart';
import '../global/resources.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final _suggestions = <WordPair>[];
  var _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  final SuggestionsData suggestionsData = SuggestionsData();
  final AuthRepository authRepository = AuthRepository.instance();

  void _showSavedSuggestionSnackbar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Deletion is not implemented yet'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return SavedSuggestionsScreen(_saved);
        }
      )
    );
  }

  void _pushLogin(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return LoginScreen();
        }
      )
    );
  }

  void _pushLogout(){
    authRepository.signOut();
    _saved = <WordPair>{};
    displaySnackBar(context, strLOGOUT_SUCCESSFULLY);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(
        builder: (context, authRepository, child){
          return Scaffold(
              appBar: AppBar(
                title: Text(strAPP_TITLE),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: _pushSaved,
                    tooltip: 'Saved Suggestions',
                  ),
                  authRepository.status == Status.Authenticated
                      ? IconButton(
                          icon: const Icon(Icons.exit_to_app),
                          onPressed: _pushLogout,
                  )
                      : IconButton(
                          icon: const Icon(Icons.login),
                          onPressed: _pushLogin,
                  )
                ],
              ),
              body: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, i) {
                  if (i.isOdd) return const Divider();

                  final index = i ~/ 2;
                  if (index >= _suggestions.length) {
                    _suggestions.addAll(generateWordPairs().take(10));
                  }
                  final alreadySaved = _saved.contains(_suggestions[index]); // NEW
                  return ListTile(
                    title: Text(
                      _suggestions[index].asPascalCase,
                      style: _biggerFont,
                    ),
                    trailing: Icon(
                      alreadySaved ? Icons.favorite : Icons.favorite_border,
                      color: alreadySaved ? Colors.red : null,
                      semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                    ),
                    onTap: (){
                      setState(() {
                        if (alreadySaved){
                          _saved.remove(_suggestions[index]);
                        } else {
                          _saved.add(_suggestions[index]);
                        }
                      });
                    },
                  );
                },
              )
          );
        }
    );
  }
}