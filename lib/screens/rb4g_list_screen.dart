import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/radiobase4g.dart';
import 'add_rb4g_screen.dart';
import '../utils/excel_helper.dart';

class Rb4GListScreen extends StatefulWidget {
  const Rb4GListScreen({Key? key}) : super(key: key);

  @override
  _Rb4GListScreenState createState() => _Rb4GListScreenState();
}

class _Rb4GListScreenState extends State<Rb4GListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<RadioBase4G> _rbList = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    List<RadioBase4G> list = await _dbHelper.getAll4G();
    setState(() {
      _rbList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radiobases 4G'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'export') {
                ExcelHelper.export4GToExcel();
              } else if (value == 'import') {
                ExcelHelper.import4GFromExcel().then((_) => _refreshList());
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
          RadioBase4G rb = _rbList[index];
          return Dismissible(
            key: Key(rb.id.toString()),
            background: Container(color: Colors.red),
            onDismissed: (direction) async {
              await _dbHelper.delete4G(rb.id!);
              _refreshList();
            },
            child: ListTile(
              title: Text(rb.nombre),
              subtitle: Text('CI: ${rb.ci}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRb4GScreen()),
          );
          _refreshList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}