// event_list_widget.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure you have this import for QuerySnapshot
import 'package:gap/gap.dart';
import 'package:tadbiro/controllers/event_controller.dart';
import 'package:tadbiro/models/event.dart';
import 'package:tadbiro/services/http/user_http_service.dart';
import 'package:tadbiro/views/screens/about_event.dart';
import 'package:tadbiro/views/screens/editEvent.dart';

class EventListWidget extends StatelessWidget {
  final Stream<QuerySnapshot> stream;

  const EventListWidget({super.key, required this.stream});
  void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        final events = snapshot.data!.docs;
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (ctx, index) {
            final event = events[index];
            return Column(
              children: [
                InkWell(
                  child: Stack(
                    children: [
                      Card(
                        elevation: 4, // Optional: Adds shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Card(
                                  clipBehavior: Clip.hardEdge,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SizedBox(
                                    height: 130,
                                    width: 130,
                                    child: Image.network(
                                      event['imageUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        event["title"],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                      Text(
                                        "${event['time']} , ${event["date"]}",
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.location_on),
                                          Expanded(
                                            child: Text(
                                              event["place"],
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () async {
                            await UserHttpService().favoriteEvents(
                              event['id'],
                              {
                                'date': event['date'],
                                'description': event['description'],
                                'id': event['id'],
                                'imageUrl': event['imageUrl'],
                                'isActive': false,
                                'location': event['location'],
                                'organizerId': event['organizerId'],
                                'place': event['place'],
                                'time': event['time'],
                                'title': event['title'],
                                'participents': event['participents']
                              },
                            );
                            showCustomSnackBar(
                                // ignore: use_build_context_synchronously
                                context,
                                await UserHttpService()
                                        .isEventFavorite(event['id'])
                                    ? "added to favorite list"
                                    : "Deleted from favorite list");
                          },
                          icon: const Icon(Icons.favorite),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => AboutEvent(
                          event: Event.fromQury(event),
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Choose an option"),
                                content: const Text(
                                    "Do you want to delete or edit this event?"),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      await EventController()
                                          .deleteEvent(event['id']);
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                      // Implement delete functionality here
                                    },
                                    child: const Text("Delete"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => EditEvent(
                                            event: Event.fromQury(event),
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text("Edit"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                ),
                const Gap(20),
              ],
            );
          },
        );
      },
    );
  }
}
