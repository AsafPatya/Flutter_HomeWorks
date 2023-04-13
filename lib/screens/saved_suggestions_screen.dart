import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import '../data/util.dart';
import '../firebase_wrapper/storage_repository.dart';
import '../data/global_data.dart' as global_data; // GlobalConst
import '../data/saved_suggestions_data.dart' as saved_suggestions_data;

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
          style: global_data.textFont,
        ),
      ),
      key: ValueKey<String>(pair),
      background: Container(
        color: global_data.removeSuggestionColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(global_data.deleteIcon,
              color: global_data.secondaryColor,
            ),
          ],
        ),
      ),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart || direction == DismissDirection.startToEnd) {
          displayAlertDialog(context, saved_suggestions_data.deleteSuggestion, saved_suggestions_data.deleteSuggestionAlert.replaceFirst("%", pair),
              <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget._savedSuggestions.deletePair(pair);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(saved_suggestions_data.yes),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: global_data.primaryColor
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  } ,
                  child: Text(saved_suggestions_data.no),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: global_data.primaryColor
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
        title: const Text(saved_suggestions_data.savedSuggestions),
      ),
      body: ListView(children: divided),
      // Show Snackbar when Login button is pressed
    );
  }
}

