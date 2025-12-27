import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/api.dart';
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
      userId: User.fromJson(json['user']),
      destinationId: json['destination'] != null
          ? Destination.fromJson(json['destination'])
          : null,
      eventId: json['event'] != null
          ? Event.fromJson(json['event'])
          : null,
    );
  }
}

Future<List<Bookmark>> getBookmarks() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  if (token == null) throw Exception('User belum login');

  final response = await http.get(
    Uri.parse('$baseUrl/user/favorite'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    final decoded = jsonDecode(response.body);
    throw Exception(decoded['error'] ?? 'Gagal mengambil bookmark');
  }

  final decoded = jsonDecode(response.body);
  final List list = decoded['favorites'] ?? [];
  return list.map((e) => Bookmark.fromJson(e)).toList();
}

Future<void> createBookmark({
  int? destinationId,
  int? eventId,
}) async {
  if ((destinationId == null && eventId == null) ||
      (destinationId != null && eventId != null)) {
    throw Exception('Pilih salah satu destination atau event');
  }

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  if (token == null) throw Exception('User belum login');

  final response = await http.post(
    Uri.parse('$baseUrl/user/favorite'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      if (destinationId != null) 'destinationId': destinationId,
      if (eventId != null) 'eventId': eventId,
    }),
  );

  if (response.statusCode != 201) {
    final decoded = jsonDecode(response.body);
    throw Exception(decoded['error'] ?? 'Gagal menambah bookmark');
  }
}

Future<void> deleteBookmark({
  required Bookmark item,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  if (token == null) throw Exception('User belum login');

  final isEvent = item.eventId != null;
  final targetId = isEvent
      ? item.eventId!.id_event
      : item.destinationId!.id_destination;
  final typeParam = isEvent ? 'event' : 'destination';

  final response = await http.delete(
    Uri.parse('$baseUrl/user/favorite/$targetId?type=$typeParam'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode != 200) {
    final decoded = jsonDecode(response.body);
    throw Exception(decoded['error'] ?? 'Gagal menghapus bookmark');
  }
}

Future<bool> isBookmarked({
  required int userId,
  Destination? destination,
  Event? event,
}) async {
  assert(
    (destination != null && event == null) ||
    (destination == null && event != null),
    'Either destination or event must be provided, not both',
  );

  final bookmarks = await getBookmarks();

  return bookmarks.any((b) =>
      b.userId.id_user == userId &&
      (destination != null
          ? b.destinationId?.id_destination == destination.id_destination
          : b.eventId?.id_event == event!.id_event));
}
