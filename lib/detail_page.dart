import 'package:flutter/material.dart';
import 'package:primera_ui/models/calculo.dart';

class DetailPage extends StatefulWidget {
  final Calculo calculo;

  const DetailPage({super.key, required this.calculo});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _boxSizeController = TextEditingController();
  final _numeroAtomosController = TextEditingController();
  final _tamHistogramaController = TextEditingController();
  final _nombreArchivoController = TextEditingController();
  final _dirSalidaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.calculo.nombre!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el nombre';
                  }
                  return null;
                },
              ),
              // Agregar TextFormField para las demás propiedades
              // Box Size, Número de átomos, Tamaño del histograma, etc.
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Crear una instancia de Calculo con los valores del formulario
                    Calculo nuevoCalculo = Calculo(
                      1, // El id podría ser generado automáticamente o asignado según tus necesidades
                      _nombreController.text,
                      double.tryParse(_boxSizeController.text),
                      int.tryParse(_numeroAtomosController.text),
                      int.tryParse(_tamHistogramaController.text),
                      _nombreArchivoController.text,
                      _dirSalidaController.text,
                    );

                    // Hacer lo que necesites con la nueva instancia de Calculo
                    // Por ejemplo, guardar en una base de datos, enviar a un servidor, etc.
                    print('Nuevo cálculo creado: ${nuevoCalculo.toString()}');
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
