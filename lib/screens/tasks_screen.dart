import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/project_task_provider.dart';


// Tasks Screen
class TasksScreen extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(taskProvider.tasks[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => taskProvider.removeTask(index),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'New Task'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    taskProvider.addTask(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
