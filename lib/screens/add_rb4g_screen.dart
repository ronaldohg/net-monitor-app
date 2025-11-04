import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/radiobase4g.dart';

class AddRb4GScreen extends StatefulWidget {
  const AddRb4GScreen({Key? key}) : super(key: key);

  @override
  _AddRb4GScreenState createState() => _AddRb4GScreenState();
}

class _AddRb4GScreenState extends State<AddRb4GScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ciController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Radiobase 4G'),
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
                controller: _ciController,
                decoration: const InputDecoration(
                  labelText: 'CI',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el CI';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    RadioBase4G newRb = RadioBase4G(
                      nombre: _nombreController.text,
                      ci: _ciController.text,
                    );
                    await DatabaseHelper().insert4G(newRb);
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