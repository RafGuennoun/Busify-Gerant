
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  final path = (await getExternalStorageDirectory())!.path;
  final file = io.File('$path/$fileName');
  await file.writeAsBytes(
    bytes,
    flush: true
  );
  OpenFile.open('$path/$fileName');

}


Future<void> writhsmth(String data) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.BarcodeWidget(
          color: PdfColors.black,
          barcode: pw.Barcode.qrCode(),
          data: data,
        ),
        
      ),
    ),
  );

  List<int> bytes = await pdf.save();
  
  saveAndLaunchFile(bytes, 'Busify_Gerant.pdf');
}