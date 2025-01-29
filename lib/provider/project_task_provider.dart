import 'package:flutter/material.dart';


// Provider for managing projects and tasks
class ProjectTaskProvider with ChangeNotifier {
  final List<String> _projects = [];
  final List<String> _tasks = [];

  List<String> get projects => [..._projects];
  List<String> get tasks => [..._tasks];

  void addProject(String project) {
    _projects.add(project);
    notifyListeners();
  }

  void addTask(String task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeProject(int index) {
    _projects.removeAt(index);
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}