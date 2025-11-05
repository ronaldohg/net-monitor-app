import 'package:flutter/material.dart';
import 'package:net_monitor_cubano/main.dart';
import 'package:net_monitor_cubano/screens/about_screen.dart';
import 'package:net_monitor_cubano/screens/rb3g_list_screen.dart';
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
      drawer: _buildDrawer(context),
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

    // Agregar este método en la clase _HomeScreenState:
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.cell_tower,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Net Monitor Cubano',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Versión 1.0.3',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Radiobases 3G'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Rb3GListScreen()),
              );
              // Cambiar al índice 1 programáticamente
              // Necesitaríamos un GlobalKey para el MainScreen
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Radiobases 4G'),
            onTap: () {
              Navigator.pop(context);
              
              // Cambiar al índice 2 programáticamente
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Acerca de'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          /*ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Contacto'),
            onTap: () {
              Navigator.pop(context);
              // Aquí podrías abrir el cliente de email
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
              // Futura pantalla de configuración
            },
          ),*/
        ],
      ),
    );
  }

}