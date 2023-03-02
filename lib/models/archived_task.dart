import 'package:cloud_firestore/cloud_firestore.dart';

class ArchivedTask {
  String? id;
  String? title;
  String? notes;
  Timestamp? createdOn;
  Timestamp? completedOn;
  List<String>? users;
  int? timeTaken;
  String? createdBy;
  String? archivedBy;

  ArchivedTask(
      {this.completedOn,
      this.createdOn,
      this.id,
      this.notes,
      this.timeTaken,
      this.title,
      this.users,
      this.createdBy,
      this.archivedBy});

  factory ArchivedTask.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return ArchivedTask(
      id: snapshot.id,
      title: data?['title'],
      notes: data?['notes'],
      completedOn: data?['completedOn'],
      createdOn: data?['createdOn'],
      timeTaken: data?['timeTaken'],
      users: data?['users'] is Iterable ? List.from(data?['users']) : null,
      archivedBy: data?['archivedBy'],
      createdBy: data?['createdBy'],
    );
  }

  factory ArchivedTask.fromJson(
     Map<String, dynamic> data) {
    return ArchivedTask(
      id: data['id'],
      title: data['title'],
      notes: data['notes'],
      completedOn: data['completedOn'],
      createdOn: data['createdOn'],
      timeTaken: data['timeTaken'],
      users: data['users'] is Iterable ? List.from(data['users']) : null,
      archivedBy: data['archivedBy'],
      createdBy: data['createdBy'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (timeTaken != null) "timeTaken": timeTaken,
      if (completedOn != null) "completedOn": completedOn,
      if (createdOn != null) "createdOn": createdOn,
      if (title != null) "title": title,
      if (notes != null) "notes": notes,
      if (users != null) "users": users,
      if (archivedBy != null) "archivedBy": archivedBy,
      if (createdBy != null) "createdBy": createdBy,
    };
  }
}
