import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/place/models/place_model.dart';

final placesProvider = Provider<List<PlaceModel>>((ref) {
  return [
    PlaceModel(
      id: '1',
      name: 'Gyeongbokgung Palace',
      description: 'The main royal palace of the Joseon dynasty, built in 1395.',
      category: 'architecture',
      location: const LatLng(37.5796, 126.9770),
      imageUrls: [],
      sdgRelevance: 'Preserves traditional Korean architecture and cultural identity',
      createdBy: 'system',
      createdAt: DateTime.now(),
      isVerified: true,
      tags: ['palace', 'joseon', 'history'],
      visitCount: 15420,
    ),
    PlaceModel(
      id: '2',
      name: 'Bukchon Hanok Village',
      description: 'Traditional Korean village with 600-year-old hanok houses.',
      category: 'architecture',
      location: const LatLng(37.5826, 126.9836),
      imageUrls: [],
      sdgRelevance: 'Protects traditional residential architecture',
      createdBy: 'system',
      createdAt: DateTime.now(),
      isVerified: true,
      tags: ['hanok', 'traditional', 'village'],
      visitCount: 8930,
    ),
    PlaceModel(
      id: '3',
      name: 'Jongmyo Shrine',
      description: 'The oldest Confucian royal shrine, UNESCO World Heritage.',
      category: 'traditions',
      location: const LatLng(37.5744, 126.9940),
      imageUrls: [],
      sdgRelevance: 'Preserves Confucian rituals and ancestral traditions',
      createdBy: 'system',
      createdAt: DateTime.now(),
      isVerified: true,
      tags: ['shrine', 'confucian', 'unesco'],
      visitCount: 5420,
    ),
    PlaceModel(
      id: '4',
      name: 'Insadong Cultural Street',
      description: 'Vibrant district with traditional tea houses and crafts.',
      category: 'art',
      location: const LatLng(37.5714, 126.9863),
      imageUrls: [],
      sdgRelevance: 'Supports traditional crafts and cultural economy',
      createdBy: 'system',
      createdAt: DateTime.now(),
      isVerified: true,
      tags: ['shopping', 'crafts', 'tea'],
      visitCount: 12350,
    ),
    PlaceModel(
      id: '5',
      name: 'Gwangjang Market',
      description: 'One of Korea oldest traditional markets, since 1905.',
      category: 'food',
      location: const LatLng(37.5700, 126.9996),
      imageUrls: [],
      sdgRelevance: 'Preserves traditional market culture and culinary heritage',
      createdBy: 'system',
      createdAt: DateTime.now(),
      isVerified: true,
      tags: ['market', 'streetfood', 'traditional'],
      visitCount: 9870,
    ),
  ];
});

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: AppConstants.defaultLocation,
              initialZoom: AppConstants.defaultZoom,
            ),
            children: [
              TileLayer(
                urlTemplate: AppConstants.osmTileUrl,
                userAgentPackageName: 'com.example.culturemap',
              ),
              MarkerLayer(
                markers: places.map((place) {
                  return Marker(
                    point: place.location,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _showPlaceDetail(context, place),
                      child: Icon(
                        Icons.location_on,
                        color: _getCategoryColor(place.category),
                        size: 40,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // SDG Badge
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.sdgOrange,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '11',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'SDG 11: Cultural Heritage',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPlaceDetail(BuildContext context, PlaceModel place) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(place.category),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    place.category.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'SDG 11',
                  style: TextStyle(
                    color: AppTheme.sdgOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              place.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              place.description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.visibility,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${place.visitCount} visits',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('I visited this place!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'architecture':
        return const Color(0xFF8D6E63);
      case 'festivals':
        return const Color(0xFFFF7043);
      case 'traditions':
        return const Color(0xFFAB47BC);
      case 'food':
        return const Color(0xFF66BB6A);
      case 'art':
        return const Color(0xFF42A5F5);
      default:
        return AppTheme.primaryColor;
    }
  }
}