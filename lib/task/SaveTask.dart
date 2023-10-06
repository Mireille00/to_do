import 'package:flutter/material.dart';

class SaveTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Edit Task'),
          TextField(
            decoration: InputDecoration(hintText: "this is title"),
          ),
          TextField(
            decoration: InputDecoration(hintText: "task details"),
          ),
        ],
      ),
    );
  }
}
