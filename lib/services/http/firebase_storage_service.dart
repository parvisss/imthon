import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file) async {
    final imageReference =
        _storage.ref().child("Images").child("${DateTime.now()}.jpg");

    final uploadTask = imageReference.putFile(file);
    uploadTask.snapshotEvents.listen(
      (event) {
        print(event);
      },
    );
    String imageUrl = "";
    await uploadTask.whenComplete(
      () async {
        imageUrl = await imageReference.getDownloadURL();
      },
    );
    return imageUrl;
  }

  Future<String> uploadUserImage(File file) async {
    final imageReference =
        _storage.ref().child("user").child("${DateTime.now()}.jpg");

    final uploadTask = imageReference.putFile(file);
    uploadTask.snapshotEvents.listen(
      (event) {
        print(event);
      },
    );

    String imageUrl = '';
    await uploadTask.whenComplete(
      () async {
        imageUrl = await imageReference.getDownloadURL();
      },
    );
    return imageUrl;
  }
}
