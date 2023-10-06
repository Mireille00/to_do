import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do/my-theme.dart';
import 'package:to_do/task/SaveTask.dart';

class TaskWidgetItem extends StatefulWidget {
  @override
  State<TaskWidgetItem> createState() => _TaskWidgetItemState();
}

class _TaskWidgetItemState extends State<TaskWidgetItem> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {},
            borderRadius: BorderRadius.circular(15),
            backgroundColor: MyTheme.redColor,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(7),
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: MyTheme.whiteColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.all(30),
              color: Theme.of(context).primaryColor,
              width: 4,
              height: 70,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Task Title',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: MyTheme.primaryLight,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('description'),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                SaveTask();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: MyTheme.primaryLight,
                ),
                child: Icon(
                  Icons.check,
                  size: 30,
                  color: MyTheme.whiteColor,
                ),
              ),
            ),
            // VerticalDivider(
            //   color: Theme.of(context).primaryColor,
            //   thickness: 5,
            //   indent: 200,
            //   endIndent: 200,
            // ),
          ],
        ),
      ),
    );
  }
}
