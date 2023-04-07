import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'login_screen.dart';
import 'saved_suggestions_screen.dart';

class RandomWordsScreen extends StatefulWidget {
  const RandomWordsScreen({Key? key}) : super(key: key);

  @override
  State<RandomWordsScreen> createState() => _RandomWordsScreenState();
}

class _RandomWordsScreenState extends State<RandomWordsScreen> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  void _showSavedSuggestionSnackbar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Deletion is not implemented yet'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void _pushSaved1() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
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
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
            // Show Snackbar when Login button is pressed
          );
        },
      ),
    );
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
          IconButton(
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
}