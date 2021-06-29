import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tidraw/api.dart';
import 'package:tidraw/model/draw.dart';

class CreateDrawPage extends StatefulWidget {
  static const route = '/create-draw';

  @override
  _CreateDrawPageState createState() => _CreateDrawPageState();
}

class _CreateDrawPageState extends State<CreateDrawPage> {
  final _formKey = GlobalKey<FormState>();

  List<String> raffleElements = [];

  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final selectedElementsSizeController = TextEditingController();
  final addRaffleElementController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    timeController.dispose();
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
                      labelText: "Name *",
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
                      labelText: "Draw date",
                    ),
                    validator: (value) {
                      // TODO
                      if (value == null || value.isEmpty) {
                        return null;
                      } else if (value.length != 10) {
                        return 'The date must be formatted like 2021-08-30';
                      }
                      return null;
                    },
                    controller: dateController,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100, 12, 31),
                      );
                      if (date != null) {
                        dateController.text = DateFormat('yyyy-MM-dd').format(date);
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.access_time),
                      labelText: "Draw time",
                    ),
                    validator: (value) {
                      // TODO
                      if (value == null || value.isEmpty) {
                        return null;
                      } else if (value.length != 5) {
                        return 'The time must be formatted like 02:46';
                      }
                      return null;
                    },
                    controller: timeController,
                    onTap: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        timeController.text = time.hour.toString().padLeft(2, '0') + ':' + time.minute.toString().padLeft(2, '0'); // Raw, but effective. Apparently there isn't a way to format TimeOfDay using only a pattern string
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.star),
                      labelText: "Number of elements to be selected *",
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
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Column(
                  children: raffleElements.map((element) => ListTile(
                    title: Text(element),
                    leading: Icon(Icons.circle),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add an element',
        onPressed: () async {
          String? newElementName;
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Enter the new element name"),
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
                      newElementName = addRaffleElementController.text;
                      Navigator.pop(context);
                      addRaffleElementController.clear();
                    },
                    child: Text('Ok')
                  ),
                ],
              );
            },
          );
          if (newElementName != null) {
            setState(() {
              raffleElements = [...raffleElements, newElementName!];
            });
          }
        },
      ),
      bottomNavigationBar: ElevatedButton.icon(
        icon: Icon(Icons.save),
        label: Text("Submit"),
        onPressed: () async {
          if (_formKey.currentState != null && _formKey.currentState!.validate()) {
            Draw formDraw = Draw(
              name: nameController.text,
              drawInstant: (dateController.text.isNotEmpty && timeController.text.isNotEmpty) ? DateTime.parse(dateController.text + 'T' + timeController.text + ':00Z') : null,
              selectedElementsSize: int.parse(selectedElementsSizeController.text),
              raffleElements: raffleElements.toList(),
            );
            try {
              Draw createdDraw = await putDraw(formDraw);
              Navigator.pushNamed(context, '/draw/' + createdDraw.id.toString());
            } on Exception catch(exc) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(exc.toString())));
            }
          }
        },
      ),
    );
  }
}
