import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tadbiro/controllers/event_controller.dart';
import 'package:tadbiro/views/screens/add_new_event.dart';
import 'package:tadbiro/views/widgets/event_list_widget.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTabSelected(int index) {
    _pageController.jumpToPage(index);
    _onPageChanged(index);
  }

  // Define the content for each page
  Widget _getBodyContent(int index) {
    switch (index) {
      case 0:
        return EventListWidget(
          stream: EventController().getOrganizedEvents(),
        );
      case 1:
        return EventListWidget(
          stream: EventController().getFavoriteEvents(),
        );
      case 2:
        return EventListWidget(
          stream: EventController().getRegisteredEvents(),
        );
      case 3:
        return EventListWidget(
          stream: EventController().getevent(),
        );
      default:
        return Center(
          child: Text('Unknown Content',
              style: Theme.of(context).textTheme.titleLarge),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'.tr()),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return InkWell(
                  onTap: () {
                    if (index >= 0 && index < 4) {
                      // Ensure index is within range
                      _onTabSelected(index);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          index == 0
                              ? 'My Events'.tr()
                              : index == 1
                                  ? 'Favorites'.tr()
                                  : index == 2
                                      ? 'Registered'.tr()
                                      : 'Soon'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Gap(20)
                    ],
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: <Widget>[
                _getBodyContent(0),
                _getBodyContent(1),
                _getBodyContent(2),
                _getBodyContent(3),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const AddNewEvent(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
