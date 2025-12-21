import 'package:intl/intl.dart';

String formatEventDate(String startDate, String? endDate) {
  DateTime parseDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (_) {
      throw FormatException("Invalid date format", date);
    }
  }

  final start = parseDate(startDate);

  if (endDate == null || endDate.isEmpty) {
    return DateFormat("dd MMM yyyy").format(start);
  }

  final end = parseDate(endDate);

  if (start.year == end.year &&
      start.month == end.month &&
      start.day == end.day) {
    return DateFormat("dd MMM yyyy").format(start);
  }

  return "${DateFormat("dd MMM").format(start)} - ${DateFormat("dd MMM yyyy").format(end)}";
}

