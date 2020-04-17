import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkly/setup/logIn.dart';

Future<void> logOut(context) async {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LogInPage()));

  await FirebaseAuth.instance.signOut();
}
