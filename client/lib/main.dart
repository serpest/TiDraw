import 'package:flutter/material.dart';
import 'package:tidraw/pages/create_draw.dart';
import 'package:tidraw/pages/draw.dart';
import 'package:tidraw/pages/home.dart';
import 'package:tidraw/pages/search_draw.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiDraw',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (context) => HomePage(),
        CreateDrawPage.route: (context) => CreateDrawPage(),
        SearchDrawPage.route: (context) => SearchDrawPage(),
      },
      onGenerateRoute: (settings)  {
        if (settings.name == DrawPage.route) {
          return MaterialPageRoute(
            builder: (context) {
              return DrawPage(id: settings.arguments as String);
            },
          );
        }
      },
    );
  }
}
