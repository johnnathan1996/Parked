import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

String getMonth(int grade) {
  switch (grade) {
    case 1:
      {
        return translate(Keys.Monthsname_January);
      }
      break;

    case 2:
      {
        return translate(Keys.Monthsname_February);
      }
      break;

    case 3:
      {
        return translate(Keys.Monthsname_March);
      }
      break;

    case 4:
      {
        return translate(Keys.Monthsname_April);
      }
      break;

    case 5:
      {
        return translate(Keys.Monthsname_May);
      }
      break;

    case 6:
      {
        return translate(Keys.Monthsname_June);
      }
      break;

    case 7:
      {
        return translate(Keys.Monthsname_July);
      }
      break;

    case 8:
      {
        return translate(Keys.Monthsname_August);
      }
      break;

    case 9:
      {
        return translate(Keys.Monthsname_September);
      }
      break;

    case 10:
      {
        return translate(Keys.Monthsname_October);
      }
      break;

    case 11:
      {
        return translate(Keys.Monthsname_November);
      }
      break;

    case 12:
      {
        return translate(Keys.Monthsname_December);
      }
      break;

    default:
      {
        return translate(Keys.Modal_Wrong);
      }
      break;
  }
}
