import 'package:latlong2/latlong.dart';

class PlaceModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final LatLng location;
  final List<String> imageUrls;
  final String? sdgRelevance;
  final String createdBy;
  final DateTime createdAt;
  final bool isVerified;
  final List<String> tags;
  final int visitCount;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.location,
    required this.imageUrls,
    this.sdgRelevance,
    required this.createdBy,
    required this.createdAt,
    required this.isVerified,
    required this.tags,
    required this.visitCount,
  });
}