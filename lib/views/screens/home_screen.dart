import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tadbiro/controllers/event_controller.dart';
import 'package:tadbiro/logic/separate.dart';
import 'package:tadbiro/models/event.dart';
import 'package:tadbiro/services/auth/auth_service.dart';
import 'package:tadbiro/services/http/user_http_service.dart';
import 'package:tadbiro/views/screens/about_event.dart';
import 'package:tadbiro/views/widgets/cards_to_slide.dart';
import 'package:tadbiro/views/widgets/draver_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      drawer: const DraverWidget(),
      body: StreamBuilder(
        stream: EventController().getevent(),
        builder: (ctx, snapshot) {
          AuthService().getUserId();
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final events = snapshot.data!.docs;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.search),
                      hintText: 'Search'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              CardsToSlide(
                events: events,
              ),
              const SliverToBoxAdapter(
                child: Gap(40),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  leading: Text(
                    events.length == 1
                        ? "${events.length} Event "
                        : "${events.length} Events",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SliverToBoxAdapter(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                sliver: SliverList.builder(
                  itemCount: events.length,
                  itemBuilder: (ctx, index) {
                    Separate().isActive(Event.fromQury(events[index]));
                    final event = events[index];
                    return Column(
                      children: [
                        InkWell(
                          child: Stack(
                            children: [
                              Card(
                                elevation: 4,
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                  "${event['time']} , ${event["date"]}"),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(Icons.location_on),
                                                  Expanded(
                                                    child: Text(
                                                      event["place"],
                                                      style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                        'participents': event['participents'],
                                      },
                                    );
                                    showCustomSnackBar(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        await UserHttpService()
                                                .isEventFavorite(event['id'])
                                            ? "Added to favorite list"
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
                        ),
                        const Gap(20),
                      ],
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
