// import 'dart:js';

import 'package:expense_tracker_self/bar%20graph/bar_graph.dart';
import 'package:expense_tracker_self/database/expense_database.dart';
import 'package:expense_tracker_self/helper/helper_functions.dart';
import 'package:expense_tracker_self/models/expense.dart';
import 'package:expense_tracker_self/components/my_list_tile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //(Anything UI related best create here***)
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

  // open new expense box
  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //user input -> expense name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  alignLabelWithHint: false, hintText: 'Name'),
            ),
            // user input -> expense amount
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: 'Amount'),
            ),
          ],
        ),
        actions: [
          //cancel button
          _cancelButton(),

          //save button
          _createNewExpenseButton(),
        ],
      ),
    );
  }

  // open edit box
  void openEditBox(Expense expense) {
    //prefill values into textfields
    String existingName = expense.name;
    String existingAmount = expense.amount.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //user input -> expense name
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: existingName),
            ),
            // user input -> expense amount
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: existingAmount),
            ),
          ],
        ),
        actions: [
          //cancel button
          _cancelButton(),

          //save button
          _editExpenseButton(expense),
        ],
      ),
    );
  }

  // open delete box
  void openDeleteBox(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense'),
        actions: [
          //cancel button
          _cancelButton(),

          //save button
          _deleteExpenseButton(expense.id),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) =>
          // Get dates
          //Cal number of month since the first month
          //only display the expenses for the current month
          Scaffold(
        backgroundColor: const Color.fromARGB(255, 191, 221, 192),
        floatingActionButton: FloatingActionButton(
          onPressed: openNewExpenseBox,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            //Graph Bar UI
            MyBarGraph(monthlySummary: monthlySummary, startMonth: startMonth),
            //Expense LIST UI
            Expanded(
              child: ListView.builder(
                itemCount: value.allExpense.length,
                itemBuilder: (context, index) {
                  //get individual expense
                  Expense individualExpense = value.allExpense[index];
                  //return list tile UI
                  return MyListTile(
                    title: individualExpense.name,
                    trailing: formatAmount(individualExpense.amount),
                    onEditPressed: (context) => openEditBox(individualExpense),
                    onDeletePressed: (context) =>
                        openDeleteBox(individualExpense),
                  );
                },
              ),
            ),
          ],
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

  //SAVE BUTTON -> Edit existing expense

  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        //save as long as at least one textfield is modified
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          //pop box
          Navigator.pop(context);

          //create a new updated expense
          Expense updatedExpense = Expense(
            name: nameController.text.isNotEmpty
                ? nameController.text
                : expense.name,
            amount: amountController.text.isNotEmpty
                ? convertStringToDouble(amountController.text)
                : expense.amount,
            dateTime: DateTime.now(),
          );
          // old expense id(To keep the Id same while updating an item)
          int existingId = expense.id;
          //update the database with the new data
          await context
              .read<ExpenseDatabase>()
              .updateExpense(existingId, updatedExpense);
        }
      },
      child: const Text('Save'),
    );
  }

  // DELETE BUTTON
  Widget _deleteExpenseButton(int id) {
    return MaterialButton(
      onPressed: () async {
        // pop box
        Navigator.pop(context);
        // delete expense from db
        await context.read<ExpenseDatabase>().deleteExpense(id);
      },
      child: const Text('Delete'),
    );
  }
}
