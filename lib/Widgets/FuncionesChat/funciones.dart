import 'dart:math';
import 'package:intl/intl.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'CloudServerToken/const.dart';

//import 'package:FuncionesChat/CloudServerToken/const.dart';
import 'package:sezamiapp/Widgets/widget_chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Para las funciones del tiempo TimeStamp
//Lectura

String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    if (diff.inHours > 0) {
      time = diff.inHours.toString() + '  horas';
    } else if (diff.inMinutes > 0) {
      time = diff.inMinutes.toString() + '  minutos';
    } else if (diff.inSeconds > 0) {
      time = 'Ahora';
    } else if (diff.inMilliseconds > 0) {
      time = 'Ahora';
    } else if (diff.inMicroseconds > 0) {
      time = 'Ahora';
    } else {
      time = 'Ahora';
    }
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    time = diff.inDays.toString() + '  dias';
  } else if (diff.inDays > 6) {
    time = (diff.inDays / 7).floor().toString() + '  semanas';
  } else if (diff.inDays > 29) {
    time = (diff.inDays / 30).floor().toString() + '  meses';
  } else if (diff.inDays > 365) {
    time = '${date.month}-${date.day}-${date.year}';
  }
  return time;
}

String realizarChatId(myID, selectedUserID) {
  String chatID;
  if (myID.hashCode > selectedUserID.hashCode) {
    chatID = '$selectedUserID-$myID';
  } else {
    chatID = '$myID-$selectedUserID';
  }
  return chatID;
}

int contadorUsuariosLista(myID, AsyncSnapshot<QuerySnapshot> snapshot) {
  int resultInt = snapshot.data.docs.length;
  for (var data in snapshot.data.docs) {
    if (data['usuarioId'] == myID) {
      resultInt--;
    }
  }
  return resultInt;
}

// Para la funcion del Chat
String returnTimeStamp(int messageTimeStamp) {
  String resultString = '';
  var format = DateFormat('hh:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(messageTimeStamp);
  resultString = format.format(date);
  return resultString;
}

void setCurrentChatID(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('currentChat', value);
}

List<dynamic> addInstructionInSnapshot(List<QueryDocumentSnapshot> snapshot) {
  List<dynamic> _returnList;
  List<dynamic> _newData = addChatDateInSnapshot(snapshot);
  _returnList = List<dynamic>.from(_newData.reversed);
  _returnList.add(chatInstruction);
  return _returnList;
}

List<dynamic> addChatDateInSnapshot(List<QueryDocumentSnapshot> snapshot) {
  List<dynamic> _returnList = [];
  String _currentDate;

  for (QueryDocumentSnapshot snapshot in snapshot) {
    var format = DateFormat('EEEE, MMMM d, yyyy');
    var date = DateTime.fromMillisecondsSinceEpoch(snapshot['timestamp']);

    if (_currentDate == null) {
      _currentDate = format.format(date);
      _returnList.add(_currentDate);
    }

    if (_currentDate == format.format(date)) {
      _returnList.add(snapshot);
    } else {
      _currentDate = format.format(date);
      _returnList.add(_currentDate);
      _returnList.add(snapshot);
    }
  }

  return _returnList;
}

String validarDatosUsuario(name) {
  String returnString = '';
  if (name.trim() == '') {
    if (returnString.trim() != '') {
      returnString = returnString + '\n\n';
    }
    returnString = returnString + 'Por favor escriba su nombre';
  }

  return returnString;
}

String randomIdWithName(userName) {
  int randomNumber = Random().nextInt(100000);
  return '$userName$randomNumber';
}
