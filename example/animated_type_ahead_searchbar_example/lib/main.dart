import 'dart:developer';

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
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: AnimatedTypeAheadSearchBar(
            width: MediaQuery.of(context).size.width * 0.88,
            searchData: const [
              'Rohit',
              'Atharv',
              'Akshay',
              'Nipur',
              'Nikant',
              'Ninad'
            ],
            onSuffixTap: null,
            onListTileTap: (String suggestion) {
              log('tapped list tile : $suggestion');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(text: suggestion)));
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }
}
