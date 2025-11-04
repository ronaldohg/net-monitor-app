import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/radiobase3g.dart';
import 'add_rb3g_screen.dart';
import '../utils/excel_helper.dart';

class Rb3GListScreen extends StatefulWidget {
  const Rb3GListScreen({Key? key}) : super(key: key);

  @override
  _Rb3GListScreenState createState() => _Rb3GListScreenState();
}

class _Rb3GListScreenState extends State<Rb3GListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<RadioBase3G> _rbList = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    List<RadioBase3G> list = await _dbHelper.getAll3G();
    setState(() {
      _rbList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radiobases 3G'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'export') {
                ExcelHelper.export3GToExcel();
              } else if (value == 'import') {
                ExcelHelper.import3GFromExcel().then((_) => _refreshList());
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'export', child: Text('Exportar a Excel')),
              const PopupMenuItem(value: 'import', child: Text('Importar desde Excel')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _rbList.length,
        itemBuilder: (context, index) {
          RadioBase3G rb = _rbList[index];
          return Dismissible(
            key: Key(rb.id.toString()),
            background: Container(color: Colors.red),
            onDismissed: (direction) async {
              await _dbHelper.delete3G(rb.id!);
              _refreshList();
            },
            child: ListTile(
              title: Text(rb.nombre),
              subtitle: Text('PSC: ${rb.psc}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRb3GScreen()),
          );
          _refreshList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}