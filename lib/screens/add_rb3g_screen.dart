import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/radiobase3g.dart';

class AddRb3GScreen extends StatefulWidget {
  const AddRb3GScreen({Key? key}) : super(key: key);

  @override
  _AddRb3GScreenState createState() => _AddRb3GScreenState();
}

class _AddRb3GScreenState extends State<AddRb3GScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _pscController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Radiobase 3G'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pscController,
                decoration: const InputDecoration(
                  labelText: 'PSC',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el PSC';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    RadioBase3G newRb = RadioBase3G(
                      nombre: _nombreController.text,
                      psc: _pscController.text,
                    );
                    await DatabaseHelper().insert3G(newRb);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}