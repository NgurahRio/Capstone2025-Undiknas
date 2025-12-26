import 'package:mobile/models/destination_model.dart';
import 'package:mobile/models/event_model.dart';
import 'package:mobile/models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/api.dart';

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

Future<List<Bookmark>> getBookmarks() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception('User belum login');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/user/favorite'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
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
  required int destinationId,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception('User belum login');
  }

  final response = await http.delete(
    Uri.parse('$baseUrl/user/favorite/$destinationId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    bookmarks.removeWhere(
      (b) =>
          b.userId.id_user == User.currentUser!.id_user &&
          b.destinationId?.id_destination == destinationId,
    );
    return;
  }

  final decoded = jsonDecode(response.body);
  throw Exception(decoded['error'] ?? 'Gagal menghapus bookmark');
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