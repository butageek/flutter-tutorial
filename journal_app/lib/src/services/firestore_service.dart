import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/src/models/entry.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // get entries
  Stream<List<Entry>> getEntries() {
    return _db.collection('entries').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Entry.fromJson(doc.data())).toList());
  }

  // Upsert
  Future<void> setEntry(Entry entry) {
    var options = SetOptions(merge: true);

    return _db
        .collection('entries')
        .doc(entry.entryId)
        .set(entry.toMap(), options);
  }

  // delete
  Future<void> removeEntry(String entryId) {
    return _db.collection('entries').doc(entryId).delete();
  }
}
