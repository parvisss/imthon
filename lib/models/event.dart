import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String description;
  String date;
  String time;
  String title;
  String imageUrl;
  bool isActive;
  String location;
  String place;
  String id;
  int participents;
  String organizerId;
  Event({
    required this.id,
    required this.place,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.isActive,
    required this.description,
    required this.time,
    required this.title,
    required this.participents,
    required this.organizerId,
  });
  factory Event.fromQury(QueryDocumentSnapshot json) {
    return Event(
      id: json['id'],
      place: json['place'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      date: json['date'],
      time: json['time'],
      isActive: json['isActive'],
      description: json['description'],
      participents: json['participents'],
      organizerId: json['organizerId'],
    );
  }
}
