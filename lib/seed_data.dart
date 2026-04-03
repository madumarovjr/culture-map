import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  final db = FirebaseFirestore.instance;
  final places = [
    {
      'Name': 'Bukchon Hanok Village',
      'Description': 'Traditional Korean village with 600-year-old hanok houses',
      'category': 'architecture',
      'latitude': 37.5826,
      'Longitude': 126.9836,
      'VisitCount': 8930,
      'isVerified': false,
      'Tags': ['Hanok', 'Traditional', 'Village'],
    },
    {
      'Name': 'Jongmyo Shrine',
      'Description': 'The oldest Confucian royal shrine, UNESCO World Heritage',
      'category': 'traditions',
      'latitude': 37.5744,
      'Longitude': 126.9940,
      'VisitCount': 5420,
      'isVerified': false,
      'Tags': ['Shrine', 'Confucian', 'UNESCO'],
    },
    {
      'Name': 'Insadong Cultural Street',
      'Description': 'Vibrant district with traditional tea houses and crafts',
      'category': 'art',
      'latitude': 37.5714,
      'Longitude': 126.9863,
      'VisitCount': 12350,
      'isVerified': false,
      'Tags': ['Shopping', 'Crafts', 'Tea'],
    },
    {
      'Name': 'Gwangjang Market',
      'Description': 'One of Korea oldest traditional markets since 1905',
      'category': 'food',
      'latitude': 37.5700,
      'Longitude': 126.9996,
      'VisitCount': 9870,
      'isVerified': false,
      'Tags': ['Market', 'Streetfood', 'Traditional'],
    },
  ];

  for (final place in places) {
    await db.collection('Place').add(place);
    print('Added: ${place['Name']}');
  }
  
  print('All places added!');
}