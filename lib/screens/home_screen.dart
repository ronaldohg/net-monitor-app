import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cell_info/cell_response.dart';
import 'package:flutter_cell_info/flutter_cell_info.dart';
import 'package:flutter_cell_info/models/common/cell_type.dart';
import 'package:flutter_cell_info/sim_info_response.dart';
import 'package:permission_handler/permission_handler.dart';
import '../database/database_helper.dart';
import '../models/radiobase3g.dart';
import '../models/radiobase4g.dart';
import '../utils/cell_info_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String? _selectedType;
  String _inputValue = '';
  String _result = '';
  String _cellInfoText = '';
  bool _isLoading = false;
  List<String> _cellInformation = [];

  CellsResponse? _cellsResponse;

  String? currentDBM;

  Timer? timer;

  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeCellInfo();
    startTimer();
    // checkAndRequestPermissions();
  }

  Future<void> _initializeCellInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await CellInfoManager.initPlatformState();

      // Obtener información automáticamente para pre-llenar campos
      String? cellType = await CellInfoManager.getCurrentCellType();
      String? cellId = await CellInfoManager.getCurrentCellId();

      if (cellType != null && cellId != null) {
        setState(() {
          _selectedType = cellType;
          _inputValue = cellId;
          _inputController.text = cellId;
        });
      }

      setState(() {
        _cellInfoText = CellInfoManager.cellInfo ?? 'Información no disponible';
      });
    } catch (e) {
      setState(() {
        _cellInfoText = 'Error obteniendo información: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshCellInfo() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    await _initializeCellInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ver información de radiobase')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información de la celda actual
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          shape: Border(),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Información de Celda Actual:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text("$currentDBM"),
                                mostrarInfo(),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Formulario de búsqueda
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        items: const [
                          DropdownMenuItem(
                            value: '3G',
                            child: Text('Radiobase 3G'),
                          ),
                          DropdownMenuItem(
                            value: '4G',
                            child: Text('Radiobase 4G'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                            _inputValue = '';
                            _inputController.text = '';
                            _result = '';
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Tipo de Radiobase',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (_selectedType != null)
                        TextFormField(
                          controller: _inputController,
                          decoration: InputDecoration(
                            labelText: _selectedType == '3G' ? 'PSC' : 'CI',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _performSearch,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _inputValue = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa un valor';
                            }
                            return null;
                          },
                        ),

                      const SizedBox(height: 16),

                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _performSearch,
                          icon: const Icon(Icons.search),
                          label: const Text('Buscar en Base de Datos'),
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (_result.isNotEmpty)
                        Card(
                          color: Colors.blue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Resultado de Búsqueda:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _result,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(oneSec, (Timer timer) {
      initPlatformState();
    });
  }

  Widget mostrarInfo() {
    String allInfo = '';
    for (String info in _cellInformation) {
      allInfo += info + "\n";
    }
    return Text(allInfo);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    CellsResponse? cellsResponse;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String? platformVersion = await CellInfo.getCellInfo;
      final body = json.decode(platformVersion!);

      //print(body);

      cellsResponse = CellsResponse.fromJson(body);

      if (cellsResponse.primaryCellList == null) {
        return;
      }

      if (cellsResponse.primaryCellList == []) {
        return;
      }
      CellType currentCellInFirstChip = cellsResponse.primaryCellList![0];

      if (currentCellInFirstChip.type == "LTE") {
        RadioBase4G? rb = await _dbHelper.get4GByCI(
          "${currentCellInFirstChip.lte?.enb}${currentCellInFirstChip.lte?.cid}",
        );
        currentDBM = "LTE dbm = ${currentCellInFirstChip.lte?.signalLTE?.rsrp}";
        _cellInformation = [];
        _cellInformation.add("Tipo: ${currentCellInFirstChip.lte?.type}");
        _cellInformation.add(
          "Estado: ${currentCellInFirstChip.lte?.connectionStatus}",
        );
        _cellInformation.add(
          "Ancho de banda: ${currentCellInFirstChip.lte?.bandwidth}",
        );
        _cellInformation.add("TAC: ${currentCellInFirstChip.lte?.tac}");
        _cellInformation.add(
          "CI: ${currentCellInFirstChip.lte?.enb}:${currentCellInFirstChip.lte?.cid}",
        );
        _cellInformation.add("PCI: ${currentCellInFirstChip.lte?.pci}");
        _cellInformation.add(
          "EARFCN: ${currentCellInFirstChip.lte?.bandLTE?.downlinkEarfcn}",
        );
        _cellInformation.add(
          "BANDA: ${currentCellInFirstChip.lte?.bandLTE?.name}",
        );
        _cellInformation.add("ECGI: ${currentCellInFirstChip.lte?.ecgi}");
        _cellInformation.add("ECI: ${currentCellInFirstChip.lte?.eci}");
        _cellInformation.add(
          "SNR: ${currentCellInFirstChip.lte?.signalLTE?.snr}",
        );
        _cellInformation.add("\nNodo: ${rb?.nombre ?? "No encontrado"}");
      } else if (currentCellInFirstChip.type == "NR") {
        currentDBM = "NR dbm = ${currentCellInFirstChip.nr?.signalNR?.dbm}";
      } else if (currentCellInFirstChip.type == "WCDMA") {
        RadioBase3G? rb = await _dbHelper.get3GByPSC(
          "${currentCellInFirstChip.wcdma?.psc}",
        );
        currentDBM =
            "WCDMA dbm = ${currentCellInFirstChip.wcdma?.signalWCDMA?.dbm}";
        _cellInformation = [];
        _cellInformation.add("Tipo: ${currentCellInFirstChip.wcdma?.type}");
        _cellInformation.add(
          "Estado: ${currentCellInFirstChip.wcdma?.connectionStatus}",
        );
        _cellInformation.add("LAC: ${currentCellInFirstChip.wcdma?.lac}");
        _cellInformation.add("CID: ${currentCellInFirstChip.wcdma?.cid}");
        _cellInformation.add("RNC: ${currentCellInFirstChip.wcdma?.rnc}");
        _cellInformation.add("PSC: ${currentCellInFirstChip.wcdma?.psc}");
        _cellInformation.add(
          "UARFCN: ${currentCellInFirstChip.wcdma?.bandWCDMA?.downlinkUarfcn}",
        );
        _cellInformation.add(
          "Band: ${currentCellInFirstChip.wcdma?.bandWCDMA?.name}",
        );
        _cellInformation.add("CI: ${currentCellInFirstChip.wcdma?.ci}");
        _cellInformation.add("CGI: ${currentCellInFirstChip.wcdma?.cgi}");
        _cellInformation.add("\nNodo: ${rb?.nombre ?? "No encontrado"}");

        // print('currentDBM = ' + currentDBM!);
      }

      String? simInfo = await CellInfo.getSIMInfo;
      final simJson = json.decode(simInfo!);
      // print("display name ${SIMInfoResponse.fromJson(simJson).simInfoList}");
    } catch (e) {
      _cellsResponse = null;
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _cellsResponse = cellsResponse;
    });
  }

  Future<void> _performSearch() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_selectedType == '3G') {
          RadioBase3G? rb = await _dbHelper.get3GByPSC(_inputValue);
          setState(() {
            _result = rb?.nombre ?? 'No encontrado en la base de datos 3G';
          });
        } else if (_selectedType == '4G') {
          RadioBase4G? rb = await _dbHelper.get4GByCI(_inputValue);
          setState(() {
            _result = rb?.nombre ?? 'No encontrado en la base de datos 4G';
          });
        }
      } catch (e) {
        setState(() {
          _result = 'Error en la búsqueda: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> checkAndRequestPermissions() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }

    status = await Permission.phone.status;
    if (!status.isGranted) {
      await Permission.phone.request();
    }
  }
}
