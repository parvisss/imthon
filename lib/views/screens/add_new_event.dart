import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadbiro/controllers/event_controller.dart';
import 'package:tadbiro/views/screens/map_screen.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({super.key});

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  File? imageFile;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final locationController = TextEditingController();
  Placemark? placeName;
  List data = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final localizations = MaterialLocalizations.of(context);
        final formattedTimeOfDay = localizations.formatTimeOfDay(picked);
        timeController.text = formattedTimeOfDay;
      });
    }
  }

  void _publish() async {
    await EventController().addEvent(
      title: titleController.text,
      date: dateController.text,
      time: timeController.text,
      description: descriptionController.text,
      location: data[0].toString(),
      placeName: locationController.text,
      image: imageFile!,
    );
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Event"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Title",
                ),
              ),
              const Gap(20),
              TextField(
                controller: dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Date",
                  suffixIcon: Icon(Icons.calendar_month),
                ),
              ),
              const Gap(20),
              TextField(
                controller: timeController,
                readOnly: true,
                onTap: () => _selectTime(context),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                  hintText: "Time",
                ),
              ),
              const Gap(20),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Description",
                ),
              ),
              const Gap(20),
              TextField(
                onTap: () async {
                  data = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) =>
                          MapScreen(locationToGo: null, isAdding: true),
                    ),
                  );
                  placeName = data[1];
                  locationController.text =
                      "${placeName!.street},${placeName!.locality},${placeName!.country}";
                },
                controller: locationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Location",
                ),
              ),
              const Gap(20),
              InkWell(
                child: Container(
                  height: 270.h,
                  width: 290.w,
                  decoration: BoxDecoration(
                    image: imageFile != null
                        ? DecorationImage(
                            image: FileImage(imageFile!), fit: BoxFit.cover)
                        : null,
                    // color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 1,
                        color: Colors.black,
                      )
                    ],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                    ),
                  ),
                ),
                onTap: () {
                  _showPicker(context);
                },
              ),
              Gap(50),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilledButton(
        onPressed: () async {
          const Center(
            child: CircularProgressIndicator(),
          );
          const CircularProgressIndicator();
          _publish();
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 120.h, vertical: 15),
          child: const Text("Publish"),
        ),
      ),
    );
  }
}
