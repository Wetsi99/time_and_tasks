import 'dart:convert';

class TimeEntry {
  final String project;
  final String task;
  final DateTime date;
  final int totalTime; // In Minuten
  final String notes;

  TimeEntry({
    required this.project,
    required this.task,
    required this.date,
    required this.totalTime,
    required this.notes,
  });

  // Umwandlung von TimeEntry zu Map (für LocalStorage)
  Map<String, dynamic> toMap() {
    return {
      'project': project,
      'task': task,
      'date': date.toIso8601String(), // Datum in ISO 8601 Format
      'totalTime': totalTime,
      'notes': notes,
    };
  }

  // Umwandlung von Map zu TimeEntry
  factory TimeEntry.fromMap(Map<String, dynamic> map) {
    return TimeEntry(
      project: map['project'],
      task: map['task'],
      date: DateTime.parse(map['date']),
      totalTime: map['totalTime'],
      notes: map['notes'],
    );
  }

  // Umwandlung von TimeEntry zu JSON
  String toJson() => json.encode(toMap());

  // Umwandlung von JSON zu TimeEntry
  factory TimeEntry.fromJson(String source) =>
      TimeEntry.fromMap(json.decode(source));
}
