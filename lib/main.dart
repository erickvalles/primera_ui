import 'package:flutter/material.dart';
import 'package:primera_ui/models/calculo.dart';
import './detail_page.dart';
import 'util/database.dart';
import 'dao/calculo_dao.dart';

Future<void> main() async {
  final database =
      await $FloorAppDatabase.databaseBuilder("calculos.db").build();
  final calculoDao = database.calculoDao;
  runApp(MyApp(calculoDao));
}

class MyApp extends StatelessWidget {
  final CalculoDao calculoDao;
  const MyApp(this.calculoDao);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interfaz gráfica para el lector CPMD',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'LectorCPMD', dao: calculoDao),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.dao});

  final String title;
  final CalculoDao dao;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Calculo> calculos = [];
  Calculo? calculoSeleccionado = null;

  _HomePageState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cargarCalculos();
  }

  void agregarCalculo(Calculo nuevoCalculo) {
    setState(() {
      calculos.add(nuevoCalculo);
    });
  }

  Future<void> _cargarCalculos() async {
    List<Calculo> listaCalculos = await widget.dao.todosCalculos();

    setState(() {
      calculos = listaCalculos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de cálculos'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            calculoSeleccionado =
                                Calculo(0, "", 0, 0, 0, "", "");
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        child: const Icon(Icons.add)),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                    itemCount: calculos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(calculos[index].nombre!),
                        subtitle: Text(calculos[index].nombreArchivo!),
                        onTap: () {
                          setState(() {
                            calculoSeleccionado = calculos[index];
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: calculoSeleccionado != null
                ? DetailPage(
                    calculo: calculoSeleccionado!,
                    dao: widget.dao,
                    agregarCalculo: agregarCalculo,
                  )
                : Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Text(
                        'Añada un nuevo cálculo o seleccione uno de la lista',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
