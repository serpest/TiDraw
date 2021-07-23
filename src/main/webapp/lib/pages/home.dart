import 'package:flutter/material.dart';
import 'package:tidraw/pages/create_draw.dart';
import 'package:tidraw/pages/search_draw.dart';

class HomePage extends StatelessWidget {
  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TiDraw'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Simple and trustable draws',
            style: TextStyle(
              fontSize: 32.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton.icon(
                icon: Icon(Icons.add_circle_outline),
                label: Text('Create draw'),
                onPressed: () {
                  Navigator.pushNamed(context, CreateDrawPage.route);
                },
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.search),
                label: Text('Search draw'),
                onPressed: () {
                  Navigator.pushNamed(context, SearchDrawPage.route);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
