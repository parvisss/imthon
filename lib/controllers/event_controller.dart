import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadbiro/services/http/events_http_service.dart';
import 'package:tadbiro/services/http/firebase_storage_service.dart';

class EventController {
  final _httpService = EventsHttpService();

  //? adding

  Future<void> addEvent({
    required String title,
    required String date,
    required String time,
    required String description,
    required String location,
    required String placeName,
    required File image,
  }) async {
    String imageUrl = await FirebaseStorageService().uploadFile(image);
    await _httpService.addEvent(
      {
        'isActive': true,
        'imageUrl': imageUrl,
        'title': title,
        'date': date,
        'time': time,
        'description': description,
        'location': location,
        'place': placeName,
        'participents': 0,
      },
    );
  }

  //? getting
  Stream<QuerySnapshot> getevent() async* {
    yield* _httpService.getEvents();
  }

  //?editing
  Future<void> editEvent(
    String id,
    String newTitle,
    String newDate,
    String newTime,
    String newDescription,
    String newLocation,
    String newPlaceName,
    File image,
  ) async {
    String imageUrl = await FirebaseStorageService().uploadFile(image);
    Map<String, dynamic> data = {
      "location": newLocation,
      "title": newTitle,
      "date": newDate,
      "time": newTime,
      "description": newDescription,
      'place': newPlaceName,
      'imageUrl': imageUrl,
    };
    await _httpService.editEvent(id, data);
  }

  Future<void> editAcivation(
    String id,
    String newTitle,
    String newDate,
    String newTime,
    String newDescription,
    String newLocation,
    String newPlaceName,
    String image,
  ) async {
    Map<String, dynamic> data = {
      "location": newLocation,
      "title": newTitle,
      "date": newDate,
      "time": newTime,
      "description": newDescription,
      'place': newPlaceName,
      'imageUrl': image,
      'isActive': false,
    };
    await _httpService.editAcive(id, data);
  }

  //?deleting

  Future<void> deleteEvent(String id) async {
    await _httpService.deleteEvent(id);
  }

  Stream<QuerySnapshot> getOrganizedEvents() async* {
    yield* _httpService.getOrganizedEvents();
  }

  Stream<QuerySnapshot> getFavoriteEvents() async* {
    yield* _httpService.getFavoriteEvents();
  }

  Stream<QuerySnapshot> getRegisteredEvents() async* {
    yield* _httpService.getRegisteredEvents();
  }

  Future<void> addParticipent(int number, String eventId) async {
    await _httpService.addParticipant(number, eventId);
  }
}
