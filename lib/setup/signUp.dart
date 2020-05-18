import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/pages/maps.dart';
import 'package:flutter/services.dart';
import 'package:parkly/script/changeDate.dart';
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

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _lastName, _email, _password, _passwordConfirm, _gender;

  DateTime birthday;

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
    var localizationDelegate = LocalizedApp.of(context).delegate;
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
                    child: Container(
                        padding: EdgeInsets.only(left: 12.0, right: 20.0),
                        color: Wit,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.account_box),
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                      value: _gender,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      iconSize: 24,
                                      hint: Text(translate(Keys.Inputs_Gender),
                                          style: TextStyle(
                                              color: Zwart,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15)),
                                      style: TextStyle(color: Zwart),
                                      onChanged: (String newValue) {
                                        if (this.mounted) {
                                          setState(() {
                                            _gender = newValue;
                                          });
                                        }
                                      },
                                      items: <String>[
                                        "M",
                                        "W",
                                        "X",
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        String tekst;
                                        if (value == "M") {
                                          tekst = translate(Keys.Inputs_Man);
                                        }
                                        if (value == "W") {
                                          tekst = translate(Keys.Inputs_Woman);
                                        }
                                        if (value == "X") {
                                          tekst = translate(Keys.Inputs_Other);
                                        }
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(tekst),
                                        );
                                      }).toList(),
                                    ))))
                          ],
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
                        EdgeInsets.only(left: 4.0, right: 4.0, bottom: 10.0),
                    child: FlatButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              maxTime:
                                  DateTime.now().subtract(Duration(days: 6575)),
                              locale: getCurrentLanguageLocalizationKey(
                                  localizationDelegate.currentLocale
                                      .languageCode), onConfirm: (date) {
                            if (this.mounted) {
                              setState(() {
                                birthday = date;
                              });
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 13),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Wit,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          alignment: Alignment.center,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.cake),
                              Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Text(
                                    birthday != null
                                        ? changeDate(birthday)
                                        : translate(Keys.Inputs_Birthday),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ))
                            ],
                          ),
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
      if (_gender != null) {
        if (birthday != null) {
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
        } else {
          showDialog(
            context: context,
            builder: (_) => ModalComponent(
              modalTekst: translate(Keys.Modal_Nobirthday),
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (_) => ModalComponent(
            modalTekst: translate(Keys.Modal_Nogender),
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
        'voornaam': _name.capitalize(),
        'achternaam': _lastName.capitalize(),
        'imgUrl': null,
        'email': _email,
        'nummer': phoneNo,
        'gender': _gender,
        'age': birthday,
        'favoriet': [],
        'mijnGarage': []
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

  getCurrentLanguageLocalizationKey(String code) {
    switch (code) {
      case "nl":
        return LocaleType.nl;
      case "fr":
        return LocaleType.fr;
      case "en":
        return LocaleType.en;
      default:
        return LocaleType.nl;
    }
  }
}
