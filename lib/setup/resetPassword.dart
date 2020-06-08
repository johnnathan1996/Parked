import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:Parked/constant.dart';
import 'package:Parked/ui/button.dart';
import 'package:Parked/ui/modal.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:Parked/localization/keys.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';

  bool showFrom = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Transparant,
            iconTheme: IconThemeData(color: Wit)),
        body: Container(
            decoration: BoxDecoration(
                image: new DecorationImage(
                    image: new AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover)),
            child: showFrom
                ? Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 100.0, right: 100.0, bottom: 30.0),
                            child: Image(
                              image: AssetImage('assets/images/logo.png'),
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 30.0),
                            child: Text(
                              translate(Keys.Inputs_Changepassword),
                              style: TextStyle(
                                  color: Wit,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return "Stel uw Email in.";
                                }
                                return null;
                              },
                              onSaved: (input) => _email = input,
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Wit),
                                  border: OutlineInputBorder(),
                                  prefixIcon: IconButton(
                                    icon:
                                        Icon(Icons.mail_outline, color: Zwart),
                                    onPressed: () {},
                                  ),
                                  filled: true,
                                  fillColor: Wit,
                                  labelText: translate(Keys.Inputs_Email),
                                  labelStyle: TextStyle(color: Zwart)),
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 10.0),
                            child: ButtonComponent(
                                label: translate(Keys.Button_Resetpassword),
                                onClickAction: () {
                                  changePassword(context);
                                }))
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Lottie.asset('assets/anim/success.json',
                            repeat: false, width: 100, height: 100),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10, bottom: 20),
                            child: Text(
                              translate(Keys.Apptext_Emailsend) + ' $_email',
                              style: TextStyle(
                                  color: Wit,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                              textAlign: TextAlign.center,
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ButtonComponent(
                                label: translate(Keys.Button_Back),
                                onClickAction: () {
                                  Navigator.of(context).pop();
                                }))
                      ],
                    ),
                  )));
  }

  void changePassword(context) async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _email)
            .whenComplete(() {
          if (this.mounted) {
            setState(() {
              showFrom = false;
            });
          }
        });
      } catch (e) {
        print(e.message);
        showDialog(
          context: context,
          builder: (_) =>
              ModalComponent(modalTekst: translate(Keys.Modal_Unexistemail)),
        );
      }
    }
  }
}
