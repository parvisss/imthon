import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadbiro/services/auth/auth_service.dart';
import 'package:tadbiro/services/http/user_http_service.dart';

class UserController {
  final httpService = UserHttpService();

  Future<void> register(String name, String password, String email) async {
    await AuthService().register(email, password, name);
  }

  Future organizeEvent(String eventsId, Map<String, dynamic> data) async {
    await httpService.organizeEvent(eventsId, data);
  }

  getUserId() {
    return AuthService().getUserId();
  }

  Stream<DocumentSnapshot> getUserData() async* {
    yield* httpService.getUserData();
  }

  Future<void> editName(
      String newName, String newSecondName, String userId) async {
    await httpService.editUserName(newName, newSecondName, userId);
  }

  Future<void> editPassword(String newPassword, String userId) async {
    await httpService.editPassword(newPassword, userId);
  }

  Future<void> editPhoto(File file) async {
    await httpService.editPhoto(file);
  }

  

  Future getOneuserInfo(String userId) async {
    return httpService.getOneUserInfo(userId);
  }
}
