import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tidraw/api.dart' as api;
import 'package:tidraw/model/draw.dart';
import 'package:tidraw/pages/draw.dart';
import 'package:tidraw/utils/constants.dart' as constants;
import 'package:tidraw/utils/string_format_extension.dart';

class CreateDrawPage extends StatefulWidget {
  static const route = '/create-draw';

  @override
  _CreateDrawPageState createState() => _CreateDrawPageState();
}

class _CreateDrawPageState extends State<CreateDrawPage> {
  final _formKey = GlobalKey<FormState>();

  List<String> raffleElements = [];

  final nameController = TextEditingController();
  final drawDateController = TextEditingController();
  final drawTimeController = TextEditingController();
  final selectedElementsSizeController = TextEditingController();
  final addRaffleElementController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    drawDateController.dispose();
    drawTimeController.dispose();
    selectedElementsSizeController.dispose();
    addRaffleElementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create draw'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.label),
                      labelText: 'Name *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length > 280) {
                        return 'The name length must be between 1 and 280 characters';
                      }
                      return null;
                    },
                    controller: nameController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.date_range),
                      labelText: 'Draw date',
                    ),
                    validator: (value) {
                      // TODO
                      if (value == null || value.isEmpty) {
                        return null;
                      } else if (!constants.DATE_REGEX.hasMatch(value)) {
                        return 'The date must be formatted like 2021-08-30';
                      }
                      return null;
                    },
                    controller: drawDateController,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100, 12, 31),
                      );
                      if (date != null) {
                        drawDateController.text = DateFormat('yyyy-MM-dd').format(date);
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.access_time),
                      labelText: 'Draw time',
                    ),
                    validator: (value) {
                      // TODO
                      if (value == null || value.isEmpty) {
                        return null;
                      } else if (!constants.TIME_REGEX.hasMatch(value)) {
                        return 'The time must be formatted like 02:46';
                      }
                      return null;
                    },
                    controller: drawTimeController,
                    onTap: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        drawTimeController.text = time.hour.toString().padLeft(2, '0') + ':' + time.minute.toString().padLeft(2, '0'); // Raw, but effective. Apparently there isn't a way to format TimeOfDay using only a string pattern
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.star),
                      labelText: 'Number of elements to be selected *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'The number of elements to be selected must be present';
                      }
                      int? parsedInt = int.tryParse(value);
                      if (parsedInt == null || parsedInt < 1 || parsedInt > raffleElements.length) {
                        return 'The number of elements to be selected must be an integer between 1 and the number of raffle elements';
                      }
                      return null;
                    },
                    controller: selectedElementsSizeController,
                    keyboardType: TextInputType.number,
                  )
                ],
              ),
            ),
          ),
          Divider(
            height: 32.0,
          ),
          Text('Raffle elements'),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: raffleElements.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(raffleElements[index]),
                    leading: Text((index + 1).toString() + '.'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => setState(() {
                        raffleElements.removeAt(index);
                      }),
                      tooltip: 'Remove element',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add an element',
        onPressed: () async {
          FocusScope.of(context).unfocus(); // On mobile it prevents showing the keyboard again focusing on the last selected field
          String? newElementName;
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Enter the new element name'),
                content: TextField(
                    controller: addRaffleElementController,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      addRaffleElementController.clear();
                    },
                    child: Text('Cancel')
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      newElementName = addRaffleElementController.text;
                      addRaffleElementController.clear();
                    },
                    child: Text('Add')
                  ),
                ],
              );
            },
          );
          if (newElementName != null && !raffleElements.contains(newElementName)) { // A set would be more efficient, but input order wouldn't be preserved
            setState(() {
              raffleElements = [...raffleElements, newElementName!];
            });
          }
        },
      ),
      bottomNavigationBar: ElevatedButton.icon(
        icon: Icon(Icons.save),
        label: Text('Create'),
        onPressed: () async {
          if (_formKey.currentState != null && _formKey.currentState!.validate()) {
            Draw formDraw = Draw(
              name: nameController.text,
              drawInstant: (drawDateController.text.isNotEmpty && drawTimeController.text.isNotEmpty) ? DateTime.parse(drawDateController.text + ' ' + drawTimeController.text) : null,
              selectedElementsSize: int.parse(selectedElementsSizeController.text),
              raffleElements: raffleElements,
            );
            try {
              Draw createdDraw = await api.createDraw(formDraw);
              Navigator.pushNamed(
                context,
                DrawPage.route.format([createdDraw.id]),
              );
            } on Exception {
              // TODO
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create draw')));
            }
          }
        },
      ),
    );
  }
}
