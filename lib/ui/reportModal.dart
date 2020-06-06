import 'package:flutter/material.dart';
import 'package:parkly/constant.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

class ReportModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReportModalState();
}

class _ReportModalState extends State<ReportModal>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  bool showThanks = false;

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
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(translate(Keys.Button_Report), style: SubTitleCustom),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      !showThanks
                          ? translate(Keys.Modal_Reportconv)
                          : translate(Keys.Modal_Reportthanks),
                      style: SizeParagraph,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: !showThanks
                        ? () {
                            if (this.mounted) {
                              setState(() {
                                showThanks = true;
                              });
                            }
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.of(context).pop();
                            });
                          }
                        : null,
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: ShapeDecoration(
                            color: Blauw,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)))),
                        alignment: Alignment.center,
                        child: Text(
                          translate(Keys.Button_Report),
                          style: TextStyle(color: Wit),
                        )),
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
