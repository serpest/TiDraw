import 'package:flutter/material.dart';
import 'package:tidraw/pages/create_draw.dart';
import 'package:tidraw/pages/draw.dart';
import 'package:tidraw/pages/edit_draw.dart';
import 'package:tidraw/pages/home.dart';
import 'package:tidraw/pages/search_draw.dart';
import 'package:tidraw/utils/constants.dart' as constants;
import 'package:tidraw/utils/string_format_extension.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final drawPageRegex = RegExp(DrawPage.route.replaceAll('/', '\/').format([r'[a-zA-Z0-9]{' + constants.DRAW_ID_LENGTH.toString() + r'}']) + r'$');
  final editDrawPageRegex = RegExp(EditDrawPage.route.replaceAll('/', '\/').format([r'[a-zA-Z0-9]{' + constants.DRAW_ID_LENGTH.toString() + r'}']) + r'$');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiDraw',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        CreateDrawPage.route: (context) => CreateDrawPage(),
        SearchDrawPage.route: (context) => SearchDrawPage(),
      },
      onGenerateRoute: (settings) {
        // DrawPage.route generation
        if (settings.name != null && drawPageRegex.hasMatch(settings.name!)) {
          String id = settings.name!.substring(settings.name!.lastIndexOf('/') + 1);
          return MaterialPageRoute(
            builder: (context) {
              return DrawPage(id: id);
            },
            settings: settings,
          );
        }
        // EditDrawPage.route generation
        if (settings.name != null && editDrawPageRegex.hasMatch(settings.name!)) {
          String id = settings.name!.substring(settings.name!.lastIndexOf('/', settings.name!.length - 6) + 1, settings.name!.length - 5);
          return MaterialPageRoute(
            builder: (context) {
              return EditDrawPage(id: id);
            },
            settings: settings,
          );
        }
      },
    );
  }
}
