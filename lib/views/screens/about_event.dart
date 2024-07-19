import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tadbiro/controllers/event_controller.dart';
import 'package:tadbiro/models/event.dart';
import 'package:tadbiro/services/http/user_http_service.dart';
import 'package:tadbiro/views/screens/map_screen.dart';

class AboutEvent extends StatefulWidget {
  const AboutEvent({super.key, required this.event});
  final Event event;

  @override
  State<AboutEvent> createState() => _AboutEventState();
}

class _AboutEventState extends State<AboutEvent> {
  int selectedPlaces = 1;

  void _showPaymentDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String selectedPaymentMethod = 'Paypal';

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: const Text('Paypal'),
                    leading: Radio<String>(
                      value: 'Paypal',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Google Pay'),
                    leading: Radio<String>(
                      value: 'Google Pay',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  const Gap(20),
                  const Text(
                    'Select Number of Places',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (selectedPlaces > 1) {
                            setState(() {
                              selectedPlaces--;
                            });
                          }
                        },
                      ),
                      Text(
                        '$selectedPlaces',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            selectedPlaces++;
                          });
                        },
                      ),
                    ],
                  ),
                  const Gap(20),
                  FilledButton(
                    onPressed: () async {
                      int allUsersWithMe =
                          widget.event.participents + selectedPlaces;
                      await EventController()
                          .addParticipent(allUsersWithMe, widget.event.id);
                      await UserHttpService().registeredEvents(
                        widget.event.id,
                        {
                          'date': widget.event.date,
                          'description': widget.event.description,
                          'id': widget.event.id,
                          'imageUrl': widget.event.imageUrl,
                          'location': widget.event.location,
                          'organizerId': widget.event.organizerId,
                          'place': widget.event.place,
                          'time': widget.event.time,
                          'title': widget.event.title,
                          'isActive': widget.event.isActive,
                          'participents': widget.event.participents,
                        },
                      );
                      Navigator.pop(context); // Close the payment dialog
                      _showCongratulationDialog(); // Show the congratulatory dialog
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 110.h, vertical: 15),
                      child: const Text("Confirm"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCongratulationDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('Your payment was successful.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Main Screen'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> place = widget.event.place.split(",");

    String cleanedString =
        widget.event.location.replaceAll('LatLng(', '').replaceAll(')', '');
    List locations = cleanedString.split(",");
    LatLng location = LatLng(
      double.parse(locations[0]),
      double.parse(
        locations[1],
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 245, 2, 2),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.event.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(
                    widget.event.title,
                    style: const TextStyle(fontSize: 25),
                  ),
                  const Gap(30),
                  ListTile(
                    leading: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.calendar_month),
                    ),
                    title: Text(widget.event.date),
                    subtitle: Text(widget.event.time),
                  ),
                  const Gap(30),
                  ListTile(
                    leading: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.location_on),
                    ),
                    title: Text(place[1]),
                    subtitle: Text(place[0]),
                  ),
                  const Gap(30),
                  ListTile(
                    leading: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.people),
                    ),
                    title: const Text("Participants"),
                    subtitle: Text(widget.event.participents.toString()),
                  ),
                  const Gap(30),
                  ListTile(
                    leading: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.people),
                    ),
                    title: const Text("Get direction"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                              locationToGo: location, isAdding: false),
                        ),
                      );
                    },
                  ),
                  const Gap(30),
                  Text(
                    widget.event.description,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Gap(30),
                  FilledButton(
                    onPressed: widget.event.isActive
                        ? () {
                            _showPaymentDialog();
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          return widget.event.isActive
                              ? Colors.blue
                              : Colors.grey;
                        },
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 110.h, vertical: 15),
                      child: widget.event.isActive
                          ? const Text("Participate")
                          : const Text("Event closed"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
