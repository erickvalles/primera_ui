import 'package:flutter/material.dart';
import './detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interfaz gráfica para el lector CPMD',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'LectorCPMD'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

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
          IconButton(
            onPressed: () {
              setState(() {
                items.add("value");
              });
            },
            icon: const Icon(Icons.add)),
          Expanded(
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

