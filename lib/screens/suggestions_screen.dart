import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'saved_suggestions_screen.dart';
import '../Data/suggestions_data.dart';
import '../firebase_wrapper/auth_repository.dart';
import '../firebase_wrapper/storage_repository.dart';
import '../global/util.dart';
import '../global/resources.dart';
import '../global/constants.dart' as gc; // GlobalConst


class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final _suggestions = <WordPair>[];

  void _showSavedSuggestionSnackbar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Deletion is not implemented yet'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _pushSaved(SavedSuggestionsStore savedSuggestions){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return SavedSuggestionsScreen(savedSuggestions);
        }
      )
    );
  }

  void _pushLogin(AuthRepository authRepository, SavedSuggestionsStore savedSuggestions){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return LoginScreen(authRepository, savedSuggestions);
        }
      )
    );
  }

  void _pushLogout(AuthRepository authRepository, SavedSuggestionsStore savedSuggestions){
    authRepository.signOut();
    savedSuggestions.clearPairs(context);
    displaySnackBar(context, strLOGOUT_SUCCESSFULLY);
  }

  Widget _buildRow(String pair, SavedSuggestionsStore _savedSuggestions) {
    if (_savedSuggestions.saved == null) {
      return Container();
    }
    final alreadySaved = _savedSuggestions.saved!.contains(pair);
    return ListTile(
      title: Text(
        pair,
        style: gc.biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? gc.favoriteIcon : gc.favoriteIconBorder,
        color: alreadySaved ? gc.primaryColor : null,
        semanticLabel: alreadySaved ? strREMOVED_FROM_SAVED : strSAVE,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedSuggestions.deletePair(pair);
          } else {
            _savedSuggestions.addPair(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthRepository, SavedSuggestionsStore>(
        builder: (context, authRepository, savedSuggestions, child){
          return Scaffold(
              appBar: AppBar(
                title: Text(strAPP_TITLE),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: () {
                          _pushSaved(savedSuggestions);
                    },
                    tooltip: 'Saved Suggestions',
                  ),
                  authRepository.status == Status.Authenticated
                      ? IconButton(
                          icon: const Icon(Icons.exit_to_app),
                          onPressed: (){
                            setState(() {
                                _pushLogout(authRepository, savedSuggestions);
                            });
                          }
                      )
                      : IconButton(
                          icon: const Icon(Icons.login),
                          onPressed: () => _pushLogin(authRepository, savedSuggestions),
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

                  return _buildRow(_suggestions[index].asPascalCase.toString(), savedSuggestions);
                },
              )
          );
        }
    );
  }
}