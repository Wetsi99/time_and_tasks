import 'package:flutter/material.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => [..._entries];

  void addEntry(TimeEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void deleteEntry(int index) {
    _entries.removeAt(index);
    notifyListeners();
  }
}
