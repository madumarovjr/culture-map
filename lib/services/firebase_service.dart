import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../features/place/models/place_model.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<PlaceModel>> getPlaces() async {
    try {
      final snapshot = await _db.collection('Place').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PlaceModel(
          id: doc.id,
          name: data['Name'] ?? data['name'] ?? '',
          description: data['Description'] ?? data['description'] ?? '',
          category: data['category'] ?? 'architecture',
          location: LatLng(
            (data['latitude'] ?? data['Latitude'] ?? 0).toDouble(),
            (data['Longitude'] ?? data['longitude'] ?? 0).toDouble(),
          ),
          imageUrls: [],
          sdgRelevance: data['sdgRelevance'] ?? data['SdgRelevance'] ?? '',
          createdBy: 'system',
          createdAt: DateTime.now(),
          isVerified: data['isVerified'] ?? false,
          tags: List<String>.from(data['Tags'] ?? data['tags'] ?? []),
          visitCount: (data['VisitCount'] ?? data['visitCount'] ?? 0).toInt(),
        );
      }).toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}