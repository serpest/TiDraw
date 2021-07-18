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
      onGenerateRoute: (settings) {
        // DrawPage.route generation
        final regex = RegExp(r'\' + DrawPage.route + r'\/[a-zA-Z0-9]+$');
        if (settings.name != null && regex.hasMatch(settings.name!)) {
          String id = settings.name!.substring(settings.name!.lastIndexOf('/') + 1);
          return MaterialPageRoute(
            builder: (context) {
              return DrawPage(id: id);
            },
            settings: settings,
          );
        }
      },
    );
  }
}
