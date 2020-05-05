import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:parkly/constant.dart';
import '../setup/globals.dart' as globals;

class PaySystem extends StatefulWidget {
  final Map payMethod;

  PaySystem({
    this.payMethod,
  });

  @override
  _PaySystemState createState() => _PaySystemState(payMethod: payMethod);
}

class _PaySystemState extends State<PaySystem> {
  Map payMethod;
  _PaySystemState({Key key, this.payMethod});

  bool showBackSide = false;

  CardType cartType() {
    switch (payMethod["cardType"]) {
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
          title: Image.asset('assets/images/logo.png', height: 32),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  try {
                    Firestore.instance
                        .collection('users')
                        .document(globals.userId)
                        .updateData({
                      "paymethode": FieldValue.arrayRemove([
                        {
                          'bankName': payMethod["bankName"],
                          'cardExpiry': payMethod["cardExpiry"],
                          'cardHolderName': payMethod["cardHolderName"],
                          'cardNumber': payMethod["cardNumber"],
                          'cardType': payMethod["cardType"],
                          'cvv': payMethod["cvv"],
                        }
                      ])
                    }).whenComplete(() {
                      Navigator.of(context).pop();
                    });
                  } catch (e) {
                    print(e.message);
                  }
                })
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('users')
                .document(globals.userId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                    onTap: () {
                      if (this.mounted) {
                        setState(() {
                          showBackSide = !showBackSide;
                        });
                      }
                    },
                    child: CreditCard(
                      cardNumber: payMethod["cardNumber"],
                      cardExpiry: payMethod["cardExpiry"],
                      cardHolderName: payMethod["cardHolderName"],
                      cvv: payMethod["cvv"],
                      bankName: payMethod["bankName"],
                      cardType: cartType(),
                      showBackSide: showBackSide,
                      frontBackground: CardBackgrounds.black,
                      backBackground: CardBackgrounds.white,
                      showShadow: true,
                    ));
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Blauw)),
                );
              }
            }));
  }
}
