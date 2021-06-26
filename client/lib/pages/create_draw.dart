import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateDrawPage extends StatefulWidget {
  static const route = '/create-draw';

  @override
  _CreateDrawPageState createState() => _CreateDrawPageState();
}

class _CreateDrawPageState extends State<CreateDrawPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

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
      body: Center(
        child: Form(
          key: _formKey,
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton.icon(
        icon: Icon(Icons.save),
        label: Text("Submit"),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            String name = nameController.text;
            String? drawInstant;
            if (dateController.text.isNotEmpty && timeController.text.isNotEmpty) {
              drawInstant = dateController.text + 'T' + timeController.text + ':00Z';
            }
            // TODO
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Draw submitted correctly')));
          }
        },
      ),
    );
  }
}
