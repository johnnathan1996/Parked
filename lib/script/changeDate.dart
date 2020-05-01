import 'dart:math';

double roundDouble(double value, int places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

String changeDate(DateTime date) {
  String result;

  result = date.day.toString() +
      "/" +
      date.month.toString() +
      "/" +
      date.year.toString();

  return result;
}

DateTime changeDatetimeToDatetime(DateTime date) {
  String seperatorDay = date.day < 10 ? "0" : '';
  String seperatorMonth = date.month < 10 ? "0" : '';

  String datum = date.year.toString() + seperatorMonth +
      date.month.toString() + seperatorDay +
      date.day.toString() + "000000";

  String dateWithT = datum.substring(0, 8) + 'T' + datum.substring(8);
  DateTime result = DateTime.parse(dateWithT);
  return result;
}

String changeDateWithTime(DateTime date) {
  String result;

  String seperator = date.minute < 10 ? ":0" : ":";

  result = date.day.toString() +
      "/" +
      date.month.toString() +
      "/" +
      date.year.toString() +
      " " +
      date.hour.toString() +
      seperator +
      date.minute.toString();

  return result;
}

String getTime(DateTime date) {
  String result;

  String seperator = date.minute < 10 ? ":0" : ":";

  result = date.hour.toString() + seperator + date.minute.toString();

  return result;
}

double calculatePrice(DateTime firstDate, DateTime secondDate, double price) {
  int timeInMinute = secondDate.difference(firstDate).inMinutes;

  double timeInHours = timeInMinute / 60;

  double result = timeInHours * price;

  return roundDouble(result, 2);
}
