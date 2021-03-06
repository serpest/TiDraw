import 'package:flutter/material.dart';
import 'package:tidraw/pages/draw.dart';
import 'package:tidraw/utils/constants.dart' as constants;
import 'package:tidraw/utils/string_format_extension.dart';

class SearchDrawPage extends StatefulWidget {
  static const route = '/search-draw';

  @override
  _SearchDrawPageState createState() => _SearchDrawPageState();
}

class _SearchDrawPageState extends State<SearchDrawPage> {
  final _formKey = GlobalKey<FormState>();

  final idController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search draw'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.qr_code),
              labelText: 'Draw ID *',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'The draw ID must not be empty';
              }
              if (value.length != constants.DRAW_ID_LENGTH) {
                return 'The draw ID must be ' + constants.DRAW_ID_LENGTH.toString() +  ' characters long';
              }
              return null;
            },
            controller: idController,
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton.icon(
        icon: Icon(Icons.search),
        label: Text('Search'),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            )
          ),
        ),
        onPressed: () {
          if (_formKey.currentState != null && _formKey.currentState!.validate()) {
            Navigator.pushNamed(
              context,
              DrawPage.route.format([idController.text]),
            );
          }
        },
      ),
    );
  }
}
