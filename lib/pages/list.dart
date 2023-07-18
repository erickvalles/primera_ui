import 'package:flutter/material.dart';

class ListaCalculos extends StatefulWidget {
  final List list;
  var selectedItemIndex = -1;
  ListaCalculos({Key? key, required this.list}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(list[index]),
          onTap: () {
            setState(() {
              selectedItemIndex = index;
            });
          },
        );
      },
    );
  }

  void setState(Null Function() param0) {}
}
