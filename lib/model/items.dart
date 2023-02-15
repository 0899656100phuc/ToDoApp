import 'package:flutter/material.dart';

class DataItems {
  String? id;
  String? name;
  bool? completed;
  String? dateCreated;

  DataItems(
      {@required this.id,
      @required this.name,
      this.completed = false,
      @required this.dateCreated});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'complated': completed,
      'dateCreated': dateCreated,
    };
    return map;
  }

  DataItems.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    name = map['name'];
    completed = map['complated'];
    dateCreated = map['dateCreated'];
  }

  @override
  String toString() {
    return 'DataItems(id: $id, name: $name, completed: $completed , dateCreated: $dateCreated)';
  }
}
