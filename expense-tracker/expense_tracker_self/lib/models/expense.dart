import 'package:isar/isar.dart';

//This line is needed to generate isar file for Database
//Run cmd: dart run build_runner build
part 'expense.g.dart';

@Collection()
class Expense {
  Id id = Isar.autoIncrement; // 0,1,2,3...
  final String name;
  final double amount;
  final DateTime dateTime;

  Expense({
    required this.name,
    required this.amount,
    required this.dateTime,
  });
}
