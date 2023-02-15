import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';

class CarBody extends StatelessWidget {
  var item;

  final Function handleDeleteTask;

  var index;

  CarBody(
      {Key? key,
      required this.item,
      required this.index,
      required this.handleDeleteTask})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 74,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: (index % 2 == 0)
              ? const Color.fromARGB(255, 212, 168, 33)
              : Color.fromARGB(255, 17, 146, 114),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            item.name,
            style: TextStyle(
                fontSize: 20,
                color: Color(0xff4B4B4B),
                fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () async {
              if (await confirm(context)) {
                //nếu ok
                handleDeleteTask(item.id);
              }
              return;
            },
            child: Icon(
              Icons.delete_outline,
              color: Color(0xff4B4B4B),
              size: 20,
            ),
          )
        ]),
      ),
    );
  }
}
