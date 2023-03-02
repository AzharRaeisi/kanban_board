import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? name;
  String? email;
  String? photoUrl;
  bool? isAnonymous;

  User({this.id, this.name, this.email, this.photoUrl, this.isAnonymous});

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return User(
      id: snapshot.id,
      name: data?['name'],
      email: data?['email'],
      photoUrl: data?['photoUrl'],
      isAnonymous: data?['isAnonymous'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (photoUrl != null) "photoUrl": photoUrl,
      if (isAnonymous != null) "isAnonymous": isAnonymous,
    };
  }
}
