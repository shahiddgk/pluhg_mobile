import 'package:intl/intl.dart';

var months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
String formatDate(DateTime date) {
  final timeFormat = DateFormat.jm();
  String year = date.year.toString();
  String month = months[date.month - 1];
  String day = date.day.toString();
  String time = timeFormat.format(date);

  String dateString = "${month + " " + day + ", " + year + " " + time}";
  print(dateString); // something like 2013-04-20
  return dateString;
}
