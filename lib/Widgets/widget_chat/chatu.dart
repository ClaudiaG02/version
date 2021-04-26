import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:sezamiapp/Widgets/FuncionesChat/controlFirebase.dart';
import 'dart:async';
import 'package:sezamiapp/Widgets/FuncionesChat/controlNotificacion.dart';
import 'package:sezamiapp/Widgets/FuncionesChat/funciones.dart';

//import 'package:shared_preferences/shared_preferences.dart';
//Clase
class ChatU extends StatefulWidget {
  ChatU(this.myID, this.miNombre, this.seleccionUsuarioToken,
      this.seleccionUsuarioID, this.chatID, this.selectedUserName);
  //bool _isLoading = false;
  String myID;
  String miNombre;
  String seleccionUsuarioToken;
  String seleccionUsuarioID;
  String chatID;
  String selectedUserName;

  @override
  _ChatUState createState() => _ChatUState();
}

//
class _ChatUState extends State<ChatU> {
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
    ControlFirebase.instanace.getUnreadMSGCount();
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat SEZAMI'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 0.0, left: 0.0, right: 20.0),
              child: actionIcon,
            ),
          ],
          centerTitle: false,
        ),
        body: VisibilityDetector(
          key: Key("1"),
          onVisibilityChanged: ((visibility) {
            print('El código de visibilidad de chat es' +
                '${visibility.visibleFraction}');
            if (visibility.visibleFraction == 1.0) {
              ControlFirebase.instanace.getUnreadMSGCount();
            }
          }),
          //
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .doc(widget.chatID)
                  .collection(widget.chatID)
                  .orderBy('timestamp', descending: true)
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
                              children: snapshot.data.docs.map((data) {
                                //snapshot.data.documents.reversed.map((data) {
                                return data['idDe'] == widget.seleccionUsuarioID
                                    ? _listItemOther(
                                        context,
                                        widget.selectedUserName,
                                        data['contenido'],
                                        returnTimeStamp(data['timestamp']),
                                        data['tipo'])
                                    : _listItemMine(
                                        context,
                                        data['contenido'],
                                        returnTimeStamp(data['timestamp']),
                                        data['isread'],
                                        data['tipo']);
                              }).toList()),
                        ),
                        _buildTextComposer(),
                      ],
                    ),
                  ],
                );
              }),
        ));
  }

  Widget _listItemOther(BuildContext context, String name, String message,
      String time, String type) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      //child:
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: size.width - 150),
                            decoration: BoxDecoration(
                              color: Colors.green[600],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(type == 'text' ? 10.0 : 0),
                              child: Container(
                                  child: type == 'text'
                                      ? Text(
                                          message,
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          message,
                                          style: TextStyle(color: Colors.white),
                                        )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14.0, left: 4),
                          child: Text(
                            time,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _listItemMine(BuildContext context, String message, String time,
      bool isRead, String type) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 14.0, right: 2, left: 4),
            child: Text(
              isRead ? '' : '1',
              style: TextStyle(fontSize: 12, color: Colors.yellow[900]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 14.0, right: 4, left: 8),
            child: Text(
              time,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 4, 8),
                child: Container(
                  constraints:
                      BoxConstraints(maxWidth: size.width - size.width * 0.26),
                  decoration: BoxDecoration(
                    color: type == 'text' ? Colors.blue : Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(type == 'text' ? 10.0 : 10.0),
                    child: Container(
                        child: type == 'text'
                            ? Text(
                                message,
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                message,
                                style: TextStyle(color: Colors.white),
                              )),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//
  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            Flexible(
              child: new TextField(
                controller: _msgTextController,
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration(
                  hintText: "Escribe un mensaje",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(22.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                // decoration: InputDecoration.collapsed(
                //   hintText: "Escribe un mensaje",
                //  border: OutlineInputBorder()),
                //  decoration: new InputDecoration.collapsed(
                //   hintText: "Escribe un Mensaje",
                //   border: const OutlineInputBorder(
                // border: OutlineInputBorder(
                ////borderRadius: BorderRadius.circular(100.0),
                //  borderSide: BorderSide(color: Colors.grey)),
                //  ),
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
      await ControlFirebase.instanace.sendMessageToChat(widget.chatID,
          widget.myID, widget.seleccionUsuarioID, text, messageType);
      await ControlFirebase.instanace.updateChatRequestField(
          widget.seleccionUsuarioID,
          messageType == 'text' ? text : 'text',
          widget.chatID,
          widget.myID,
          widget.seleccionUsuarioID);
      await ControlFirebase.instanace.updateChatRequestField(
          widget.myID,
          messageType == 'text' ? text : 'text',
          widget.chatID,
          widget.myID,
          widget.seleccionUsuarioID);
      _getUnreadMSGCountThenSendMessage();
    } catch (e) {
      _showDialog('Existe un  error en  la Información del usuario');
      _resetTextFieldAndLoading();
    }
  }

  Future<void> _getUnreadMSGCountThenSendMessage() async {
    try {
      int unReadMSGCount = await ControlFirebase.instanace
          .getUnreadMSGCount(widget.seleccionUsuarioID);
      await ControlNotificacion.instance.sendNotificationMessageToPeerUser(
          unReadMSGCount,
          messageType,
          _msgTextController.text,
          widget.miNombre,
          widget.chatID,
          widget.seleccionUsuarioToken);
    } catch (e) {
      print(e.message);
    }
    _resetTextFieldAndLoading();
  }

  _resetTextFieldAndLoading() {
    FocusScope.of(context).requestFocus(FocusNode());
    _msgTextController.text = '';
    setState(() {
      _isLoading = false;
    });
  }

  _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(msg),
          );
        });
  }

  //void setCurrentChatID(String chatID) {}
}
