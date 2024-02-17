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

String formatAmount(double amount) {
  final format =
      NumberFormat.currency(locale: 'en-us', symbol: '\$', decimalDigits: 2);
  return format.format(amount);
}
