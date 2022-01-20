import 'package:animated_type_ahead_searchbar/animated_type_ahead_searchbar.dart';
import 'package:animated_type_ahead_searchbar_example/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List searchData = const [
    'Steel Pan',
    'Harp',
    'Cake',
    'Maracas',
    'Clarinet',
    'Odyssey',
    'Slide Whistle',
    'Piano',
  ];
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: AnimatedTypeAheadSearchBar(
            width: MediaQuery.of(context).size.width * 0.88,
            onSuffixTap: null,
            itemBuilder: (String suggestion) {
              return Material(
                color: Colors.white,
                borderOnForeground: false,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          suggestion,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onSuggestionSelected: (suggestion) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(text: suggestion)));
              FocusScope.of(context).unfocus();
            },
            suggestionCallback: (String pattern) {
              List<String> suggestions = [];
              if (pattern.length < 2) return suggestions;
              for (var i = 0; i < searchData.length; i++) {
                if (searchData[i]
                    .toLowerCase()
                    .contains(pattern.toLowerCase())) {
                  suggestions.add(searchData[i]);
                }
              }
              return suggestions;
            },
          ),
        ),
      ),
    );
  }
}
