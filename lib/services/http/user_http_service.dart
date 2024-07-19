import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadbiro/services/auth/auth_service.dart';
import 'package:tadbiro/services/http/firebase_storage_service.dart';

class UserHttpService {
  final firestore = FirebaseFirestore.instance.collection("users");

  Future<void> addUser(
      String name, String password, String email, String userId) async {
    await firestore.doc(userId).set({
      "id": userId,
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
    });
  }

  Future<void> editUserName(
    String newName,
    String newSecondName,
    String userId,
  ) async {
    try {
      firestore
          .doc(userId)
          .update({'name': newName, 'secondName': newSecondName});
    } catch (e) {
      print(e);
    }
  }

  Future<void> organizeEvent(String eventId, Map<String, dynamic> data) async {
    String userId = await AuthService().getUserId();

    try {
      await firestore
          .doc(userId)
          .collection("organized")
          .doc(eventId)
          .set(data);
      print('Event organized successfully');
    } catch (e) {
      print('Error organizing event: $e');
    }
  }

  Future<void> favoriteEvents(
    String eventId,
    Map<String, dynamic> data,
  ) async {
    String userId = await AuthService().getUserId();

    try {
      DocumentReference eventDocRef =
          firestore.doc(userId).collection("favorites").doc(eventId);

      DocumentSnapshot eventDoc = await eventDocRef.get();

      if (eventDoc.exists) {
        await eventDocRef.delete();
        print('Event removed from favorites');
      } else {
        await eventDocRef.set(data);
        print('Event added to favorites');
      }
    } catch (e) {
      print('Error updating favorite events: $e');
    }
  }

  Future<void> registeredEvents(
      String eventId, Map<String, dynamic> data) async {
    String userId = await AuthService().getUserId();

    try {
      await firestore
          .doc(userId)
          .collection("registered")
          .doc(eventId)
          .set(data);
      print('Event organized successfully');
    } catch (e) {
      print('Error organizing event: $e');
    }
  }

  Future<bool> isEventFavorite(String eventId) async {
    String userId = await AuthService().getUserId();

    try {
      DocumentReference eventDocRef =
          firestore.doc(userId).collection("favorites").doc(eventId);

      DocumentSnapshot eventDoc = await eventDocRef.get();

      if (eventDoc.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(' $e');
      return false;
    }
  }

  Future<void> editPassword(String newPassword, String userId) async {
    await firestore.doc(userId).update({'password': newPassword});
  }

  Future<void> editPhoto(File file) async {
    String imageUrl = await FirebaseStorageService().uploadUserImage(file);
    String userId = await AuthService().getUserId();
    firestore.doc(userId).update({'imageUrl': imageUrl});
  }

  Future getOneUserInfo(String userId) async {
    return firestore.doc(userId).snapshots();
  }

  Stream<DocumentSnapshot> getUserData() async* {
    String userID = await AuthService().getUserId();
    yield* firestore.doc(userID).snapshots();
  }

  Future<void> deleteOrganizedEvent(String id) async {
    String userId = await AuthService().getUserId();
    try {
      await firestore.doc(userId).collection("organized").doc(id).delete();
      await firestore.doc(userId).collection("favorites").doc(id).delete();
      await firestore.doc(userId).collection("registered").doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editAcive(
    String id,
    Map<String, dynamic> data,
  ) async {
    String userId = await AuthService().getUserId();

    try {
      await firestore.doc(userId).collection('organized').doc(id).update(data);
      await firestore.doc(userId).collection('favorites').doc(id).update(data);
      await firestore.doc(userId).collection('registered').doc(id).update(data);
    } catch (e) {
      rethrow;
    }
  }
}
