import 'package:intl/intl.dart';

String formatEventDate(String startDate, String? endDate) {
  bool isInvalidDate(String? date) {
    return date == null ||
        date.isEmpty ||
        date == "0000-00-00T00:00:00+08:00" ||
        date == "0001-01-01T00:00:00+08:00" ||
        date == "0001-01-01T00:00:00Z";
  }

  DateTime parseDate(String date) {
    return DateTime.parse(date);
  }

  final start = parseDate(startDate);

  if (isInvalidDate(endDate)) {
    return DateFormat("dd MMM yyyy").format(start);
  }

  final end = parseDate(endDate!);

  if (start.year == end.year &&
      start.month == end.month &&
      start.day == end.day) {
    return DateFormat("dd MMM yyyy").format(start);
  }

  return "${DateFormat("dd MMM yyyy").format(start)} - ${DateFormat("dd MMM yyyy").format(end)}";
}
