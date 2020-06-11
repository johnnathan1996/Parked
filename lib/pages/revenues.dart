import 'dart:io';

import 'package:Parked/localization/keys.dart';
import 'package:Parked/script/changeDate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Parked/constant.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../setup/globals.dart' as globals;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class Revenues extends StatefulWidget {
  @override
  _RevenuesState createState() => _RevenuesState();
}

class _RevenuesState extends State<Revenues> {

List<DocumentSnapshot> infoPdf;

  getInfoPdf() {
    Firestore.instance
        .collection('reservaties')
        .where("eigenaar", isEqualTo: globals.userId)
        .where("status", isEqualTo: 2)
        .snapshots()
        .listen((snapshot) {
          if (this.mounted) {
        setState(() {
          infoPdf = snapshot.documents;
        });
      }
    });
  }

  @override
  void initState() {
    getInfoPdf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Zwart),
          backgroundColor: Wit,
          elevation: 0.0,
          title: Image.asset('assets/images/logo.png', height: 32),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () {
                  generatePdfAndView(infoPdf);
                })
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('reservaties')
                  .where("eigenaar", isEqualTo: globals.userId)
                  .where("status", isEqualTo: 2)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, index) {
                        return StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection('garages')
                                .document(snapshot
                                    .data.documents[index].data["garageId"])
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot>
                                    garagesSnapshot) {
                              if (garagesSnapshot.hasData) {
                                return StreamBuilder<DocumentSnapshot>(
                                    stream: Firestore.instance
                                        .collection('users')
                                        .document(snapshot.data.documents[index]
                                            .data["aanvrager"])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            userSnapshot) {
                                      if (userSnapshot.hasData) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Wit,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                      garagesSnapshot
                                                          .data["adress"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Divider(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(changeDate(snapshot
                                                          .data
                                                          .documents[index]
                                                          .data["createDay"]
                                                          .toDate())),
                                                      RichText(
                                                        text: TextSpan(
                                                          style: SizeParagraph,
                                                          children: [
                                                            TextSpan(
                                                                text: userSnapshot
                                                                        .data[
                                                                    "voornaam"]),
                                                            TextSpan(
                                                                text: translate(
                                                                    Keys.Apptext_Paid)),
                                                            TextSpan(
                                                                text: snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                            "prijs"]
                                                                        .toStringAsFixed(
                                                                            2)
                                                                        .toString() +
                                                                    " €",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Text("");
                                      }
                                    });
                              } else {
                                return Container(
                                  width: 200,
                                  height: 200,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Blauw)),
                                );
                              }
                            });
                      });
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation(Blauw)),
                  );
                }
              }),
        )));
  }

  generatePdfAndView(List<DocumentSnapshot> infoPdf) async {
    // Create a new PDF document
    final PdfDocument document = PdfDocument();
// Add a new page to the document
    final PdfPage page = document.pages.add();
// Create a PDF grid class to add tables
    final PdfGrid grid = PdfGrid();
// Specify the grid columns count
    grid.columns.add(count: 3);
// Add a grid header row
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Begin';
    headerRow.cells[1].value = 'End';
    headerRow.cells[2].value = 'Price';
// Set header font
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
// Add rows to the grid

    for (var i = 0; i < infoPdf.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = changeDate(infoPdf[i].data["begin"].toDate());
      row.cells[1].value = changeDate(infoPdf[i].data["end"].toDate());
      row.cells[2].value = infoPdf[i].data["prijs"].toStringAsFixed(2).toString();
    }

// Set grid format
    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
// Draw table to the PDF page.
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height));
// Save the document
    File('PDFTable.pdf').writeAsBytes(document.save());
//Save the document
    var bytes = document.save();
// Dispose the document
    document.dispose();

//Get external storage directory
    Directory directory = await getExternalStorageDirectory();
//Get directory path
    String path = directory.path;
//Create an empty file to write PDF data
    File file = File('$path/Output.pdf');
//Write PDF data
    await file.writeAsBytes(bytes, flush: true);
//Open the PDF document in mobile
    OpenFile.open('$path/Output.pdf');
  }
}
