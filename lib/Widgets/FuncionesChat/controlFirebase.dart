import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:firebase_core/firebase_core.dart' as firebase_core;

class ControlFirebase {
  static ControlFirebase get instanace => ControlFirebase();

  Future<String> saveUserDataToFirebaseDatabase(usuarioId, userName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('FCMToken', isEqualTo: prefs.get('FCMToken'))
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      String myID = usuarioId;
      if (documents.length == 0) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(usuarioId)
            .set({
          'usuarioId': usuarioId,
          'nombre': userName,
          'FechaCreacion': DateTime.now().millisecondsSinceEpoch,
          'FCMToken': prefs.get('FCMToken') ?? 'NOToken',
        });
      } else {
        String userID = documents[0]['usuarioId'];
        myID = userID;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('usuarioId', myID);
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(userID)
            .update({
          'nombre': userName,
          'FechaCreacion': DateTime.now().millisecondsSinceEpoch,
          'FCMToken': prefs.get('FCMToken') ?? 'NOToken',
        });
      }
      return myID;
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<void> updateUserToken(usuarioID, token) async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioID)
        .update({
      'FCMToken': token,
    });
  }

  Future<List<DocumentSnapshot>> takeUserInformationFromFBDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('usuarios')
        .where('FCMToken', isEqualTo: prefs.get('FCMToken') ?? 'None')
        .get();
    return result.docs;
  }

  Future<int> getUnreadMSGCount([String peerUserID]) async {
    try {
      int unReadMSGCount = 0;
      String targetID = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();

      peerUserID == null
          ? targetID = (prefs.get('usuarioId') ?? 'NoId')
          : targetID = peerUserID;
//      if (targetID != 'NoId') {
      final QuerySnapshot chatListResult = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(targetID)
          .collection('ListaChat')
          .get();
      final List<DocumentSnapshot> chatListDocuments = chatListResult.docs;
      for (var data in chatListDocuments) {
        final QuerySnapshot unReadMSGDocument = await FirebaseFirestore.instance
            .collection('chat')
            .doc(data['chatID'])
            .collection(data['chatID'])
            .where('idPara', isEqualTo: targetID)
            .where('isread', isEqualTo: false)
            .get();

        final List<DocumentSnapshot> unReadMSGDocuments =
            unReadMSGDocument.docs;
        unReadMSGCount = unReadMSGCount + unReadMSGDocuments.length;
      }
      print('unread MSG count is $unReadMSGCount');
//      }
      if (peerUserID == null) {
        FlutterAppBadger.updateBadgeCount(unReadMSGCount);
        return null;
      } else {
        return unReadMSGCount;
      }
    } catch (e) {
      print(e.message);
    }
  }

  Future updateChatRequestField(String documentID, String lastMessage, chatID,
      myID, selectedUserID) async {
    await FirebaseFirestore.instance
        .collection('usuario')
        .doc(documentID)
        .collection('ListaChat')
        .doc(chatID)
        .set({
      'chatID': chatID,
      'chatCon': documentID == myID ? selectedUserID : myID,
      'ultimoMensaje': lastMessage,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future sendMessageToChat(
      chatID, myID, selectedUserID, content, messageType) async {
    await FirebaseFirestore.instance
        .collection('chat')
        .doc(chatID)
        .collection(chatID)
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'idFrom': myID,
      'idPara': selectedUserID,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'content': content,
      'type': messageType,
      'isread': false,
    });
  }
}
