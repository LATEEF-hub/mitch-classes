import 'package:expense_tracker_self/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpenses = [];

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
}
