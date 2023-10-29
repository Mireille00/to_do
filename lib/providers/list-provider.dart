import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do/firebase-utils.dart';
import 'package:to_do/model/task.dart';

class ListProvider extends ChangeNotifier {
  List<Task> tasksList = [];
  DateTime selectedDate = DateTime.now();

  void getAllTasksFromFireStore(String uId) async {
    QuerySnapshot<Task> querySnapshot =
        await FirebaseUtils.getTasksCollection(uId).get();
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    notifyListeners();

    tasksList = tasksList.where((task) {
      if (task.dateTime?.day == selectedDate.day &&
          task.dateTime?.month == selectedDate.month &&
          task.dateTime?.year == selectedDate.year) {
        return true;
      }
      return false;
    }).toList();

    tasksList.sort((Task task1, Task task2) {
      return task1.dateTime!.compareTo(task2.dateTime!);
    });
    notifyListeners();
  }

  void changeSelectDate(DateTime newDate, String uId) {
    selectedDate = newDate;
    getAllTasksFromFireStore(uId);
  }
}
