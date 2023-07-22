import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
    _updateControllers(widget.calculo);
  }

  @override
  void didUpdateWidget(covariant DetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.calculo != oldWidget.calculo) {
      _updateControllers(widget.calculo);
    }
  }

  void _updateControllers(Calculo calculo) {
    _nombreController.text = calculo.nombre!;
    _boxSizeController.text = calculo.boxSize!.toString();
    _numeroAtomosController.text = calculo.numeroAtomos!.toString();
    _nombreArchivoController.text = calculo.nombreArchivo!;
    _dirSalidaController.text = calculo.dirSalida!;
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
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: nombreForm()),
                  SizedBox(width: 16),
                  Expanded(flex: 1, child: boxSizeForm()),
                  SizedBox(width: 16),
                  Expanded(flex: 1, child: numeroAtomosForm()),
                ],
              ),

              // Agregar TextFormField para las demás propiedades
              // Box Size, Número de átomos, Tamaño del histograma, etc.
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: filePickerForm(),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: directoryPickerForm(),
                  )
                ],
              ),
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

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      _nombreArchivoController.text = file.path;
    }
  }

  void getFolder() async {
    String? carpetaSalida = await FilePicker.platform.getDirectoryPath();
    if (carpetaSalida != null) {
      _dirSalidaController.text = carpetaSalida;
    }
  }

  Widget nombreForm() {
    return TextFormField(
      controller: _nombreController,
      decoration: InputDecoration(labelText: 'Nombre'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese el nombre';
        }
        return null;
      },
    );
  }

  Widget boxSizeForm() {
    return TextFormField(
      controller: _boxSizeController,
      decoration: InputDecoration(labelText: 'Tamaño de la caja'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese el tamaño de la caja';
        }
        return null;
      },
    );
  }

  Widget filePickerForm() {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextFormField(
            controller: _nombreArchivoController,
            readOnly: true,
            decoration: InputDecoration(
                labelText: 'Seleccione el archivo',
                suffixIcon: IconButton(
                  icon: Icon(Icons.file_open_outlined),
                  onPressed: () => getFile(),
                )),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, seleccione el archivo';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget directoryPickerForm() {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextFormField(
            controller: _dirSalidaController,
            readOnly: true,
            decoration: InputDecoration(
                labelText: 'Seleccione el directorio de salida',
                suffixIcon: IconButton(
                  icon: Icon(Icons.folder_open_outlined),
                  onPressed: () => getFolder(),
                )),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, seleccione el directorio de salida';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget numeroAtomosForm() {
    return TextFormField(
      controller: _numeroAtomosController,
      decoration: InputDecoration(labelText: 'Número de átomos'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese el número de átmos';
        }
        return null;
      },
    );
  }
}
