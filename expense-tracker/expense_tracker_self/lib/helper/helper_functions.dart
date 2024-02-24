/*

Helpful functions used across the app
*/
// use this package for number format and currency
import 'package:intl/intl.dart';

//convert string to double
double convertStringToDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

//Format double amount into dollars & cents
String formatAmount(double amount) {
  final format =
      NumberFormat.currency(locale: 'en-us', symbol: '\$', decimalDigits: 2);
  return format.format(amount);
}

//calculate the number of months since the first start month
int calculateMonthCount(int startYear, startMonth, currentYear, currentMonth) {
  int monthCount =
      (currentYear - startYear) * 12 + currentMonth - startMonth + 1;
  return monthCount;
}

String getCurrentMonthName() {
  DateTime now = DateTime.now();
  List<String> months = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "SEP",
    "OCT",
    "NOV",
    "DEC",
  ];
  return months[now.month - 1];
}
