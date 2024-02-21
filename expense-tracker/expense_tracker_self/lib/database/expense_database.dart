import 'package:expense_tracker_self/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Expense> _allExpenses = [];

  /*
  S E T U P
  */

  // INITIALIZE DB
  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: directory.path);
  }

  /*
  G E T T E R S

  */
  List<Expense> get allExpense => _allExpenses;

  /*
  O P E R A T I O N (CRUD)
  */
  // Create - add a new expense
  Future<void> createNewExpense(Expense newExpense) async {
    // add to db
    await isar.writeTxn(
      () => isar.expenses.put(newExpense),
    );
    // re-read from db
    await readExpenses();
  }

  // Read - expenses from db
  Future<void> readExpenses() async {
    // ferch all esxisting expense from db
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    // give to local expense list
    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);
    //update UI
    notifyListeners();
  }

  //Update - edit an expense in db

  Future<void> updateExpense(int id, Expense updatedExpense) async {
    //make sure new expense has same id as existing one
    updatedExpense.id = id;
    //save changes in db
    await isar.writeTxn(
      () => isar.expenses.put(updatedExpense),
    );

    //re-read from db
    await readExpenses();
  }

  // Delete - an expense
  Future<void> deleteExpense(int id) async {
    //delete the selected item from db
    await isar.writeTxn(() => isar.expenses.delete(id));

    //re-read from db
    await readExpenses();
  }

  /*
  Helper function
  */

  //calculate total expense for each month
  Future<Map<int, double>> calculateMonthlyTotals() async {
    //ensure  data is loaded from database
    await readExpenses();
    //create a map with months as keys and initial value of 0.0
    Map<int, double> monthlyTotals = {};
    //January: 0.0, February: 0.0, March:
    for (var expense in _allExpenses) {
      // extract month of expense date
      int month = expense.dateTime.month;
      //add to list if not already there
      //Here. we also use If statement
      if (!monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = 0.0;
      }
      // monthlyTotals[month] ??= 0.0;

      //add expense amount to the total for the month
      monthlyTotals[month] = monthlyTotals[month]! + expense.amount;
    }
    return monthlyTotals;
  }

  // Get start month'
  int getStartMonth() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().month;
    }
    //sort expense by date to fix heir
    _allExpenses.sort(
      (a, b) => a.dateTime.compareTo(b.dateTime),
    );
    return _allExpenses.first.dateTime.month;
  }

  //Get start year
  int getStartYear() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().year;
    }
    _allExpenses.sort(
      (a, b) => a.dateTime.compareTo(b.dateTime),
    );
    return _allExpenses.first.dateTime.year;
  }
}
