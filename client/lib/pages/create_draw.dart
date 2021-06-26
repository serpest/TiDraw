import 'package:flutter/material.dart';

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
                    return 'The draw\'s name length must be between 1 and 280 characters';
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
                controller: dateController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.access_time),
                  labelText: "Draw time",
                ),
                controller: timeController,
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
            var name = nameController.text;
            var drawInstant = null;
            if (dateController.text.isNotEmpty && timeController.text.isNotEmpty) {
              drawInstant = dateController.text + 'T' + timeController.text;
            }
            // TODO
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Draw submitted correctly')));
          }
        },
      ),
    );
  }
}
