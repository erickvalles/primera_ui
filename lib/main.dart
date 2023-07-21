import 'package:flutter/material.dart';
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
  final List<String> items = ['Item 1', 'Item 2', 'Item 3'];
  int selectedItemIndex = -1;

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
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          items.add("value");
                        });
                      },
                      icon: const Icon(Icons.add)),
                ),
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index]),
                        onTap: () {
                          setState(() {
                            selectedItemIndex = index;
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
            child: selectedItemIndex != -1
                ? DetailPage(item: items[selectedItemIndex])
                : Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Text(
                        'No item selected',
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
