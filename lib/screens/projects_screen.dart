import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/project_task_provider.dart';


class ProjectsScreen extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectTaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Projects')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: projectProvider.projects.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(projectProvider.projects[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => projectProvider.removeProject(index),
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
                    decoration: InputDecoration(labelText: 'New Project'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    projectProvider.addProject(_controller.text);
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