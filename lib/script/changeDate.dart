import 'dart:math';

double roundDouble(double value, int places){ 
   double mod = pow(10.0, places); 
   return ((value * mod).round().toDouble() / mod); 
}

String changeDate(var date) {
  String result;
  DateTime datum = date.toDate();

  result = datum.day.toString() +
      "/" +
      datum.month.toString() +
      "/" +
      datum.year.toString();

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

double calculatePrice(DateTime firstDate, DateTime secondDate, double price) {

  int timeInMinute = secondDate.difference(firstDate).inMinutes;
  
  double timeInHours = timeInMinute / 60;

  double result = timeInHours * price;

  return roundDouble(result, 2);
}
