import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const route = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TiDraw'),
        centerTitle: true,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton.icon(
              icon: Icon(Icons.add_circle_outline),
              label: Text('Create draw'),
              onPressed: () {
                Navigator.pushNamed(context, '/create-draw');
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.search),
              label: Text('Search draw'),
              onPressed: () {
                Navigator.pushNamed(context, '/search-draw');
              },
            ),
          ],
        ),
      ),
    );
  }
}
