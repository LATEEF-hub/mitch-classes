// import 'dart:js';

import 'package:expense_tracker_self/database/expense_database.dart';
import 'package:expense_tracker_self/helper/helper_functions.dart';
import 'package:expense_tracker_self/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // to read the expenses from DB
  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    super.initState();
  }

  // open new expense box (Anything UI related best create here***)
  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  alignLabelWithHint: false, hintText: 'Enter name of expense'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: 'Enter Amount'),
            ),
            TextField(
              autocorrect: true,
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Enter Notes'),
            ),
          ],
        ),
        actions: [
          //cancel button
          _cancelButton(),

          //save button
          _createNewExpenseButton()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: openNewExpenseBox,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.allExpense.length,
          itemBuilder: (context, index) {
            //get individual expense
            Expense individualExpense = value.allExpense[index];

            //return list tile UI
            return ListTile(
              title: Text(individualExpense.name),
              trailing: Text(individualExpense.amount.toString()),
            );
          },
        ),
      ),
    );
  }

  //cancel button
  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        //pop box
        Navigator.pop(context);
        //clear controllers
        nameController.clear();
        amountController.clear();
      },
      child: const Text('Cancel'),
    );
  }

  //Save button => Create a new expense
  Widget _createNewExpenseButton() {
    return MaterialButton(
      onPressed: () async {
        //save on;y if all textfield are filled
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          //pop box
          Navigator.pop(context);
          //create new expense
          Expense newExpense = Expense(
            name: nameController.text,
            amount: convertStringToDouble(amountController.text),
            dateTime: DateTime.now(),
          );
          //save to db
          await context.read<ExpenseDatabase>().createNewExpense(newExpense);

          //clear controllers
          amountController.clear();
          nameController.clear();
        }
      },
      child: const Text("Create"),
    );
  }
}
