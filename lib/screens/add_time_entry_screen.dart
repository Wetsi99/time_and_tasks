import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/provider/project_task_provider.dart';
import 'package:time_tracker/provider/time_entry_provider.dart'; // Importiere den TimeEntryProvider
import 'package:time_tracker/storage/time_entry_storage.dart'; // Importiere den TimeEntryStorage
import '../models/time_entry.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProject;
  String? _selectedTask;
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateController = TextEditingController();
  final TimeEntryStorage _storage = TimeEntryStorage(); // Erstelle ein TimeEntryStorage-Objekt

  // Methode, um den Kalender zu öffnen
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        // Formatieren des Datums und Einfügen in das Textfeld
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectTaskProvider = Provider.of<ProjectTaskProvider>(context);
    final projects = projectTaskProvider.projects;
    final tasks = projectTaskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedProject,
                hint: Text('Select Project'),
                items: projects.map((project) {
                  return DropdownMenuItem(
                    value: project,
                    child: Text(project),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedProject = value),
                validator: (value) => value == null ? 'Please select a project' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedTask,
                hint: Text('Select Task'),
                items: tasks.map((task) {
                  return DropdownMenuItem(
                    value: task,
                    child: Text(task),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedTask = value),
                validator: (value) => value == null ? 'Please select a task' : null,
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Total Time (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter time' : null,
              ),
              GestureDetector(
                onTap: () => _selectDate(context), // Kalender öffnen bei Klick
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Date'),
                  ),
                ),
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notes'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Stelle sicher, dass das Datum als DateTime gespeichert wird
                    final selectedDate = DateTime.parse(_dateController.text);

                    final newEntry = TimeEntry(
                      project: _selectedProject!,
                      task: _selectedTask!,
                      date: selectedDate,  // Speichere das Datum als DateTime
                      totalTime: int.parse(_timeController.text),
                      notes: _notesController.text,
                    );

                    // Speichern der TimeEntry im Provider und im LocalStorage
                    Provider.of<TimeEntryProvider>(context, listen: false).addEntry(newEntry);
                    await _storage.saveTimeEntries(
                        Provider.of<TimeEntryProvider>(context, listen: false).entries); // Speichern im LocalStorage

                    Navigator.pop(context);
                  }
                },
                child: Text('Add Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
