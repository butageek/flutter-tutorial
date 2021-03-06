import 'package:flutter/foundation.dart';
import 'package:journal_app/src/models/entry.dart';
import 'package:journal_app/src/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class EntryProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  DateTime _date;
  String _entry;
  String _entryId;
  var uuid = Uuid();

  // getters
  DateTime get date => _date;
  String get entry => _entry;
  Stream<List<Entry>> get entries => firestoreService.getEntries();

  // setters
  set changeDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  set changeEntry(String entry) {
    _entry = entry;
    notifyListeners();
  }

  // functions
  loadAll(Entry entry) {
    if (entry != null) {
      _date = DateTime.parse(entry.date);
      _entry = entry.entry;
      _entryId = entry.entryId;
    } else {
      _date = DateTime.now();
      _entry = null;
      _entryId = null;
    }
  }

  saveEntry() {
    if (_entryId == null) {
      // add
      var newEntry = Entry(
          date: _date.toIso8601String(), entry: _entry, entryId: uuid.v1());
      firestoreService.setEntry(newEntry);
    } else {
      // edit
      var updatedEntry = Entry(
          date: _date.toIso8601String(), entry: _entry, entryId: _entryId);
      firestoreService.setEntry(updatedEntry);
    }
  }

  removeEntry(String entryId) {
    firestoreService.removeEntry(entryId);
  }
}
