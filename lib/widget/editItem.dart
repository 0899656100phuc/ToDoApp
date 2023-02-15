import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:todolist/model/items.dart';

class EditItem extends StatefulWidget {
  DataItems items;
  EditItem(this.items, {super.key});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  DateTime _dateTime = DateTime.now();
  final formatter = new DateFormat('yyyy-MM-dd');
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDate = TextEditingController();

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

  _handleaddTask(DataItems dataItems, String name, date) {
    final name = controllerName.text;
    final date = controllerDate.text;
    if (name.isEmpty || date.isEmpty) {
      return;
    }
    dataItems.name = name;
    dataItems.dateCreated = date;
    return dataItems;
    // id : lấy giờ hiện tại
    // final newItems =
    //     DataItems( id: DateTime.now().toString(), name: name, dateCreated: date);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerName.text = widget.items.name!;
    controllerDate.text = widget.items.dateCreated!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
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
                _handleaddTask(
                    widget.items, controllerName.text, controllerDate.text);
                setState(() {});
                Navigator.pop(context, widget.items);
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
