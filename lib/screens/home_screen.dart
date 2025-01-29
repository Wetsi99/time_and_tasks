import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Importiere intl für die Datumformatierung
import '../provider/time_entry_provider.dart';
import '../models/time_entry.dart';

// Home Screen with Menu and Filter Buttons
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showGroupedByProject = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final entries = Provider.of<TimeEntryProvider>(context).entries;
    final groupedEntries = _groupEntriesByProject(entries);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Time Tracker'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: const Color.fromARGB(255, 172, 106, 243)),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Projects'),
              onTap: () => Navigator.pushNamed(context, '/projects'),
            ),
            ListTile(
              title: Text('Tasks'),
              onTap: () => Navigator.pushNamed(context, '/tasks'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => setState(() => showGroupedByProject = false),
                child: Text('All Entries', style: TextStyle(fontWeight: !showGroupedByProject ? FontWeight.bold : FontWeight.normal)),
              ),
              TextButton(
                onPressed: () => setState(() => showGroupedByProject = true),
                child: Text('Grouped by Project', style: TextStyle(fontWeight: showGroupedByProject ? FontWeight.bold : FontWeight.normal)),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: showGroupedByProject ? groupedEntries.length : entries.length,
              itemBuilder: (context, index) {
                if (showGroupedByProject) {
                  final project = groupedEntries.keys.elementAt(index);
                  final projectEntries = groupedEntries[project]!;
                  return ExpansionTile(
                    title: Text(project),
                    children: projectEntries.map((entry) => _buildEntryTile(entry, context, entries)).toList(),
                  );
                } else {
                  return _buildEntryTile(entries[index], context, entries);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/add-time-entry'),
      ),
    );
  }

  Widget _buildEntryTile(TimeEntry entry, BuildContext context, List<TimeEntry> entries) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(entry.date); // Datum formatieren

    return ListTile(
      title: Text('${entry.project} - ${entry.task}'),
      subtitle: Text('$formattedDate | ${entry.totalTime} Minuten'), // Zeige das formatierte Datum
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => Provider.of<TimeEntryProvider>(context, listen: false).deleteEntry(entries.indexOf(entry)),
      ),
    );
  }

  Map<String, List<TimeEntry>> _groupEntriesByProject(List<TimeEntry> entries) {
    final Map<String, List<TimeEntry>> grouped = {};
    for (var entry in entries) {
      if (!grouped.containsKey(entry.project)) {
        grouped[entry.project] = [];
      }
      grouped[entry.project]!.add(entry);
    }
    return grouped;
  }
}
