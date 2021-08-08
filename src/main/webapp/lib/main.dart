import 'package:flutter/material.dart';
import 'package:tidraw/pages/create_draw.dart';
import 'package:tidraw/pages/draw.dart';
import 'package:tidraw/pages/edit_draw.dart';
import 'package:tidraw/pages/home.dart';
import 'package:tidraw/pages/search_draw.dart';
import 'package:tidraw/utils/string_format_extension.dart';

import 'model/draw.dart';

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
        final drawPageRegex = RegExp(DrawPage.route.replaceAll('/', '\/').format([r'[a-zA-Z0-9]{24}']) + r'$'); // It matches only 24 characters IDs
        if (settings.name != null && drawPageRegex.hasMatch(settings.name!)) {
          String id = settings.name!.substring(settings.name!.lastIndexOf('/') + 1);
          return MaterialPageRoute(
            builder: (context) {
              return DrawPage(id: id);
            },
            settings: settings,
          );
        }
        final editDrawPageRegex = RegExp(EditDrawPage.route.replaceAll('/', '\/').format([r'[a-zA-Z0-9]{24}']) + r'$'); // It matches only 24 characters IDs
        if (settings.name != null && editDrawPageRegex.hasMatch(settings.name!)) {
          if (settings.arguments == null) {
            return null; // TODO
          } else {
            assert (settings.arguments is Draw);
            return MaterialPageRoute(
              builder: (context) {
                return EditDrawPage(originalDraw: settings.arguments! as Draw);
              },
              settings: settings,
            );
          }
        }
      },
    );
  }
}
