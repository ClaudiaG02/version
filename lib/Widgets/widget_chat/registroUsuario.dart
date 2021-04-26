import 'package:flutter/material.dart';
import 'package:sezamiapp/Widgets/FuncionesChat/controlFirebase.dart';
import 'package:sezamiapp/Widgets/FuncionesChat/controlNotificacion.dart';
import 'package:sezamiapp/Widgets/FuncionesChat/firestore.dart';
import 'package:sezamiapp/Widgets/FuncionesChat/funciones.dart';
import 'listachat.dart';
import 'listachatu.dart';

//import 'package:firebase_core/firebase_core.dart' as firebase_core;
//import 'package:firebase_messaging/firebase_messaging.dart';

//import 'package:sezamiapp/Widgets/widget_chat/listachat.dart';
//import 'package:sezamiapp/Widgets/widget_chat/listachatu.dart';

class Registro extends StatefulWidget {
//  String get myID => null;
  // String get myName => null;

  //Image actionIcon = new Image.asset("images/icons/icChat.png",
  //  width: 40, color: Color(0xff252526));
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  TextEditingController _nameTextController = TextEditingController();

  bool _isLoading = true;

  @override
  //Registro get widget => super.widget;

  //Object get Agente123 => null;

  // get selectedUserToken => null;
  // get selectedUserID => null;
  // get chatID => null;
  ///get selectedUserName => null;

  void initState() {
    ControlNotificacion.instance.takeFCMTokenWhenAppLaunch();
    ControlNotificacion.instance.initLocalNotification();
    setCurrentChatID('none');
    _takeUserInformationFromFBDB();
    super.initState();
  }

  _takeUserInformationFromFBDB() async {
    ControlFirebase.instanace.takeUserInformationFromFBDB().then((documents) {
      if (documents.length > 0) {
        _nameTextController.text = documents[0]['nombre'];
      }
      setState(() {
        _isLoading = false;
      });
    });
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
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Es necesario ingresar su nombre \n para iniciar chat ",
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _nameTextController,
                decoration: InputDecoration(
                  hintText: "Ingrese su Nombre",
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  // controller: _nameTextController,
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                _saveDataToServer();
              },
              child: Text(
                "Continuar",
                style: TextStyle(color: Colors.white),
              ),
              elevation: 7.0,
              color: Colors.blue,
            )
          ],
        ));
  }

  _saveDataToServer() {
    setState(() {
      _isLoading = true;
    });
    String alertString = validarDatosUsuario(_nameTextController.text);
    if (alertString.trim() != '') {
      _mostrarDialogo(alertString);
    } else {
      _nameTextController.text != ''
          ? FirebaseCloudS.instanace
              .saveUserDataToFirebaseDatabase(
                  randomIdWithName(_nameTextController.text),
                  _nameTextController.text)
              .then((data) {
              _moveToListaChat(data);
            })
          : ControlFirebase.instanace
              .saveUserDataToFirebaseDatabase(
              randomIdWithName(_nameTextController.text),
              _nameTextController.text,
            )
              .then((data) {
              _moveToListaChat(data);
              // _moveToaChat(data);
            });
    }
  }

  void _moveToListaChat(data) {
    setState(() => _isLoading = false);
    // String nombr = "asesoruno";
    //Quitar la  constante
    //final String nombre = "asesoruno";
    //final String userName = "asesoruno";
    //Cambiar el Switch Case por condicional else if
    //Condicional
//
    String uno = "asesor_uno";
    String dos = "asesor_dos";

    if (_nameTextController.text == uno) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListaChat(data, _nameTextController.text)));
    } else if (_nameTextController.text == dos) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListaChat(data, _nameTextController.text)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ListaChatU(data, _nameTextController.text)));
    }
  }

  //
  _mostrarDialogo(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(msg),
          );
        });
  }

  //void setCurrentChatID(String s) {}
}
