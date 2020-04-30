import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:parkly/constant.dart';
import 'package:path/path.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:parkly/localization/keys.dart';

class ChooseImage {
  String downloadLink;
  var contextGlobal;

  Future takePicture() async {
    var imageFromCamera =
        await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFromCamera != null) {
      await uploadToStorage(imageFromCamera);
    }
  }

  Future choosePicture() async {
    var imageFromLibrary =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFromLibrary != null) {
      await uploadToStorage(imageFromLibrary);
    }
  }

  Future uploadToStorage(File image) async {
    var dialogContext;
    showDialog(
      barrierDismissible: false,
      context: contextGlobal,
      builder: (BuildContext context) {
        dialogContext = context;
        return Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Blauw)),
        );
      },
    );

    String fileName = basename(image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    await uploadTask.onComplete;

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = dowurl.toString();
    downloadLink = url;
    if (dialogContext != null) {
      Navigator.of(dialogContext).pop();
    }
  }

  Future actionUploadImage(BuildContext context) async {
    contextGlobal = context;
    await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(translate(Keys.Button_Cancel)),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () async {
                  await takePicture();
                  Navigator.of(context).pop();
                },
                child: Text(translate(Keys.Button_Camera)),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
                  await choosePicture();
                  Navigator.of(context).pop();
                },
                child: Text(translate(Keys.Button_Library)),
              )
            ],
          );
        });
  }
}
