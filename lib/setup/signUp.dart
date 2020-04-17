import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/pages/maps.dart';
import 'package:flutter/services.dart';
import 'package:parkly/ui/button.dart';
import 'package:parkly/ui/modal.dart';
import '../setup/globals.dart' as globals;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _lastName, _email, _password, _passwordConfirm;

  String phoneNo, smsCode, verificationId, errorMessage;
  bool codeSent = false;
  String phoneIsoCode;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(elevation: 0.0, backgroundColor: Transparant, iconTheme: IconThemeData(color: Wit)),
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
                    child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Stel uw naam in.";
                          }
                          return null;
                        },
                        onSaved: (input) => _name = input,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              icon: Icon(Icons.person_outline, color: Zwart),
                              onPressed: () {},
                            ),
                            filled: true,
                            fillColor: Wit,
                            labelText: "Naam",
                            labelStyle: TextStyle(color: Zwart)))),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Stel uw achternaam in.";
                        }
                        return null;
                      },
                      onSaved: (input) => _lastName = input,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: IconButton(
                            icon: Icon(Icons.person_outline, color: Zwart),
                            onPressed: () {},
                          ),
                          filled: true,
                          fillColor: Wit,
                          labelText: "Achternaam",
                          labelStyle: TextStyle(color: Zwart)),
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
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
                          border: InputBorder.none,
                          prefixIcon: IconButton(
                            icon: Icon(Icons.mail_outline, color: Zwart),
                            onPressed: () {},
                          ),
                          filled: true,
                          fillColor: Wit,
                          labelText: "E-mailadres",
                          labelStyle: TextStyle(color: Zwart)),
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 11),
                        decoration: new BoxDecoration(color: Colors.white),
                        child: InternationalPhoneInput(
                            enabledCountries: ['+32', '+33', '+31'],
                            hintText: "Telefoon",
                            errorText: "Geen geldig nummer",
                            initialPhoneNumber: phoneNo,
                            onPhoneNumberChange: onPhoneNumberChange,
                            initialSelection: "BE"))),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: TextFormField(
                      validator: (input) {
                        if (input.length < 6) {
                          return "Min. 6 karakters";
                        }
                        return null;
                      },
                      onSaved: (input) => _password = input,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: IconButton(
                            icon: Icon(Icons.visibility_off, color: Zwart),
                            onPressed: () {},
                          ),
                          filled: true,
                          fillColor: Wit,
                          labelText: "Wachtwoord",
                          labelStyle: TextStyle(color: Zwart)),
                      obscureText: true,
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: TextFormField(
                      validator: (input) {
                        if (input.length < 6) {
                          return "Min. 6 karakters";
                        }
                        return null;
                      },
                      onSaved: (input) => _passwordConfirm = input,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: IconButton(
                            icon: Icon(Icons.visibility_off, color: Zwart),
                            onPressed: () {},
                          ),
                          filled: true,
                          fillColor: Wit,
                          labelText: "Bevestig wachtwoord",
                          labelStyle: TextStyle(color: Zwart)),
                      obscureText: true,
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: ButtonComponent(
                        label: "Toevoegen",
                        onClickAction: () {
                          signUp();
                        }))
              ],
            ),
          ),
        ));
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
                ? Text("Enter sms code")
                : Text(errorMessage),
            content: TextField(onChanged: (value) {
              this.smsCode = value;
            }),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => {Navigator.of(context).pop(), createUser()},
                  child: Text("Done"))
            ],
          );
        });
  }

  handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        if (this.mounted) {
          setState(() {
            errorMessage = 'Invalid Code';
          });
        }
        smsCodeDialog(context);
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
              modalTekst: "Niet dezelfde wachtwoord!",
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (_) => ModalComponent(
            modalTekst: "Voeg een GSM nummer in!",
          ),
        );
      }
    }
  }

  void createUser() async {
    //TODO: quand user mets un invalid sms --> bug
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
}
