import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:todolist/main.dart';

import '../model/items.dart';

class addItem extends StatefulWidget {
  var addTask;
  addItem({super.key, this.addTask});

  @override
  State<addItem> createState() => _addItemState();
}

class _addItemState extends State<addItem> {
  DateTime _dateTime = DateTime.now();
  final formatter = new DateFormat('yyyy-MM-dd');
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDate = TextEditingController();

  List<DataItems> items = [];
  _showDateTime() async {
    final DateTime? newDate = await showDatePicker(
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        context: context);
    if (newDate == null) {
      return;
    }
    setState(() {
      _dateTime = newDate;
      controllerDate.value = TextEditingValue(text: formatter.format(newDate));
    });
  }

  void _handleaddTask(String name, date) {
    final name = controllerName.text;
    final date = controllerDate.text;
    if (name.isEmpty || date.isEmpty) {
      return;
    }
    // id : lấy giờ hiện tại
    final newItems =
        DataItems(id: DateTime.now().toString(), name: name, dateCreated: date);
    setState(() {
      items.add(newItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            TextField(
              controller: controllerName,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Your task'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              onTap: () {
                _showDateTime();
              },
              controller: controllerDate,
              decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                  labelText: 'Your task'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                _handleaddTask(controllerName.text, controllerDate.text);
                Navigator.pop(context, items);
              },
              child: Text('submit'),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
