import 'dart:io';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<String> myiPDF(
  String nofi,
  String nombre,
  String direccion,
  String direccionu,
  String nombresoli,
  String telsoli,
  String parsoli,
  String dian,
  String mesn,
  String anon,
  String diaf,
  String mesf,
  String anof,
) async {
  final pdf = pw.Document();
////
  pdf.addPage(pw.Page(
    pageFormat:
        PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
    build: (pw.Context context) {
      //if (context.pageNumber == 1) {
      // return null;
      // }s
      return pw.Center(
          //  return pw.Container(

          child: pw.Text('Portable Document Format',
              style: pw.Theme.of(context)
                  .defaultTextStyle
                  .copyWith(color: PdfColors.grey)));
    },
    // Footer: (pw.Context context) {
    //return pw.Container(
    // alignment: pw.Alignment.centerLeft,
    // margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
    //child: pw.Text(
    //'cc: sezami.zac@gmail.com',
    // style: pw.Theme.of(context)
    //   .defaultTextStyle
    // .copyWith(color: PdfColors.grey),
    // ),
    // );
    // },
    builder: (pw.Context context) => <pw.Widget>[
      pw.Header(
          level: 0,
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text('SOLICITUD DE LOCALIZACIÓN',
                        textScaleFactor: 1.5),
                  ),
                ),
                pw.Expanded(
                  child: pw.Container(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text('Ofi.No. $nofi', textScaleFactor: 1),
                  ),
                ),
              ])),
      pw.Header(
          level: 3,
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text(
                  'Datos del Desaparecido:',
                  textScaleFactor: 1,
                  style: pw.TextStyle(color: PdfColors.blue),
                ),
              ])),
      pw.Padding(
        padding: pw.EdgeInsets.all(4.0),
        child: pw.Row(children: <pw.Widget>[
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text('NOMBRE:  ', style: pw.TextStyle(fontSize: 12.0)),
            ),
          ),
          pw.Expanded(
            flex: 4,
            child: pw.Center(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                    // border: BoxBorder(
                    //     bottom: true, width: 0.5, color: PdfColors.grey)
                    ),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  '$nombre',
                  style: pw.TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(4.0),
        child: pw.Row(children: <pw.Widget>[
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text('  FECHA DE NACIMIENTO:  ',
                  style: pw.TextStyle(fontSize: 12.0)),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Container(
              alignment: pw.Alignment.center,
              decoration: const pw.BoxDecoration(
                  // border: BoxBorder(
                  //     bottom: true, width: 0.5, color: PdfColors.grey)
                  ),
              child: pw.Text(' $dian  -  $mesn  -  $anon',
                  style: pw.TextStyle(
                    fontSize: 12.0,
                  )),
            ),
          )
        ]),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(4.0),
        child: pw.Row(children: <pw.Widget>[
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              alignment: pw.Alignment.centerLeft,
              child:
                  pw.Text('DIRECCIÓN: ', style: pw.TextStyle(fontSize: 12.0)),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Center(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                    // border: BoxBorder(
                    //     bottom: true, width: 0.5, color: PdfColors.grey)
                    ),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  '$direccion',
                  style: pw.TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      pw.Header(
          level: 3,
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text(
                  'Datos del Solicitante:',
                  textScaleFactor: 1,
                  style: pw.TextStyle(color: PdfColors.blue),
                ),
              ])),
      pw.Padding(
        padding: pw.EdgeInsets.all(4.0),
        child: pw.Row(children: <pw.Widget>[
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text('NOMBRE:  ', style: pw.TextStyle(fontSize: 12.0)),
            ),
          ),
          pw.Expanded(
            flex: 4,
            child: pw.Center(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                    // border: BoxBorder(
                    //     bottom: true, width: 0.5, color: PdfColors.grey)
                    ),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  '$nombresoli',
                  style: pw.TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(4.0),
        child: pw.Row(children: <pw.Widget>[
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              alignment: pw.Alignment.centerLeft,
              child:
                  pw.Text('TÉLEFONO:  ', style: pw.TextStyle(fontSize: 12.0)),
            ),
          ),
          pw.Expanded(
            flex: 5,
            child: pw.Center(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                    // border: BoxBorder(
                    //     bottom: true, width: 0.5, color: PdfColors.grey)
                    ),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  '$telsoli',
                  style: pw.TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(4.0),
        child: pw.Row(children: <pw.Widget>[
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              alignment: pw.Alignment.centerLeft,
              child:
                  pw.Text('PARENTESCO:  ', style: pw.TextStyle(fontSize: 12.0)),
            ),
          ),
          pw.Expanded(
            flex: 7,
            child: pw.Center(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                    // border: BoxBorder(
                    //     bottom: true, width: 0.5, color: PdfColors.grey)
                    ),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  '$parsoli',
                  style: pw.TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      pw.Header(
          level: 3,
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Text(
                  'Información Extra:',
                  textScaleFactor: 1,
                  style: pw.TextStyle(color: PdfColors.blue),
                ),
              ])),
      pw.Padding(
        padding: pw.EdgeInsets.all(4.0),
        child: pw.Row(children: <pw.Widget>[
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text('PROCEDIMIENTO:  ',
                  style: pw.TextStyle(fontSize: 12.0)),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Center(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                    // border: BoxBorder(
                    //     bottom: true, width: 0.5, color: PdfColors.grey)
                    ),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  '-',
                  style: pw.TextStyle(fontSize: 12.0, color: PdfColors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(4.0),
        child: pw.Row(children: <pw.Widget>[
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text('FECHA DE ÚLTIMO CONTACTO:  ',
                  style: pw.TextStyle(fontSize: 12.0)),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Container(
              alignment: pw.Alignment.center,
              decoration: const pw.BoxDecoration(
                  // border: BoxBorder(
                  //     bottom: true, width: 0.5, color: PdfColors.grey)
                  ),
              child: pw.Text(' $diaf  -  $mesf  -  $anof',
                  style: pw.TextStyle(
                    fontSize: 12.0,
                  )),
            ),
          )
        ]),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(4.0),
        child: pw.Row(children: <pw.Widget>[
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              child: pw.Text('ÚLTIMA UBICACIÓN CONOCIDA:  ',
                  style: pw.TextStyle(fontSize: 12.0)),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Center(
              child: pw.Container(
                decoration: const pw.BoxDecoration(
                    // border: BoxBorder(
                    //     bottom: true, width: 0.5, color: PdfColors.grey)
                    ),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  '$direccionu',
                  style: pw.TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    ],
  ));

  final output = await getExternalStorageDirectory();
  final file = File("${output.path}/SOLICI_UBICA_$nofi.pdf");
  await file.writeAsBytes(await pdf.save());
  final Email email = Email(
    body: 'Generado desde Sezami Digital Móvil',
    subject: 'Solicitud de Localización',
    recipients: ['laetfuensanta@hotmail.com'],
    cc: ['sezami.zac@gmail.com', 'sezamiapp@gmail.com'],
    attachmentPath: "${output.path}/SOLICI_UBICA_$nofi.pdf",
    isHTML: false,
  );
  await FlutterEmailSender.send(email);
}
