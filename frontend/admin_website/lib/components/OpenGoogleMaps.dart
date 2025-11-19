import 'dart:html' as html;

class OpenMap {
  static bool isGoogleMapsUrl(String text) {
    if (text.isEmpty) return false;

    return text.startsWith("https://") ||
        text.startsWith("http://") ||
        text.contains("maps.app.goo.gl") ||
        text.contains("goo.gl/maps") ||
        text.contains("google.com/maps");
  }

  static void openGoogleMaps(String text) {
    final value = text.trim();

    if (value.isEmpty) {
      html.window.open("https://www.google.com/maps", "_blank");
      return;
    }

    if (isGoogleMapsUrl(value)) {
      html.window.open(value, "_blank");
      return;
    }
    
    final encoded = Uri.encodeComponent(value);
    html.window.open(
      "https://www.google.com/maps/search/?api=1&query=$encoded",
      "_blank",
    );
  }
}
