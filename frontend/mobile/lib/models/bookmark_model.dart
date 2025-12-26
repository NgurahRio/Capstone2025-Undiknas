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

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id_bookmark: json['id_bookmark'],
      userId: User.fromJson(json['userId']),
      destinationId: json['destinationId'] != null
          ? Destination.fromJson(json['destinationId'])
          : null,
      eventId: json['eventId'] != null
          ? Event.fromJson(json['eventId'])
          : null,
    );
  }
}

bool isBookmarked({
  required int userId,
  Destination? destination,
  Event? event,
}) {
  assert(
    (destination != null && event == null) ||
    (destination == null && event != null),
  );

  return bookmarks.any((b) =>
      b.userId.id_user == userId &&
      (destination != null
          ? b.destinationId?.id_destination == destination.id_destination
          : b.eventId?.id_event == event!.id_event));
}


final List<Bookmark> bookmarks = [
  Bookmark(
    id_bookmark: 1,
    userId: users.firstWhere((u) => u.id_user == 3),
    destinationId: destinations.firstWhere((d) => d.id_destination == 1),
  ),
  Bookmark(
    id_bookmark: 2,
    userId: users.firstWhere((u) => u.id_user == 3),
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