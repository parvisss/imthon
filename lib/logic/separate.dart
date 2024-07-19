import 'package:tadbiro/controllers/event_controller.dart';
import 'package:tadbiro/models/event.dart';

class Separate {
  Future<bool> isActive(Event event) async {
    try {

      DateTime eventDate = DateTime.parse(event.date);

      DateTime now = DateTime.now();

      if (eventDate.isBefore(now)) {
        await EventController().editAcivation(
            event.id,
            event.title,
            event.date,
            event.time,
            event.description,
            event.location,
            event.place,
            event.imageUrl);
        return true;
      }
    } catch (e) {
      print('Error checking if event is active: $e');
    }
    print("object");
    print("object");
    print("object");
    print("object");
    print("object");
    print("object");
    print("object");
    return false;
  }
}
