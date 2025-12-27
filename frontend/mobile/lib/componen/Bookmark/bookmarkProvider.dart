import 'package:flutter/material.dart';
import 'package:mobile/models/bookmark_model.dart';
import 'package:mobile/models/destination_model.dart';
import 'package:mobile/models/event_model.dart';
import 'package:mobile/models/user_model.dart';

class BookmarkProvider extends ChangeNotifier {
  List<Bookmark> _bookmarks = [];
  bool _loading = false;

  List<Bookmark> get bookmarks => _bookmarks;
  bool get isLoading => _loading;

  Future<void> fetchBookmarks() async {
    _loading = true;
    notifyListeners();

    try {
      _bookmarks = await getBookmarks();
    } catch (e) {
      debugPrint('Fetch bookmark error: $e');
    }

    _loading = false;
    notifyListeners();
  }

  bool isBookmarked({
    required User user,
    Destination? destination,
    Event? event,
  }) {
    return _bookmarks.any((b) =>
        b.userId.id_user == user.id_user &&
        (destination != null
            ? b.destinationId?.id_destination ==
                destination.id_destination
            : b.eventId?.id_event == event?.id_event));
  }

  Future<void> toggle({
    required User user,
    Destination? destination,
    Event? event,
  }) async {
    final existing = _bookmarks.where((b) =>
        b.userId.id_user == user.id_user &&
        (destination != null
            ? b.destinationId?.id_destination ==
                destination.id_destination
            : b.eventId?.id_event == event?.id_event)).toList();

    try {
      if (existing.isNotEmpty) {
        await deleteBookmark(item: existing.first);
        _bookmarks.remove(existing.first);
      } else {
        await createBookmark(
          destinationId: destination?.id_destination,
          eventId: event?.id_event,
        );
        await fetchBookmarks();
      }
    } catch (e) {
      throw Exception('Toggle bookmark failed');
    }

    notifyListeners();
  }
}
