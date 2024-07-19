import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String password;

  // List<Event> organizedEvents;
  // List<Event> participatingEvents;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    // required this.organizedEvents,
    // required this.participatingEvents,
  });
  factory UserModel.fromQury(QueryDocumentSnapshot json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['json'],
      // organizedEvents: json['organizedEvents'],
      // participatingEvents: json['participatingEvents'],
    );
  }
}
