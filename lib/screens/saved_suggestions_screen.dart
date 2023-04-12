import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import '../global/resources.dart';
import '../global/util.dart';
import '../global/constants.dart';
import '../firebase_wrapper/storage_repository.dart';
import '../global/constants.dart' as gc; // GlobalConst

class SavedSuggestionsScreen extends StatefulWidget {
  final SavedSuggestionsStore _savedSuggestions;
  SavedSuggestionsScreen(this._savedSuggestions);

  @override
  State<SavedSuggestionsScreen> createState() => _SavedSuggestionsScreenState();
}

class _SavedSuggestionsScreenState extends State<SavedSuggestionsScreen> {

  Widget _buildSavedSuggestions(BuildContext context, String pair){
    return Dismissible(
      child: ListTile(
        title: Text(pair,
          style: biggerFont,
        ),
      ),
      key: ValueKey<String>(pair),
      background: Container(
        color: gc.removeSuggestionColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(gc.deleteIcon,
              color: gc.secondaryColor,
            ),
          ],
        ),
      ),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart || direction == DismissDirection.startToEnd) {
          displayAlertDialog(context, strDELETE_SUGGESTION, strDELETE_SUGGESTION_ALERT.replaceFirst("%", pair),
              <Widget>[
                ElevatedButton(
                  onPressed: (){} ,
                  child: Text(strYES),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor
                  ),
                ),
                ElevatedButton(
                  onPressed: (){} ,
                  child: Text(strNO),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor
                  ),
                ),
              ]
          );
          return false;
        }
      },


    );
  }

  @override
  Widget build(BuildContext context) {
    Set<String>? saved = widget._savedSuggestions.saved;
    if (saved == null){
      return Container();
    }
    final tiles = saved.map( (pair) {
        return _buildSavedSuggestions(context, pair);
      }
    );

    final divided = tiles.isNotEmpty ? ListTile.divideTiles(context: context, tiles: tiles).toList() : <Widget>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Suggestions'),
      ),
      body: ListView(children: divided),
      // Show Snackbar when Login button is pressed
    );
  }
}

