// lib/storage/time_entry_storage.dart
import 'package:localstorage/localstorage.dart';
import '../models/time_entry.dart'; // Achte darauf, den richtigen Pfad zu deiner TimeEntry-Klasse anzugeben

class TimeEntryStorage {
  final LocalStorage storage = LocalStorage('time_entries.json'); // Speichern in einer JSON-Datei

  // Speichern der TimeEntries
  Future<void> saveTimeEntries(List<TimeEntry> entries) async {
    // Umwandeln der TimeEntries in JSON
    List<String> entriesJson = entries.map((entry) => entry.toJson()).toList();

    // Speichern der JSON-Daten in LocalStorage
    await storage.setItem('entries', entriesJson);
  }

  // Laden der TimeEntries
  Future<List<TimeEntry>> loadTimeEntries() async {
    // Laden der JSON-Daten aus LocalStorage
    List<String>? entriesJson = storage.getItem('entries');

    if (entriesJson != null) {
      // Umwandeln der JSON-Daten in TimeEntry-Objekte
      return entriesJson.map((json) => TimeEntry.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
