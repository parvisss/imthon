import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tadbiro/controllers/user_controller.dart';

// ignore: must_be_immutable
class PhotoGalaryCamera extends StatefulWidget {
  PhotoGalaryCamera({super.key, required this.imageFile});
  File? imageFile;

  @override
  State<PhotoGalaryCamera> createState() => _PhotoGalaryCameraState();
}

class _PhotoGalaryCameraState extends State<PhotoGalaryCamera> {
  late final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Gap(30),
        widget.imageFile != null
            ? CircleAvatar(
                radius: 140,
                backgroundImage: FileImage(
                  widget.imageFile!,
                ),
              )
            : const Text("Please choose a photo"),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () async {
                await UserController().editPhoto(widget.imageFile!);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ],
    );
  }
}
