import 'dart:async';

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
  Future<Map<String, double>> calculateMonthlyTotals() async {
    //ensure  data is loaded from database
    await readExpenses();
    //create a map with months as keys and initial value of 0.0
    Map<String, double> monthlyTotals = {};
    //January: 0.0, February: 0.0, March:
    for (var expense in _allExpenses) {
      // extract year & month of expense date
      String yearMonth = '${expense.dateTime.year}-${expense.dateTime.month}';
      //add to list if not already there
      //Here. we also use If statement
      if (!monthlyTotals.containsKey(yearMonth)) {
        monthlyTotals[yearMonth] = 0.0;
      }
      // monthlyTotals[month] ??= 0.0;

      //add expense amount to the total for the month
      monthlyTotals[yearMonth] = monthlyTotals[yearMonth]! + expense.amount;
    }
    return monthlyTotals;
  }

  //Calculate current month total
  Future<double> calculateCurrentMonthTotal() async {
    //ensure expense are read from rd first
    await readExpenses();
    //get current and year
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;
    // firlst the ex to include only this for this mon this yea
    List<Expense> currentMonthExpenses = _allExpenses.where((expense) {
      return expense.dateTime.month == currentMonth &&
          expense.dateTime.year == currentYear;
    }).toList();

    //cal total amount for the current month
    double totalForThisMonth =
        currentMonthExpenses.fold(0, (sum, expense) => sum + expense.amount);

    return totalForThisMonth;
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
