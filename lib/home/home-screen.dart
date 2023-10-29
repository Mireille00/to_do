import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/auth/login/login-screen.dart';
import 'package:to_do/settings/settings-tab.dart';
import 'package:to_do/task/task-list-tab.dart';

import '../providers/auth-provider.dart';
import '../providers/list-provider.dart';
import '../task/add-task-bottom-sheet.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ToDo List ${authProvider.currentUser!.name}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
              onPressed: () {
                listProvider.tasksList = [];
                authProvider.currentUser = null;
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_sharp),
              label: 'Task_list',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showaddTaskBottomSheet();
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: tabs[selectedIndex],
    );
  }

  List<Widget> tabs = [
    TaskListTab(),
    SettingsTab(),
  ];

  void showaddTaskBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => AddTaskBottomSheet());
  }
}
