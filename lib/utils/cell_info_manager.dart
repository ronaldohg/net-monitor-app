import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_cell_info/flutter_cell_info.dart';
import 'package:permission_handler/permission_handler.dart';

class CellInfoManager {
  static String? currentDBM;
  static String? cellInfo;

  static Future<bool> requestPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      status = await Permission.phone.request();
    }
    return status.isGranted;
  }

  static Future<String?> initPlatformState() async {
    // Solicitar permisos primero
    bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      return "Permisos denegados";
    }

    try {
      String? platformVersion = await CellInfo.getCellInfo;
      if (platformVersion == null) {
        return "No se pudo obtener información de la celda";
      }
      print(platformVersion);
      final body = json.decode(platformVersion);

      

      // Aquí procesas la respuesta según la estructura de tu paquete
      // Esto es un ejemplo genérico - ajusta según la estructura real
      if (body is Map<String, dynamic>) {
        // Procesar la respuesta de la celda
        if (body.containsKey('lte')) {
          currentDBM = "LTE dbm = ${body['lte']['dbm']}";
        } else if (body.containsKey('nr')) {
          currentDBM = "NR dbm = ${body['nr']['dbm']}";
        } else if (body.containsKey('wcdma')) {
          currentDBM = "WCDMA dbm = ${body['wcdma']['dbm']}";
        }
      }

      // Obtener información SIM
      String? simInfo = await CellInfo.getSIMInfo;
      if (simInfo != null) {
        final simJson = json.decode(simInfo);
        cellInfo = "SIM Info: $simJson";
      }

      return cellInfo;
    } on PlatformException catch (e) {
      return "Error: ${e.message}";
    } catch (e) {
      return "Error inesperado: $e";
    }
  }

  static Future<String?> getCurrentCellId() async {
    try {
      String? platformVersion = await CellInfo.getCellInfo;
      if (platformVersion == null) return null;

      final body = json.decode(platformVersion);

      // Extraer CI o PSC según el tipo de celda
      if (body is Map<String, dynamic>) {
        if (body.containsKey('lte')) {
          return body['lte']['ci']?.toString();
        } else if (body.containsKey('wcdma')) {
          return body['wcdma']['psc']?.toString();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getCurrentCellType() async {
    try {
      String? platformVersion = await CellInfo.getCellInfo;
      if (platformVersion == null) return null;

      final body = json.decode(platformVersion);

      if (body is Map<String, dynamic>) {
        if (body.containsKey('lte')) return '4G';
        if (body.containsKey('wcdma')) return '3G';
        if (body.containsKey('nr')) return '5G';
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
