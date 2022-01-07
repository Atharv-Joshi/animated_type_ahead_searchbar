import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String text;
  const Home({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
