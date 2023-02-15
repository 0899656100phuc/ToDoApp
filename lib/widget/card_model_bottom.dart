import 'dart:js';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModelBottom extends StatefulWidget {
  var addTask;

  ModelBottom({Key? key, required this.addTask // chuyền tham số addTask từ main
      })
      : super(key: key);

  @override
  State<ModelBottom> createState() => _ModelBottomState();
}

class _ModelBottomState extends State<ModelBottom> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDate = TextEditingController();
  DateTime _dateTime = DateTime.now();
  final formatter = new DateFormat('yyyy-MM-dd hh:mm');

  void _handleOnclick(BuildContext context) {
    // lấy info từ input(TextField)
    final name = controllerName.text;
    final date = controllerDate.text;
    if (name.isEmpty || date.isEmpty) {
      return;
    }
    widget.addTask(name, date);
    // trả về màn hình trước đó
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
        controllerDate.value =
            TextEditingValue(text: formatter.format(newDate));
      });
    }

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(children: [
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
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
                suffixIcon: const Icon(Icons.date_range),
                border: const OutlineInputBorder(),
                labelText: 'Date task'),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    _handleOnclick(context);
                  },
                  child: const Text('Add Task')))
        ]),
      ),
    );
  }
}
