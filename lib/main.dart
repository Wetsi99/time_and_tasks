import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/time_entry_provider.dart';
import './provider/project_task_provider.dart';
import './screens/home_screen.dart';
import './screens/add_time_entry_screen.dart';
import './screens/projects_screen.dart';
import './screens/tasks_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimeEntryProvider()),
        ChangeNotifierProvider(create: (context) => ProjectTaskProvider()),
      ],
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/add-time-entry': (context) => AddTimeEntryScreen(),
          '/projects': (context) => ProjectsScreen(),
          '/tasks': (context) => TasksScreen(),
        },
      ),
    );
  }
}