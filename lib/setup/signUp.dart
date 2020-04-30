import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/pages/maps.dart';
import 'package:flutter/services.dart';
import 'package:parkly/ui/button.dart';
import 'package:parkly/ui/modal.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../setup/globals.dart' as globals;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

//TODO: add age and gender

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _lastName, _email, _password, _passwordConfirm;

  String phoneNo, smsCode, verificationId, errorMessage;
  bool codeSent = false;
  String phoneIsoCode;

  bool validation = true;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    if (this.mounted) {
      setState(() {
        phoneNo = number;
        phoneIsoCode = isoCode;
        if (phoneIsoCode == "BE") {
          phoneNo = "+32" + phoneNo;
        } else if (phoneIsoCode == "FR") {
          phoneNo = "+33" + phoneNo;
        } else if (phoneIsoCode == "NL") {
          phoneNo = "+31" + phoneNo;
        }
      });
    }
  }

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
                            validator: (input) {
                              if (input.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (input) => _name = input,
                            decoration: InputDecoration(
                                errorStyle: TextStyle(height: 0),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                prefixIcon: IconButton(
                                  icon:
                                      Icon(Icons.person_outline, color: Zwart),
                                  onPressed: () {},
                                ),
                                filled: true,
                                fillColor: Wit,
                                labelText: translate(Keys.Inputs_Firstname),
                                labelStyle: TextStyle(color: Zwart))))),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: Theme(
                        data: new ThemeData(hintColor: Transparant),
                        child: TextFormField(
                          validator: (input) {
                            if (input.isEmpty) {
                              if (input.isEmpty) {
                                return '';
                              }
                            }
                            return null;
                          },
                          onSaved: (input) => _lastName = input,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(height: 0),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.person_outline, color: Zwart),
                                onPressed: () {},
                              ),
                              filled: true,
                              fillColor: Wit,
                              labelText: translate(Keys.Inputs_Lastname),
                              labelStyle: TextStyle(color: Zwart)),
                        ))),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: Theme(
                        data: new ThemeData(hintColor: Transparant),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (input) {
                            if (input.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          onSaved: (input) => _email = input,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(height: 0),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.mail_outline, color: Zwart),
                                onPressed: () {},
                              ),
                              filled: true,
                              fillColor: Wit,
                              labelText: translate(Keys.Inputs_Email),
                              labelStyle: TextStyle(color: Zwart)),
                        ))),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 11),
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        child: InternationalPhoneInput(
                            enabledCountries: ['+32', '+33', '+31'],
                            hintText: translate(Keys.Inputs_Phone),
                            errorText: translate(Keys.Errors_Badphone),
                            initialPhoneNumber: phoneNo,
                            onPhoneNumberChange: onPhoneNumberChange,
                            initialSelection: "BE"))),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: Theme(
                        data: new ThemeData(hintColor: Transparant),
                        child: TextFormField(
                          validator: (input) {
                            if (input.length < 6) {
                              return translate(Keys.Errors_Mincar);
                            }
                            return null;
                          },
                          onSaved: (input) => _password = input,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Wit),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.visibility_off, color: Zwart),
                                onPressed: () {},
                              ),
                              filled: true,
                              fillColor: Wit,
                              labelText: translate(Keys.Inputs_Password),
                              labelStyle: TextStyle(color: Zwart)),
                          obscureText: true,
                        ))),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: Theme(
                        data: new ThemeData(hintColor: Transparant),
                        child: TextFormField(
                          validator: (input) {
                            if (input.length < 6) {
                              return '';
                            }
                            return null;
                          },
                          onSaved: (input) => _passwordConfirm = input,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(height: 0),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.visibility_off, color: Zwart),
                                onPressed: () {},
                              ),
                              filled: true,
                              fillColor: Wit,
                              labelText: translate(Keys.Inputs_Confirmpassword),
                              labelStyle: TextStyle(color: Zwart)),
                          obscureText: true,
                        ))),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: ButtonComponent(
                        label: translate(Keys.Button_Add),
                        onClickAction: () {
                          signUp();
                        }))
              ],
            ),
          ),
        ));
  }

  void signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      if (phoneNo != null) {
        if (_password == _passwordConfirm && _password != "") {
          verifyPhone();
        } else {
          showDialog(
            context: context,
            builder: (_) => ModalComponent(
              modalTekst: translate(Keys.Modal_Samepassword),
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (_) => ModalComponent(
            modalTekst: translate(Keys.Modal_Nophone),
          ),
        );
      }
    }
  }

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context);
    };
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          },
          codeSent: smsSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: errorMessage == null
                ? Text(translate(Keys.Subtitle_Entersmscode),
                    textAlign: TextAlign.center)
                : Text(errorMessage),
            content: PinFieldAutoFill(
              decoration: BoxLooseDecoration(
                strokeColor: Zwart,
                enteredColor: Blauw,
                gapSpace: 5,
              ),
              onCodeSubmitted: (value) {
                this.smsCode = value;
              },
              onCodeChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => {Navigator.of(context).pop(), createUser()},
                  child: Text(translate(Keys.Button_Send)))
            ],
          );
        });
  }

  void createUser() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);

      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final FirebaseUser userData = await FirebaseAuth.instance.currentUser();

      try {
        await userData.linkWithCredential(credential);
        logIn();
      } catch (e) {
        handleError(e);
        print('errorCode: $e');
        userData.delete();
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => ModalComponent(modalTekst: e.message),
      );
    }
  }

  void logIn() async {
    final FirebaseUser userData = await FirebaseAuth.instance.currentUser();

    try {
      await Firestore.instance
          .collection('users')
          .document(userData.uid)
          .setData({
        'voornaam': _name,
        'achternaam': _lastName,
        'imgUrl':
            "https://firebasestorage.googleapis.com/v0/b/parkly-2f177.appspot.com/o/default-user-avatar.png?alt=media&token=9af11a8c-e2b6-4f7b-87b6-f656d705eb20",
        'email': _email,
        'nummer': phoneNo,
        'online': false,
        'position': {'latitude': 0.0, 'longitude': 0.0},
        'favoriet': [],
        'mijnGarage': [],
        'paymethode': []
      });

      if (this.mounted) {
        setState(() {
          globals.userId = userData.uid;
        });
      }

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MapsPage()));
    } catch (e) {
      print(e.message);
    }
  }

  handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        if (this.mounted) {
          setState(() {
            errorMessage = translate(Keys.Subtitle_Invalidcode);
          });
        }
        smsCodeDialog(context);
        break;
      case 'ERROR_CREDENTIAL_ALREADY_IN_USE':
        showDialog(
          context: context,
          builder: (_) =>
              ModalComponent(modalTekst: translate(Keys.Modal_Phoneexist)),
        );
        break;
      default:
        if (this.mounted) {
          setState(() {
            errorMessage = error.message;
          });
        }
        break;
    }
  }
}
