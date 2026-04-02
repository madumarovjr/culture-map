import 'package:latlong2/latlong.dart';

class AppConstants {
  // Map defaults (Seoul)
  static const LatLng defaultLocation = LatLng(37.5780, 126.9830);
  static const double defaultZoom = 14.5;
  static const double minZoom = 5.0;
  static const double maxZoom = 19.0;

  // Map tiles
  static const String osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  // Gemini API key (добавим позже)
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';

  // Categories
  static const List<Map<String, String>> categories = [
    {'id': 'architecture', 'name': 'Architecture'},
    {'id': 'festivals', 'name': 'Festivals'},
    {'id': 'traditions', 'name': 'Traditions'},
    {'id': 'food', 'name': 'Food'},
    {'id': 'art', 'name': 'Art'},
  ];
}