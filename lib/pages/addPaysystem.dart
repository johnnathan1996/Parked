import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:parkly/constant.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:parkly/ui/button.dart';
import '../setup/globals.dart' as globals;

class AddPaySystem extends StatefulWidget {
  @override
  _AddPaySystemState createState() => _AddPaySystemState();
}

class _AddPaySystemState extends State<AddPaySystem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var controllerCardNumber =
      new MaskedTextController(mask: '0000 0000 0000 0000 0');
  var controllerCardExpiry = new MaskedTextController(mask: '00/00');
  var controllerCardCvv = new MaskedTextController(mask: '000');

  String cardNumber, cardExpiry, cardName, cardCvv = '';
  String dropdownValueBank = 'Agenta';
  String dropdownValueType = 'americanExpress';

  bool showBackSide = false;

  CardType cartType() {
    switch (dropdownValueType) {
      case "americanExpress":
        {
          return CardType.americanExpress;
        }
        break;

      case "jcb":
        {
          return CardType.jcb;
        }
        break;

      case "maestro":
        {
          return CardType.maestro;
        }
        break;

      case "masterCard":
        {
          return CardType.masterCard;
        }
        break;

      case "visa":
        {
          return CardType.visa;
        }
        break;

      default:
        {
          return CardType.other;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Zwart),
            backgroundColor: Wit,
            elevation: 0.0,
            title: Image.asset('assets/images/logo.png', height: 32)),
        body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showBackSide = !showBackSide;
                      });
                    },
                    child: CreditCard(
                      cardNumber: cardNumber,
                      cardExpiry: cardExpiry,
                      cardHolderName: cardName,
                      cvv: cardCvv,
                      bankName: dropdownValueBank,
                      cardType: cartType(),
                      showBackSide: showBackSide,
                      frontBackground: CardBackgrounds.black,
                      backBackground: CardBackgrounds.white,
                      showShadow: true,
                    ))),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          DropdownButton<String>(
                            value: dropdownValueBank,
                            icon: Icon(Icons.keyboard_arrow_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Zwart),
                            underline: Container(
                              height: 2,
                              color: Zwart,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValueBank = newValue;
                              });
                            },
                            items: <String>[
                              'Agenta',
                              'AXA Bank',
                              'Belfius',
                              'BNP Paribas Fortis',
                              'bpost bank',
                              'CBC Bank',
                              'Crelan',
                              'Hello bank!',
                              'ING Belgium',
                              'KBC Bank'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          DropdownButton<String>(
                            value: dropdownValueType,
                            icon: Icon(Icons.keyboard_arrow_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Zwart),
                            underline: Container(
                              height: 2,
                              color: Zwart,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValueType = newValue;
                              });
                            },
                            items: <String>[
                              'americanExpress',
                              'jcb',
                              'maestro',
                              'masterCard',
                              'visa',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                          onTap: () {
                            setState(() {
                              showBackSide = false;
                            });
                          },
                          validator: (input) {
                            if (input.length < 21) {
                              return "Kaart nummer niet juist";
                            }
                            return null;
                          },
                          maxLength: 21,
                          maxLengthEnforced: true,
                          controller: controllerCardNumber,
                          keyboardType: TextInputType.number,
                          onChanged: (input) {
                            setState(() {
                              cardNumber = controllerCardNumber.text;
                            });
                          },
                          onSaved: (input) => cardNumber = input,
                          decoration: InputDecoration(
                              labelText: "Kaartnummer",
                              labelStyle: TextStyle(color: Zwart)))),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                          onTap: () {
                            setState(() {
                              showBackSide = false;
                            });
                          },
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Dit veld is leeg";
                            }
                            return null;
                          },
                          maxLength: 5,
                          controller: controllerCardExpiry,
                          keyboardType: TextInputType.number,
                          onChanged: (input) {
                            setState(() {
                              cardExpiry = controllerCardExpiry.text;
                            });
                          },
                          onSaved: (input) => cardExpiry = input,
                          decoration: InputDecoration(
                              labelText: "Vervaldatum",
                              labelStyle: TextStyle(color: Zwart)))),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                          onTap: () {
                            setState(() {
                              showBackSide = false;
                            });
                          },
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Dit veld is leeg";
                            }
                            return null;
                          },
                          maxLength: 25,
                          onChanged: (input) {
                            setState(() {
                              cardName = input.toUpperCase();
                            });
                          },
                          onSaved: (input) => cardName = input.toUpperCase(),
                          decoration: InputDecoration(
                              labelText: "name",
                              labelStyle: TextStyle(color: Zwart)))),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                          onTap: () {
                            setState(() {
                              showBackSide = true;
                            });
                          },
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Dit veld is leeg";
                            }
                            return null;
                          },
                          maxLength: 3,
                          controller: controllerCardCvv,
                          keyboardType: TextInputType.number,
                          onChanged: (input) {
                            setState(() {
                              cardCvv = controllerCardCvv.text;
                            });
                          },
                          onSaved: (input) => cardCvv = input,
                          decoration: InputDecoration(
                              labelText: "Cvv",
                              labelStyle: TextStyle(color: Zwart)))),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: ButtonComponent(
                        label: "Kaart toevoegen",
                        onClickAction: () {
                          createPayCard();
                        },
                      ))
                ],
              ),
            )
          ],
        ));
  }

  void createPayCard() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      try {
        await Firestore.instance
            .collection('users')
            .document(globals.userId)
            .updateData({
          "paymethode": FieldValue.arrayUnion([
            {
              'bankName': dropdownValueBank,
              'cardExpiry': cardExpiry,
              'cardHolderName': cardName,
              'cardNumber': cardNumber,
              'cardType': dropdownValueType,
              'cvv': cardCvv,
            }
          ])
        }).whenComplete(() {
          Navigator.of(context).pop();
        });
      } catch (e) {
        print(e.message);
      }
    }
  }
}
