import 'package:flutter/material.dart';
class DetailPage extends StatefulWidget {
  final String item;

  DetailPage({required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          widget.item,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}