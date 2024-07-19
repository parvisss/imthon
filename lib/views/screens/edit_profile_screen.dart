import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadbiro/controllers/user_controller.dart';
import 'package:tadbiro/views/widgets/photo_galary_camera.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.userData});
  // ignore: prefer_typing_uninitialized_variables
  final userData;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final secondNameController = TextEditingController();
  final nameController = TextEditingController();
  File? imageFile;

  // ignore: unused_field
  bool _isLoading = false;

  @override
  void initState() {
    nameController.text = widget.userData['name'];
    try {
      secondNameController.text = widget.userData['secondName'];
    } catch (e) {
      secondNameController.text = '';
    }

    super.initState();
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _uploadImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _uploadImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _uploadImage(ImageSource imageSource) async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(source: imageSource);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      _showImageDialog();
    }
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return PhotoGalaryCamera(imageFile: imageFile);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 140.h,
                      backgroundImage: widget.userData['imageUrl'] != null
                          ? NetworkImage(widget.userData['imageUrl'])
                          : const AssetImage('assets/images/avatar.jpg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 5,
                      child: IconButton(
                        onPressed: () {
                          _showPicker(context);
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Firstname",
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: secondNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Secondname",
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilledButton(
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });

          try {
            if (nameController.text.isNotEmpty &&
                secondNameController.text.isNotEmpty) {
              await UserController().editName(
                nameController.text,
                secondNameController.text,
                widget.userData['id'],
              );
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
          } catch (e) {
            // ignore: avoid_print
            print(e);
          } finally {
            setState(
              () {
                _isLoading = false;
              },
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 120.h, vertical: 15),
          child: const Text("Save"),
        ),
      ),
    );
  }
}
