import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/radiobase3g.dart';
import '../models/radiobase4g.dart';

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver información de radiobase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: const [
                  DropdownMenuItem(value: '3G', child: Text('Radiobase 3G')),
                  DropdownMenuItem(value: '4G', child: Text('Radiobase 4G')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                    _inputValue = '';
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
                  decoration: InputDecoration(
                    labelText: _selectedType == '3G' ? 'PSC' : 'CI',
                    border: const OutlineInputBorder(),
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedType == '3G') {
                      RadioBase3G? rb = await _dbHelper.get3GByPSC(_inputValue);
                      setState(() {
                        _result = rb?.nombre ?? 'No encontrado';
                      });
                    } else if (_selectedType == '4G') {
                      RadioBase4G? rb = await _dbHelper.get4GByCI(_inputValue);
                      setState(() {
                        _result = rb?.nombre ?? 'No encontrado';
                      });
                    }
                  }
                },
                child: const Text('Buscar'),
              ),
              const SizedBox(height: 16),
              Text(
                'Resultado: $_result',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}