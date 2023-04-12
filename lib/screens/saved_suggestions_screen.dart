import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import '../global/resources.dart';
import '../global/util.dart';
import '../global/constants.dart';

class SavedSuggestionsScreen extends StatefulWidget {
  var _saved = <WordPair>{};

  SavedSuggestionsScreen(this._saved);

  @override
  State<SavedSuggestionsScreen> createState() => _SavedSuggestionsScreenState();
}

class _SavedSuggestionsScreenState extends State<SavedSuggestionsScreen> {

  @override
  Widget build(BuildContext context) {
    final tiles = widget._saved.map( (pair) {
        return Dismissible(
          key: Key(pair.toString()),
          background: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          direction: DismissDirection.horizontal,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart || direction == DismissDirection.startToEnd) {
              displayAlertDialog(context, strDELETE_SUGGESTION, strDELETE_SUGGESTION_ALERT.replaceFirst("%", pair.asPascalCase),
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

          child: ListTile(
            title: Text(
              pair.asPascalCase,
              style: biggerFont,
            ),
          ),
        );
      },
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

