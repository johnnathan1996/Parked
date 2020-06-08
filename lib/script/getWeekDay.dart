import 'package:flutter_translate/flutter_translate.dart';
import 'package:Parked/localization/keys.dart';

String getWeekDay(int grade) {
  switch (grade) {
    case 1:
      {
        return translate(Keys.Weekdays_Monday);
      }
      break;

    case 2:
      {
        return translate(Keys.Weekdays_Tuesday);
      }
      break;

    case 3:
      {
        return translate(Keys.Weekdays_Wednesday);
      }
      break;

    case 4:
      {
        return translate(Keys.Weekdays_Thursday);
      }
      break;

    case 5:
      {
        return translate(Keys.Weekdays_Friday);
      }
      break;

    case 6:
      {
        return translate(Keys.Weekdays_Saturday);
      }
      break;

    case 7:
      {
        return translate(Keys.Weekdays_Sunday);
      }
      break;

    default:
      {
        return translate(Keys.Modal_Wrong);
      }
      break;
  }
}
