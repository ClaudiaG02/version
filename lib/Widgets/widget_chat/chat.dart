import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_widgets/flutter_widgets.dart';
import 'dart:async';
//import 'package:sezamiapp/Widgets/FuncionesChat/firebaseMessaging.dart';
import 'package:sezamiapp/Widgets/FuncionesChat/controlNotificacion.dart';
import 'package:sezamiapp/Widgets/FuncionesChat/firestore.dart';
import 'package:sezamiapp/Widgets/FuncionesChat/funciones.dart';
import 'subWidgets/chatListTile/mine_list_tile.dart';
import 'subWidgets/chatListTile/peer_user_list_tile.dart';
import 'subWidgets/chatListTile/string_list_tile.dart';
import 'subWidgets/common_widgets.dart';

const chatInstruction =
    """ SEZAMI Digital ofrece al usuario una herramienta para poder mantener una comunicacion con personal de SEZAMI Zacatecas.""";

//Clase Chat
class Chat extends StatefulWidget {
  Chat(this.myID, this.myName, this.selectedUserToken, this.selectedUserID,
      this.chatID, this.selectedUserName);
  //bool _isLoading = false;
  String myID;
  String myName;
  String selectedUserToken;
  String selectedUserID;
  String chatID;
  String selectedUserName;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _msgTextController = new TextEditingController();
  final ScrollController _controlListaChat = ScrollController();
  String messageType = 'text';
  bool _isLoading = false;
  int listaChatLength = 20;
  double _posicionDesplazamiento = 560;

  _scrollListener() {
    setState(() {
      if (_posicionDesplazamiento < _controlListaChat.position.pixels) {
        _posicionDesplazamiento = _posicionDesplazamiento + 560;
        listaChatLength = listaChatLength + 20;
      }
//      _scrollPosition = _ListaChatController.position.pixels;
      print('la posición de la vista de lista es  $_posicionDesplazamiento');
    });
  }

  @override
  void initState() {
    setCurrentChatID(widget.chatID);
    //ControlFirebase.instanace.getUnreadMSGCount();
    _controlListaChat.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    setCurrentChatID('none');
    super.dispose();
  }

  Image actionIcon = new Image.asset("images/icons/icChat1.png",
      width: 40, color: Color(0xff252526));
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.selectedUserName),
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
                  .collection('chatroom')
                  .doc(widget.chatID)
                  .collection(widget.chatID)
                  .orderBy('timestamp', descending: false)
                  .limit(listaChatLength)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                if (snapshot.hasData) {
                  for (var data in snapshot.data.docs) {
                    if (data['idPara'] == widget.myID &&
                        data['isread'] == false) {
                      if (data.reference != null) {
                        FirebaseFirestore.instance
                            .runTransaction((Transaction myTransaction) async {
                          await myTransaction
                              .update(data.reference, {'isread': true});
                        });
                      }
                    }
                  }
                }
                return Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                              reverse: true,
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.fromLTRB(4.0, 10, 4, 10),
                              controller: _controlListaChat,
                              children:
                                  addInstructionInSnapshot(snapshot.data.docs)
                                      .map((data) {
                                //snapshot.data.documents.reversed.map((data) {
                                return _returnChatWidget(data);
                              }).toList()),
                        ),
                        _buildTextComposer(),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
    );
    // );
  }

  Widget _returnChatWidget(dynamic data) {
    Widget _returnWidget;
    if (data is QueryDocumentSnapshot) {
      _returnWidget = data['idFrom'] == widget.selectedUserID
          ? peerUserListTile(context, widget.selectedUserName, data['content'],
              returnTimeStamp(data['timestamp']), data['type'])
          : mineListTile(context, data['content'],
              returnTimeStamp(data['timestamp']), data['isread'], data['type']);
    } else if (data is String) {
      _returnWidget = stringListTile(data);
    }
    return _returnWidget;
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _msgTextController,
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                    hintText: "Escribe un Mensaje"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 2.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () {
                    setState(() {
                      messageType = 'text';
                    });
                    _handleSubmitted(_msgTextController.text);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmitted(String text) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseCloudS.instanace.sendMessageToChat(
          widget.chatID, widget.myID, widget.selectedUserID, text, messageType);
      await FirebaseCloudS.instanace.updateChatRequestField(
          widget.selectedUserID,
          messageType == 'text' ? text : '(Photo)',
          widget.chatID,
          widget.myID,
          widget.selectedUserID);
      await FirebaseCloudS.instanace.updateChatRequestField(
          widget.myID,
          messageType == 'text' ? text : '(Photo)',
          widget.chatID,
          widget.myID,
          widget.selectedUserID);
      _getUnreadMSGCountThenSendMessage();
    } catch (e) {
      showAlertDialog(context, 'Error');
      _resetTextFieldAndLoading();
    }
  }

  Future<void> _getUnreadMSGCountThenSendMessage() async {
    try {
      int unReadMSGCount = await FirebaseCloudS.instanace
          .getUnreadMSGCount(widget.selectedUserID);
      await ControlNotificacion.instance.sendNotificationMessageToPeerUser(
        unReadMSGCount,
        messageType,
        _msgTextController.text,
        widget.myName,
        widget.chatID,
        widget.selectedUserToken,
      );
    } catch (e) {
      print(e.message);
    }
    _resetTextFieldAndLoading();
  }

  void _resetTextFieldAndLoading() {
    FocusScope.of(context).requestFocus(FocusNode());
    _msgTextController.text = '';
    setState(() {
      _isLoading = false;
    });
  }
}
