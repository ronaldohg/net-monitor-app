import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../database/database_helper.dart';
import '../models/radiobase3g.dart';
import '../models/radiobase4g.dart';

class ExcelHelper {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  // Exportar 3G a Excel
  static Future<void> export3GToExcel() async {
    List<RadioBase3G> list = await _dbHelper.getAll3G();
    var excel = Excel.createExcel();
    var sheet = excel['RadioBases3G'];

    

    // Encabezados
    sheet.appendRow([TextCellValue('Nombre') , TextCellValue('PSC')]);

    // Datos
    for (var rb in list) {
      sheet.appendRow([TextCellValue(rb.nombre), TextCellValue(rb.psc)]);
    }

    // Guardar
    String outputFile = 'RadioBases3G_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    var fileBytes = excel.save(fileName: outputFile);
    Directory? directory = await getExternalStorageDirectory();
    String path = '${directory!.path}/$outputFile';
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    // Abrir el archivo
    OpenFile.open(path);
  }

  // Exportar 4G a Excel
  static Future<void> export4GToExcel() async {
    List<RadioBase4G> list = await _dbHelper.getAll4G();
    var excel = Excel.createExcel();
    var sheet = excel['RadioBases4G'];

    // Encabezados
    sheet.appendRow([TextCellValue('Nombre'), TextCellValue('CI')]);

    // Datos
    for (var rb in list) {
      sheet.appendRow([TextCellValue(rb.nombre), TextCellValue(rb.ci)]);
    }

    // Guardar
    String outputFile = 'RadioBases4G_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    var fileBytes = excel.save(fileName: outputFile );
    Directory? directory = await getExternalStorageDirectory();
    String path = '${directory!.path}/$outputFile';
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    // Abrir el archivo
    OpenFile.open(path);
  }

  // Importar 3G desde Excel
  static Future<void> import3GFromExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        for (var row in sheet.rows) {
          if (row.length >= 2 && row[0] != null && row[1] != null) {
            String nombre = row[0]!.value.toString();
            String psc = row[1]!.value.toString();
            if (nombre.isNotEmpty && psc.isNotEmpty && nombre != 'Nombre') {
              RadioBase3G newRb = RadioBase3G(nombre: nombre, psc: psc);
              await _dbHelper.insert3G(newRb);
            }
          }
        }
      }
    }
  }

  // Importar 4G desde Excel
  static Future<void> import4GFromExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        for (var row in sheet.rows) {
          if (row.length >= 2 && row[0] != null && row[1] != null) {
            String nombre = row[0]!.value.toString();
            String ci = row[1]!.value.toString();
            if (nombre.isNotEmpty && ci.isNotEmpty && nombre != 'Nombre') {
              RadioBase4G newRb = RadioBase4G(nombre: nombre, ci: ci);
              await _dbHelper.insert4G(newRb);
            }
          }
        }
      }
    }
  }
}