import 'package:mobile/models/destination_model.dart';
import 'package:mobile/models/event_model.dart';
import 'package:mobile/models/user_model.dart';

class Bookmark {
  final int id_bookmark;
  final User userId;
  final Event? eventId;
  final Destination? destinationId;

  Bookmark({
    required this.id_bookmark,
    required this.userId,
    this.eventId,
    this.destinationId,
  });
}

final List<Bookmark> bookmarks = [
  Bookmark(
    id_bookmark: 1,
    userId: users.firstWhere((u) => u.id_user == 1),
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
  ),
  Bookmark(
    id_bookmark: 2,
    userId: users.firstWhere((u) => u.id_user == 1),
    eventId: events.firstWhere((e) => e.id_event == 2),
  ),
  Bookmark(
    id_bookmark: 3,
    userId: users.firstWhere((u) => u.id_user == 2),
    destinationId: destinations.firstWhere((d) => d.id_destination == 3),
  ),
  Bookmark(
    id_bookmark: 4,
    userId: users.firstWhere((u) => u.id_user == 2),
    eventId: events.firstWhere((e) => e.id_event == 1),
  ),
];