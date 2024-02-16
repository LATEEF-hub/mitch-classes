import 'package:expense_tracker_self/database/expense_database.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize db
  await ExpenseDatabase.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ExpenseDatabase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
