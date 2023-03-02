import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kanban_board/models/archived_task.dart';
import 'package:kanban_board/models/task.dart';
import 'package:kanban_board/utils/enums/columns.dart';

class FirestoreService {
  
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getArchivesSnapshot() =>
      _firestore
          .collection('archives')
          .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();

  Future<QuerySnapshot<Map<String, dynamic>>> getArchives() async =>
      await _firestore
          .collection('archives')
          .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .get();

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserDoc() async =>
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String id) async =>
      await _firestore.collection('users').doc(id).get();

  Future<QuerySnapshot<Map<String, dynamic>>> getGuestUsers() async =>
      await _firestore
          .collection('users')
          .where('isAnonymous', isEqualTo: true)
          .get();

  Future<QuerySnapshot<Map<String, dynamic>>> getAvailableUsers() async =>
      await _firestore.collection('users').get();

  Future<void> setUser(Map<String, dynamic> user) async => await _firestore
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set(user);

  Stream<QuerySnapshot<Map<String, dynamic>>> getTasks(Columns column) =>
      _firestore
          .collection('tasks')
          .where('column', isEqualTo: columnName(column))
          .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();

  Future<void> updateTask(String? docId, Columns column) async =>
      _firestore.collection('tasks').doc(docId).update({
        'column': columnName(column),
        if (column == Columns.done) 'completedOn': Timestamp.now()
      });

  Future<void> makeArchive(Task task) async {
    final docRef = await _firestore.collection('archives').add(ArchivedTask(
            completedOn: task.completedOn,
            createdOn: task.createdOn,
            timeTaken: task.timeTaken,
            title: task.title,
            notes: task.notes,
            users: task.users,
            createdBy: task.createdBy,
            archivedBy: FirebaseAuth.instance.currentUser!.uid)
        .toFirestore());
    if (docRef.id.isEmpty) {
      Fluttertoast.showToast(msg: 'Please try later.');
      return;
    }
    _firestore.collection('tasks').doc(task.id).delete();
  }
}
