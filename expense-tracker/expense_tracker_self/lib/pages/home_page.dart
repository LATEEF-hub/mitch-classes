import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends  State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Color.fromARGB(199, 208, 203, 196),
    body: Center(child: Text('hello'),),);
  }
}