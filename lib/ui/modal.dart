// https://stackoverflow.com/questions/52408610/flutter-custom-animated-dialog
import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:parkly/pages/profile.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

class ModalComponent extends StatefulWidget {
  final String modalTekst;
  final bool showAddCartBtn;

  ModalComponent({
    @required this.modalTekst,
    this.showAddCartBtn: false,
  });

  @override
  State<StatefulWidget> createState() => _ModalComponentState(
      modalTekst: modalTekst, showAddCartBtn: showAddCartBtn);
}

class _ModalComponentState extends State<ModalComponent>
    with SingleTickerProviderStateMixin {
  String modalTekst;
  bool showAddCartBtn;
  _ModalComponentState({Key key, this.modalTekst, this.showAddCartBtn});

  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.60,
                maxWidth: MediaQuery.of(context).size.width * 0.80),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(translate(Keys.Modal_Wrong),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Blauw,
                              fontSize: 16))),
                  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        modalTekst,
                        style: SizeParagraph,
                        textAlign: TextAlign.center,
                      )),
                  showAddCartBtn
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(translate(Keys.Button_Later)),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()));
                              },
                              child: Text(
                                translate(Keys.Button_Gotoprofile),
                                style: TextStyle(color: Blauw),
                              ),
                            )
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
