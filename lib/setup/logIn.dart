import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkly/pages/maps.dart';
import 'package:parkly/setup/resetPassword.dart';
import 'package:parkly/setup/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/ui/button.dart';
import 'package:parkly/ui/modal.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String _email, _password;

  bool hiddenPassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover)),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        left: 100.0, right: 100.0, bottom: 50.0),
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: Theme(
                        data: new ThemeData(hintColor: Transparant),
                        child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) {
                        if (input.isEmpty) {
                          return translate(Keys.Errors_Mailempty);
                        }
                        return null;
                      },
                      onSaved: (input) => _email = input,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Wit),
                        border: OutlineInputBorder(),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.person_outline, color: Zwart),
                            onPressed: () {},
                          ),
                          filled: true,
                          fillColor: Wit,
                          labelText: translate(Keys.Inputs_Email),
                          labelStyle: TextStyle(color: Zwart)),
                    ))),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Theme(
                        data: new ThemeData(hintColor: Transparant),
                        child: TextFormField(
                      onSaved: (input) => _password = input,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.vpn_key,
                            color: Zwart,
                          ),
                          onPressed: () {},
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.visibility,
                            color: Zwart,
                          ),
                          onPressed: () {
                            if (this.mounted) {
                              setState(() {
                                hiddenPassword = !hiddenPassword;
                              });
                            }
                          },
                        ),
                        filled: true,
                        fillColor: Wit,
                        labelText: translate(Keys.Inputs_Password),
                        labelStyle: TextStyle(color: Zwart),
                      ),
                      obscureText: hiddenPassword,
                    ))),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPassword(),
                                fullscreenDialog: true));
                      },
                      child: Text(translate(Keys.Button_Forgotpassword),
                          style: TextStyle(
                              color: Wit,
                              decoration: TextDecoration.underline)),
                    )),
                Padding(
                  padding:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  child: ButtonComponent(
                      label: translate(Keys.Button_Login),
                      onClickAction: () {
                        signIn();
                      }),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Divider(
                        color: Wit,
                        thickness: 1,
                      )),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(translate(Keys.Button_Or), style: TextStyle(color: Wit)),
                      ),
                      Expanded(
                          child: Divider(
                        color: Wit,
                        thickness: 1,
                      )),
                    ])),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                                fullscreenDialog: true));
                      },
                      child: Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child:
                              Text(translate(Keys.Button_Createaccount), style: TextStyle(color: Blauw))),
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ));
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

        Firestore.instance
            .collection('users')
            .document(currentUser.uid)
            .updateData({"online": true});

        if (this.mounted) {
          setState(() {
            globals.userId = currentUser.uid;
          });
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MapsPage()));
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => ModalComponent(modalTekst: translate(Keys.Modal_Invalidemail)),
        );
      }
    }
  }
}
