import 'package:flutter/material.dart';

// Firebase
const String savedSuggestionsCollection = "saved_suggestions";
const String savedSuggestionsCollectionField = "Pair";
const String storageBucketPath = "gs://hellome-4ba07.appspot.com";
const String loggerIdentifier = "----------";
const String appTitle = "Startup Name Generator";


// Colors
const Color primaryColor = Colors.deepPurple;
const Color secondaryColor = Colors.white;
const Color removeSuggestionColor = Colors.red;

// Size
const double suggestionsPadding = 16;
const int generateMoreWords = 10;
const double edgeInsets = 16.0;
const  double fontSize = 16;
final double paddingSize = 16;
const TextStyle textFont = TextStyle(fontSize: fontSize);
const double confirmPasswordSheetSize = 250;

// Icons
const IconData favoriteIcon = Icons.star;
const IconData favoriteIconBorder = Icons.star_border;
const IconData unauthenticatedIcon = Icons.login;
const IconData authenticatedIcon = Icons.exit_to_app;
const IconData deleteIcon = Icons.delete;
const IconData expandIcon = Icons.expand_less;
const IconData minimizeIcon = Icons.expand_more;
