import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/dialog-utils.dart';
import 'package:to_do/firebase-utils.dart';
import 'package:to_do/model/task.dart';
import 'package:to_do/providers/auth-provider.dart';
import 'package:to_do/providers/list-provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  DateTime selectedDate = DateTime.now();
  var formkey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'Add New Task',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 20,
          ),
          Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (task) {
                        title = task;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'please enter task title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Your Task',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (task) {
                        description = task;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'please enter description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Description',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Select date',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showCalender();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text('Add'),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  void showCalender() async {
    var chosendate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (chosendate != null) {
      selectedDate = chosendate;
      setState(() {});
    }
  }

  void addTask() {
    if (formkey.currentState?.validate() == true) {
      Task task =
          Task(title: title, description: description, dateTime: selectedDate);
      DialogUtils.showLoading(context, 'loding...');
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      FirebaseUtils.addTaskToFireStore(task, authProvider.currentUser!.id!)
          .then((value) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'Task added successfully',
            posActionName: 'OK', posAction: () {
          Navigator.pop(context);
        });
      }).timeout(Duration(milliseconds: 500), onTimeout: () {
        print('todo added successfully');
        listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
        Navigator.pop(context);
      });
    }
  }
}
