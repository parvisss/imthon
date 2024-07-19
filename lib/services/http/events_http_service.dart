import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadbiro/controllers/user_controller.dart';
import 'package:tadbiro/services/auth/auth_service.dart';
import 'package:tadbiro/services/http/user_http_service.dart';
// import 'package:tadbiro/services/http/user_http_service.dart';

class EventsHttpService {
  final _firestore = FirebaseFirestore.instance.collection("events");

  Future addEvent(Map<String, dynamic> data) async {
    try {
      DocumentReference docRef = await _firestore.add(data);
      Map<String, dynamic> newData = {
        "id": docRef.id,
        "organizerId": await AuthService().getUserId(),
        ...data
      };

      _firestore.doc(docRef.id).update(newData);
      UserController().organizeEvent(docRef.id, newData);

      return newData;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getEvents() async* {
    yield* _firestore.snapshots();
  }

  Future<void> editEvent(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.doc(id).update(data);
    } catch (e) {
      print("error on editing");
    }
  }

  Future<void> editAcive(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.doc(id).update(data);
      await UserHttpService().editAcive(id, data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _firestore.doc(id).delete();
      await UserHttpService().deleteOrganizedEvent(id);
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getOrganizedEvents() async* {
    String userId = await AuthService().getUserId();
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("organized")
        .snapshots();
  }

  Stream<QuerySnapshot> getFavoriteEvents() async* {
    String userId = await AuthService().getUserId();
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("favorites")
        .snapshots();
  }

  Stream<QuerySnapshot> getRegisteredEvents() async* {
    String userId = await AuthService().getUserId();
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("registered")
        .snapshots();
  }

  Future<void> addParticipant(int number, String eventId) async {
    await _firestore.doc(eventId).update({'participents': number});
  }
}
