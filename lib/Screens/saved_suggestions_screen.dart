import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class SavedSuggestionsScreen extends StatefulWidget {
  var _saved = <WordPair>{};

  SavedSuggestionsScreen(this._saved);

  @override
  State<SavedSuggestionsScreen> createState() => _SavedSuggestionsScreenState();
}

class _SavedSuggestionsScreenState extends State<SavedSuggestionsScreen> {
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final tiles = widget._saved.map(
          (pair) {
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
              // User swiped from right to left or left to right (i.e. dismissed the item)
              _showSavedSuggestionSnackbar(context);
              return false;
            }
          },

          child: ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
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
  void _showSavedSuggestionSnackbar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Deletion is not implemented yet'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

