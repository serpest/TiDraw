import 'package:flutter/material.dart';
import 'package:tidraw/api.dart';
import 'package:tidraw/model/draw.dart';

class DrawPage extends StatefulWidget {
  static const route = "/draw";

  final String id;

  DrawPage({Key? key, required this.id}) : super(key: key);

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  late Future<Draw> futureDraw;

  @override
  void initState() {
    super.initState();
    futureDraw = fetchDraw(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draw'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<Draw>(
          future: futureDraw,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // TODO
              return Text("Not yet implemented");
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
