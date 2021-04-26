import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_widgets/flutter_widgets.dart';
//import 'package:sezamiapp/Widgets/FuncionesChat/controlFirebase.dart';
import 'package:sezamiapp/Widgets/FuncionesChat/funciones.dart';
import 'package:sezamiapp/Widgets/widget_chat/subWidgets/common_widgets.dart';
//import 'package:sezamiapp/Control/controlNotificacion.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'chat.dart';

class ListaChat extends StatefulWidget {
  ListaChat(this.myID, this.myName);

  String myID;
  String myName;

  @override
  _ListaChat createState() => _ListaChat();
}

class _ListaChat extends State<ListaChat> {
  Image actionIcon = new Image.asset("images/icons/icChat1.png",
      width: 40, color: Color(0xff252526));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios registrados'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 0.0, bottom: 0.0, left: 0.0, right: 20.0),
            child: actionIcon,
          ),
        ],
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('usuarios')
              .orderBy('FechaCreacion', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
            if (!userSnapshot.hasData) return loadingCircleForFB();
            return contadorUsuariosLista(widget.myID, userSnapshot) > 0
                ? ListView(
                    children: userSnapshot.data.docs.map((userData) {
                    if (userData['usuarioId'] == widget.myID) {
                      return Container();
                    } else {
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('usuarios')
                              .doc(widget.myID)
                              .collection('ListaChat')
                              .where('chatCon',
                                  isEqualTo: userData['usuarioId'])
                              .snapshots(),
                          builder: (context, listaChatSnapshot) {
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                // child: ImageController.instance.cachedImage(userData['userImageUrl']),
                              ),
                              title: Text(userData['nombre']),
                              // subtitle: Text((chatListSnapshot.hasData && chatListSnapshot.data.docs.length >0)
                              //  ? chatListSnapshot.data.docs[0]['lastChat']
                              // : userData['intro']),
                              trailing: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 4, 4),
                                  child: (listaChatSnapshot.hasData &&
                                          listaChatSnapshot.data.docs.length >
                                              0)
                                      ? StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('chatroom')
                                              .doc(listaChatSnapshot
                                                  .data.docs[0]['chatID'])
                                              .collection(listaChatSnapshot
                                                  .data.docs[0]['chatID'])
                                              .where('idPara',
                                                  isEqualTo: widget.myID)
                                              .where('isread', isEqualTo: false)
                                              .snapshots(),
                                          builder:
                                              (context, notReadMSGSnapshot) {
                                            return Container(
                                              width: 60,
                                              height: 50,
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    (listaChatSnapshot
                                                                .hasData &&
                                                            listaChatSnapshot
                                                                    .data
                                                                    .docs
                                                                    .length >
                                                                0)
                                                        ? readTimestamp(
                                                            listaChatSnapshot
                                                                    .data
                                                                    .docs[0]
                                                                ['timestamp'])
                                                        : '',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 5, 0, 0),
                                                      child: CircleAvatar(
                                                        radius: 13,
                                                        child: Text(
                                                          (listaChatSnapshot
                                                                      .hasData &&
                                                                  listaChatSnapshot
                                                                          .data
                                                                          .docs
                                                                          .length >
                                                                      0)
                                                              ? ((notReadMSGSnapshot
                                                                          .hasData &&
                                                                      notReadMSGSnapshot
                                                                              .data
                                                                              .docs
                                                                              .length >
                                                                          0)
                                                                  ? '${notReadMSGSnapshot.data.docs.length}'
                                                                  : '')
                                                              : '',
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        ),
                                                        backgroundColor: (notReadMSGSnapshot.hasData &&
                                                                notReadMSGSnapshot
                                                                        .data
                                                                        .docs
                                                                        .length >
                                                                    0 &&
                                                                notReadMSGSnapshot
                                                                    .hasData &&
                                                                notReadMSGSnapshot
                                                                        .data
                                                                        .docs
                                                                        .length >
                                                                    0)
                                                            ? Colors.green[400]
                                                            : Colors
                                                                .transparent,
                                                        foregroundColor:
                                                            Colors.white,
                                                      )),
                                                ],
                                              ),
                                            );
                                          })
                                      : Text('')),
                              onTap: () {
                                _moveTochatRoom(
                                    userData['FCMToken'],
                                    userData['usuarioId'],
                                    userData['name'],
                                    userData['userImageUrl']);
                              },
                            );
                          });
                    }
                  }).toList())
                : Container(
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.group,
                          color: Colors.grey[700],
                          size: 35,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'No hay usuarios para iniciar chat.',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                  );
          }),
    );
    // );
  }

  Future<void> _moveTochatRoom(selectedUserToken, selectedUserID,
      selectedUserName, selectedUserThumbnail) async {
    try {
      String chatID = realizarChatId(widget.myID, selectedUserID);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Chat(
                    widget.myID,
                    widget.myName,
                    selectedUserToken,
                    selectedUserID,
                    chatID,
                    selectedUserName,
                  )));
    } catch (e) {
      print(e.message);
    }
  }
}
