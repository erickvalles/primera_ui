import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:lector_cpmd/dao/calculo_dao.dart';
import 'package:lector_cpmd/models/calculo.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

class DetailPage extends StatefulWidget {
  final Calculo calculo;
  final CalculoDao dao;
  final Function(Calculo) agregarCalculo;
  final Function() actualizarLista;
  final Function() calculoEliminado;
  final bool nuevoCalculo;

  const DetailPage(
      {super.key,
      required this.calculo,
      required this.dao,
      required this.agregarCalculo,
      required this.nuevoCalculo,
      required this.actualizarLista,
      required this.calculoEliminado});

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
  final _gofrFileController = TextEditingController();
  final _coordFileController = TextEditingController();
  final _skFileController = TextEditingController();
  final _angulosFileController = TextEditingController();
  final _outputTextController = TextEditingController();
  final _otroTextController = TextEditingController();
  final _espacioController = TextEditingController();
  final _trayectoriasMargenController = TextEditingController();
  final _tiempoIntegracionController = TextEditingController();
  final _MSDController = TextEditingController();
  final _VACController = TextEditingController();
  final _DiffConstantController = TextEditingController();

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
    _tamHistogramaController.text = calculo.tamHistograma!.toString();
    _gofrFileController.text = calculo.salidaGdr!.toString();
    _coordFileController.text = calculo.salidaCoord!.toString();
    _skFileController.text = calculo.salidaSk!.toString();
    _angulosFileController.text = calculo.salidaAngulos!.toString();
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
                  Expanded(flex: 1, child: nombreForm()),
                  SizedBox(width: 16),
                  Expanded(flex: 1, child: boxSizeForm()),
                  SizedBox(width: 16),
                  Expanded(flex: 1, child: numeroAtomosForm()),
                  SizedBox(width: 16),
                  Expanded(flex: 1, child: tamHistogramaForm()),
                  SizedBox(
                    width: 16,
                  ),
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
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          labelPropiedades("Propiedades estructurales"),
                          runGofRForm(),
                          runCoordForm(),
                          runSkForm(),
                          runAngulosForm(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          labelPropiedades("Propiedades dinámicas",
                              config: true),
                          runMSDForm(),
                          DiffConstantForm(),
                          runVACForm(),
                          SizedBox(
                            height: 112,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: outputForm(),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Crear una instancia de Calculo con los valores del formulario
                        Calculo nuevoCalculo = Calculo(
                            null, // El id podría ser generado automáticamente o asignado según tus necesidades
                            _nombreController.text,
                            double.tryParse(_boxSizeController.text),
                            int.tryParse(_numeroAtomosController.text),
                            int.tryParse(_tamHistogramaController.text),
                            _nombreArchivoController.text,
                            _dirSalidaController.text,
                            _gofrFileController.text,
                            _coordFileController.text,
                            _skFileController.text,
                            _angulosFileController.text);

                        // Hacer lo que necesites con la nueva instancia de Calculo
                        // Por ejemplo, guardar en una base de datos, enviar a un servidor, etc.
                        int id = await _insertarCalculo(nuevoCalculo);
                        nuevoCalculo.id = id;
                        widget.agregarCalculo(nuevoCalculo);
                        widget.calculo.id = nuevoCalculo.id;
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        scaffoldMessenger.showSnackBar(const SnackBar(
                          content: Text("Nuevo cálculo creado!"),
                          duration: Duration(seconds: 3),
                        ));
                        print(
                            'Nuevo cálculo creado con el id: ${nuevoCalculo.toString()}');
                      }
                    },
                    child: widget.nuevoCalculo
                        ? Text('Guardar')
                        : Text("Duplicar"),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _actualizaCalculo(widget.calculo);

                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      scaffoldMessenger.showSnackBar(SnackBar(
                        content: Text("Cálculo actualizado"),
                        duration: Duration(seconds: 3),
                      ));
                      //widget.dao.actualizaCalculo();
                    },
                    child: Text("Actualizar"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.dao.borrarCalculo(widget.calculo);
                      widget.actualizarLista();
                    },
                    child: Text("Eliminar"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _dialogoConfig(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Configurar propiedades dinámicas"),
            content: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Espacio entre trayectorias',
                      ),
                      controller: _espacioController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese el espacio entre trayectorias';
                        }
                        return null;
                      }),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Trayectorias margen',
                    ),
                    controller: _trayectoriasMargenController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tiempo de integración',
                    ),
                    controller: _tiempoIntegracionController,
                  )
                ],
              )),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    print(_otroTextController.text);
                  },
                  child: Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    //_abrirContenedora();
                    Navigator.of(context).pop();
                  },
                  child: Text("Aceptar"))
            ],
          );
        });
  }

  Widget labelPropiedades(String etiqueta, {bool config = false}) {
    return Row(
      children: [
        Text(
          etiqueta,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (config)
          Container(
            child: IconButton(
                onPressed: () {
                  _dialogoConfig(context);
                },
                icon: const Icon(Icons.settings)),
          ),
      ],
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

  Widget outputForm() {
    return TextFormField(
      minLines: 5,
      maxLines: null,
      controller: _outputTextController,
      decoration: InputDecoration(
          labelText: 'Output',
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _outputTextController.text = "",
          ),
          suffixIconColor: Colors.red),
      readOnly: true,
    );
  }

  Widget tamHistogramaForm() {
    return TextFormField(
      controller: _tamHistogramaController,
      decoration: InputDecoration(labelText: 'Tamaño del histograma'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese el tamaño del histograma';
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

  Widget runGofRForm() {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextFormField(
            controller: _gofrFileController,
            readOnly: true,
            decoration: InputDecoration(
                labelText: 'Calcular función de distribución radial g(r)',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        _rungOfR();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.show_chart),
                      onPressed: () {
                        _runGnuPlot(1);
                      },
                    ),
                  ],
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

  Widget runCoordForm() {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextFormField(
            controller: _coordFileController,
            readOnly: true,
            decoration: InputDecoration(
                labelText: 'Calcular coordinación promedio Z(r)',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /*IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        _rungOfR();
                      },
                    ),*/
                    IconButton(
                      icon: Icon(Icons.show_chart),
                      onPressed: () {
                        _runGnuPlot(2);
                      },
                    ),
                  ],
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

  Widget runSkForm() {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextFormField(
            controller: _skFileController,
            readOnly: true,
            decoration: InputDecoration(
                labelText: 'Calcular el factor de estructura estático S(k)',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /*IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        _rungOfR();
                      },
                    ),*/
                    IconButton(
                      icon: Icon(Icons.show_chart),
                      onPressed: () {
                        _runGnuPlot(3);
                      },
                    ),
                  ],
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

  Widget DiffConstantForm() {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextFormField(
            controller: _DiffConstantController,
            readOnly: true,
            decoration: const InputDecoration(
                labelText: 'Constante de difusión D(t)',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
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

  Widget runAngulosForm() {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextFormField(
            controller: _angulosFileController,
            readOnly: true,
            decoration: InputDecoration(
                labelText: 'Calcular la distribución de ángulos',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        _runAngulos();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.show_chart),
                      onPressed: () {
                        _runGnuPlot(4);
                      },
                    ),
                  ],
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

  void _rungOfR() async {
    Loader.show(context, progressIndicator: LinearProgressIndicator());
    try {
      final result =
          await Process.run("/home/erick/code/lector-cpmd/build/gdr", [
        _boxSizeController.text,
        _numeroAtomosController.text,
        _tamHistogramaController.text,
        _nombreArchivoController.text,
        _dirSalidaController.text,
        "1"
      ]);
      Loader.hide();
      print("Comenzó la ejecución:");
      print("Exit code: ${result.exitCode}");
      print("Salida estándar: ${result.stdout}");
      print("Error: ${result.stderr}");
      _outputTextController.text = result.stdout;

      List<String> partes = _outputTextController.text.split("\n");
      _gofrFileController.text = partes[7].split(":")[1];
      _coordFileController.text = partes[8].split(":")[1];
      _skFileController.text = partes[11].split(":")[1];
    } catch (e) {
      print("Error $e");
    }
  }

  Widget runMSDForm() {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextFormField(
            controller: _MSDController,
            readOnly: true,
            decoration: InputDecoration(
                labelText: 'Calcular el desplazamiento cuadrático medio MSD',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        _runMSD();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.show_chart),
                      onPressed: () {
                        _runGnuPlot(5);
                      },
                    ),
                  ],
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

  Widget runVACForm() {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextFormField(
            controller: _VACController,
            readOnly: true,
            decoration: InputDecoration(
                labelText: 'Calcular la correlación de velocidades VAC',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        _runVAC();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.show_chart),
                      onPressed: () {
                        _runGnuPlot(6);
                      },
                    ),
                  ],
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

  void _runMSD() async {
    Loader.show(context, progressIndicator: LinearProgressIndicator());
    try {
      final result = await Process.run("/home/erick/code/dinamicas/msd", [
        _espacioController.text,
        _numeroAtomosController.text,
        _trayectoriasMargenController.text,
        _nombreArchivoController.text,
        _dirSalidaController.text,
        "1",
        _tiempoIntegracionController.text
      ]);
      Loader.hide();
      print("Comenzó la ejecución:");
      print("Exit code: ${result.exitCode}");
      print("Salida estándar: ${result.stdout}");
      print("Error: ${result.stderr}");
      _outputTextController.text = result.stdout;

      List<String> partes = _outputTextController.text.split("\n");
      _MSDController.text = partes[4].split(":")[1].trim();
      _DiffConstantController.text = partes[3].split(":")[1].trim();
    } catch (e) {
      print("Error $e");
    }
  }

  void _runVAC() async {
    Loader.show(context, progressIndicator: CircularProgressIndicator());
    try {
      final result = await Process.run("/home/erick/code/dinamicas/vac", [
        _espacioController.text,
        _numeroAtomosController.text,
        _trayectoriasMargenController.text,
        _nombreArchivoController.text,
        _dirSalidaController.text,
        "1",
        _tiempoIntegracionController.text
      ]);
      print("Comenzó la ejecución:");
      print("Exit code: ${result.exitCode}");
      print("Salida estándar: ${result.stdout}");
      print("Error: ${result.stderr}");
      _outputTextController.text = result.stdout;

      Loader.hide();
      List<String> partes = _outputTextController.text.split("\n");
      _VACController.text = partes[6].split(":")[1].trim();
    } catch (e) {
      print("Error $e");
    }
  }

  void _runAngulos() async {
    Loader.show(context, progressIndicator: LinearProgressIndicator());
    try {
      final result = await Process.run("/home/erick/code/lector-cpmd/angulos", [
        _boxSizeController.text,
        _numeroAtomosController.text,
        _tamHistogramaController.text,
        _nombreArchivoController.text,
        _dirSalidaController.text,
        "1"
      ]);
      Loader.hide();
      print("Comenzó la ejecución:");
      print("Exit code: ${result.exitCode}");
      print("Salida estándar: ${result.stdout}");
      print("Error: ${result.stderr}");
      _outputTextController.text = result.stdout;

      List<String> partes = _outputTextController.text.split("\n");
      _angulosFileController.text = partes[4].split(":")[1];
    } catch (e) {
      print("Error $e");
    }
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
                /*prefixIcon: IconButton(
                  icon: Icon(
                    Icons.folder_open,
                    color: Colors.green,
                  ),
                  onPressed: () => _abrirContenedora(),
                ),*/
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

  String _generaGrafica(int opc) {
    String result;
    switch (opc) {
      case 1:
        result = "plot \"${_gofrFileController.text}\" using 2:3 with lines";
        break;
      case 2:
        result =
            " set xrange[2.1:3.9]; plot \"${_coordFileController.text}\" using 1:2 with lines";
        break;
      case 3:
        result =
            " set xrange[0:16]; plot \"${_skFileController.text}\" using 2:6 with lines;";
        break;
      case 4:
        result = "plot \"${_angulosFileController.text}\" using 1:2 with lines";
        break;
      case 5:
        result = "plot \"${_MSDController.text}\" using 1:2 with lines";
        break;
      case 6:
        result = "plot \"${_VACController.text}\" using 1:4 with lines";
        break;
      default:
        result = "plot \"${_gofrFileController.text}\" using 2:3 with lines";
        break;
    }
    return result;
  }

  void _runGnuPlot(int opc) async {
    try {
      final result =
          await Process.run("gnuplot", ["-p", "-e", _generaGrafica(opc)]);
      print("Se llama a gnuplot:");
      print("Exit code: ${result.exitCode}");
      print("Salida estándar: ${result.stdout}");
      print("Error: ${result.stderr}");
      //_outputTextController.text = result.stdout;
    } catch (e) {
      print("Error $e");
    }
  }

  _abrirContenedora() {
    FlutterIsolate.spawn(_openFileExplorer, _dirSalidaController.text);
  }

  static void _openFileExplorer(String path) {
    OpenFile.open(path);
  }

  void _actualizaCalculo(Calculo calculo) {
    calculo.nombre = _nombreController.text;
    calculo.boxSize = double.tryParse(_boxSizeController.text);
    calculo.numeroAtomos = int.tryParse(_numeroAtomosController.text);
    calculo.tamHistograma = int.tryParse(_tamHistogramaController.text);
    calculo.nombreArchivo = _nombreArchivoController.text;
    calculo.dirSalida = _dirSalidaController.text;
    calculo.salidaGdr = _gofrFileController.text;
    calculo.salidaCoord = _coordFileController.text;
    calculo.salidaSk = _skFileController.text;
    calculo.salidaAngulos = _angulosFileController.text;

    widget.dao.actualizaCalculo(calculo);
  }

  Future<int> _insertarCalculo(Calculo nuevoCalculo) async {
    int idInsertado = await widget.dao.insertarCalculo(nuevoCalculo);
    return idInsertado;
  }
}
