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
  //(Anything UI related best create here define here***)
  // text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  //futures to lead graph data
  Future<Map<int, double>>? _monthlyTotalsFuture;

  // to read the expenses from DB we need a provider
  @override
  void initState() {
    //read db on initial startup
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();

    // load futures;
    refreshGraphData();

    super.initState();
  }

  //refresh graph data
  void refreshGraphData() {
    _monthlyTotalsFuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calculateMonthlyTotals();
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
      builder: (context, value, child) {
        // Get dates
        int startMonth = value.getStartMonth();
        int startYear = value.getStartYear();
        int currentMonth = DateTime.now().month;
        int currentYear = DateTime.now().year;

        //Cal number of month since the first month
        int monthCount = calculateMonthCount(
            startYear, startMonth, currentYear, currentMonth);
        //only display the expenses for the current month

        //return UI
        return Scaffold(
          backgroundColor: Colors.grey.shade300,
          floatingActionButton: FloatingActionButton(
            onPressed: openNewExpenseBox,
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: Column(
              children: [
                //Graph UI
                SizedBox(
                  height: 250,
                  child: FutureBuilder(
                    future: _monthlyTotalsFuture,
                    builder: (context, snapshot) {
                      // Is data loaded ?
                      if (snapshot.connectionState == ConnectionState.done) {
                        final monthlyTotals = snapshot.data ?? {};

                        //create the list of monthly summary
                        List<double> monthlySummary = List.generate(
                            monthCount,
                            (index) =>
                                monthlyTotals[startMonth + index] ?? 0.0);

                        return MyBarGraph(
                            monthlySummary: monthlySummary,
                            startMonth: startMonth);
                      }
                      //loading...
                      else {
                        return const Center(
                          child: Text('Loading...'),
                        );
                      }
                    },
                  ),
                ),
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
                        onEditPressed: (context) =>
                            openEditBox(individualExpense),
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
      },
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
        //save only if all textfield are filled
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
          // refresh the graph
          refreshGraphData();

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
          // refresh the graph
          refreshGraphData();
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
        //refresh the graph
        refreshGraphData();
      },
      child: const Text('Delete'),
    );
  }
}
