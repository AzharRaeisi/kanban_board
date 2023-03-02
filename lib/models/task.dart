import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String? title;
  String? notes;
  String? column;
  Timestamp? createdOn;
  Timestamp? completedOn;
  List<String>? users;
  String? createdBy;
  int? timeTaken;
  Timestamp? serverTimeStamp;
  bool isPaused;

  Task(
      {this.column,
      this.completedOn,
      this.createdOn,
      this.id,
      this.notes,
      this.timeTaken,
      this.title,
      this.users,
      this.createdBy,
      this.serverTimeStamp,
      this.isPaused = true});

  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Task(
      id: snapshot.id,
      title: data?['title'],
      notes: data?['notes'],
      completedOn: data?['completedOn'],
      createdOn: data?['createdOn'],
      timeTaken: data?['timeTaken'] ?? 0,
      column: data?['column'],
      createdBy: data?['createdBy'],
      users: data?['users'] is Iterable ? List.from(data?['users']) : null,
      serverTimeStamp: data?['serverTimeStamp'],
      isPaused: data?['isPaused'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (timeTaken != null) "timeTaken": timeTaken,
      if (completedOn != null) "completedOn": completedOn,
      if (createdOn != null) "createdOn": createdOn,
      if (title != null) "title": title,
      if (notes != null) "notes": notes,
      if (column != null) "column": column,
      if (users != null) "users": users,
      if (createdBy != null) "createdBy": createdBy,
      if (serverTimeStamp != null) "startedAt": serverTimeStamp,
      "isPaused": isPaused,
    };
  }
}
