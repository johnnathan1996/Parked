import 'package:flutter/material.dart';

const Blauw = Color(0xff79A5FF);
const Zwart = Color(0xff333545);
const Wit = Color(0xFFFFFFFF);
const Grijs = Color(0xFFCCCACA);
const LichtGrijs = Color(0xFFFAFAFA);

const Transparant = Color(0x00FFFFFF);

const TitleCustom =
    TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500, color: Zwart);

const SubTitleCustom =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: Zwart);

const SizeParagraph =
    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: Zwart);

const ShowPriceStyle =
    TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500, color: Zwart);

const ChatStyle = TextStyle(fontSize: 14.0, color: Grijs);

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
