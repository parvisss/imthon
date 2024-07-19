import 'package:firebase_auth/firebase_auth.dart';
import 'package:tadbiro/controllers/user_controller.dart';
import 'package:tadbiro/services/http/user_http_service.dart';

class AuthService {
  final authService = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    try {
      await authService.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  //?registrasiya qiladi hamda registrasiyada surlagan malumotlarni qaytaradi ni qaytaradi ajratib user ga qushish uchun
  Future<void> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      await authService.createUserWithEmailAndPassword(
          email: email, password: password);
      await UserHttpService()
          .addUser(name, password, email, authService.currentUser!.uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    await authService.signOut();
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    User? user = authService.currentUser;
    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        await user.reload();
        user = authService.currentUser;
        print("Password updated successfully");
        await UserController().editPassword(newPassword, user!.uid);
      } catch (e) {
        print("Failed to update password: $e");
        rethrow;
      }
    } else {
      print("No user is signed in");
    }
  }

  Future<String> getUserId() async {
    return authService.currentUser!.uid.toString();
  }
}
