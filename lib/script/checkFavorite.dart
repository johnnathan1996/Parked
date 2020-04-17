import 'package:cloud_firestore/cloud_firestore.dart';
import '../setup/globals.dart' as globals;

class CheckFav {
  Future<void> isgarageInFavorite(String id) async {
    DocumentSnapshot userInstance = await Firestore.instance
        .collection('users')
        .document(globals.userId)
        .get();
    List userInstanceFavoriet = userInstance.data["favoriet"];

    if (userInstanceFavoriet.contains(id)) {
      removeInFavorite(id);
    } else {
      addInFavorite(id);
    }
  }

  void addInFavorite(String id) async {
    try {
      await Firestore.instance
          .collection('users')
          .document(globals.userId)
          .updateData({
        "favoriet": FieldValue.arrayUnion([id])
      });
    } catch (e) {
      print(e.message);
    }
  }

  void removeInFavorite(String id) async {
    try {
      await Firestore.instance
          .collection('users')
          .document(globals.userId)
          .updateData({
        "favoriet": FieldValue.arrayRemove([id])
      });
    } catch (e) {
      print(e.message);
    }
  }
}
