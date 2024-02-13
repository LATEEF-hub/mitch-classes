import 'package:flutter/material.dart';

void main() {
  runApp( MyApp() );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  String name = "Toby";
  int age = 6;
  double change = 15.56;
  bool isMatured = false;

  //Store Key- values pairs
  Map user = {
    'name': 'Toby Lateef',
    'age': 33,
    'height': 1.75,
  };
  //Ordered List
  List<String> names = ["Ariana","Remilekun"];
  //Stored unordered list
  Set<String> uniqueNames = {"Moji", "Italy", "Pussy"};





 
  /*
    C O N T R O L F L O W
    if ( condition ) {
      do something;
    }

    if () {

    } else {
      do something
    }
  */

  @override
  Widget build(BuildContext context) {
    String grade = "F";

    if ( grade == "A" ) {
      print('Excellent');
    } else if ( grade == "B" ) {
      print('Great is your Good');
    } else if ( grade == "C") {
      print( 'Grade is Fair');
    } else if ( grade == "D") {
      print( 'Grade requires improvment' );
    } else if ( grade == "E") {
      print('Grade is Poor');
    } else {
      print( 'You are have failed woefully!!!');
    }


    switch (expression) {
      case value:
        
        break;
      default:
    }

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      ),
    );
  }
}