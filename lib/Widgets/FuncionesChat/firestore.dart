import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseCloudS {
  static FirebaseCloudS get instanace => FirebaseCloudS();

  Future<String> saveUserDataToFirebaseDatabase(usuarioId, userName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('FCMToken', isEqualTo: prefs.get('FCMToken'))
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      String myID = usuarioId;
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('usuarios').doc(usuarioId);

      if (documents.length == 0) {
        FirebaseFirestore.instance
            .runTransaction((Transaction myTransaction) async {
          myTransaction.set(userDoc, {
            'nombre': userName,
            'FechaCreacion': DateTime.now().millisecondsSinceEpoch,
            'FCMToken': prefs.get('FCMToken') ?? 'NOToken',
          });
        });
      } else {
        String userID = documents[0]['usuarioId'];
        myID = userID;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('usuarioId', myID);
        FirebaseFirestore.instance
            .runTransaction((Transaction myTransaction) async {
          myTransaction.update(userDoc, {
            'nombre': userName,
            'FechaCreacion': DateTime.now().millisecondsSinceEpoch,
            'FCMToken': prefs.get('FCMToken') ?? 'NOToken',
          });
        });
      }
      return myID;
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<void> updateUserToken(userID, token) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(userID).set({
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
      print('el recuento de mensajes no leídos es $unReadMSGCount');
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
        .collection('usuarios')
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

  Future updateChatRequestFieldUsuario(String documentID, chatID, myID) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(documentID)
        // .collection('ListaChat')
        //  .document(chatID)
        .set({
      'chatID': chatID,
      //  'ChatCon': documentID == myID ?  : myID,
      // 'ultimoMensaje': lastMessage,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }

  ///
  Future sendMessageToChat(
      chatID, myID, selectedUserID, contenido, messageType) async {
    await FirebaseFirestore.instance
        .collection('chat')
        .doc(chatID)
        .collection(chatID)
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'idDe': myID,
      'idPara': selectedUserID,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'contenido': contenido,
      'tipo': messageType,
      'isread': false,
    });
  }

  // sendMessageToChatUsuarios(
  //   String chatID, String myID, String text, String messageType) {}
}
//StringchatIDStringmyIDStringselectedUserIDStringtextStringmessageType
