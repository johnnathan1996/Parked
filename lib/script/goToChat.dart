import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Parked/pages/chatPage.dart';
import '../setup/globals.dart' as globals;

goingToChat(BuildContext context, String eigenaarId, String idGarage,
    String myName) async {
  List bijdeUsers;
  String garageId;
  DocumentSnapshot conversationId;
  final result = await Firestore.instance
      .collection('conversation')
      .where('userInChat', arrayContains: globals.userId)
      .getDocuments();

  final List<DocumentSnapshot> documents = result.documents;

  documents.forEach((data) {
    bijdeUsers = data.data['userInChat'];

    garageId = data.data["garageId"];

    if (bijdeUsers.contains(eigenaarId)) {
      if (garageId == idGarage) {
        conversationId = data;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    conversationID: data.documentID, sendName: myName)));
      }
    }
  });

  if (conversationId == null) {
    Firestore.instance.collection('conversation').add({
      'chat': [],
      'garageId': idGarage,
      'creator': globals.userId,
      'seenLastIndex': 0,
      'seenLastMessage': false,
      'userInChat': [globals.userId, eigenaarId],
    }).then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(
                  conversationID: value.documentID, sendName: myName)));
    });
  }
}
