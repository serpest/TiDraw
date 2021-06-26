import 'package:flutter/material.dart';

class DrawPage extends StatefulWidget {
  static const route = "/draw";

  final String id;

  DrawPage({Key? key, required this.id}) : super(key: key);

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draw'),
        centerTitle: true,
      ),
    );
  }
}
