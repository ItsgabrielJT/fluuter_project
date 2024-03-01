import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Calculation {
  final String id;
  final List<LatLng> points;
  final num area;
  final DateTime timestamp;

  Calculation({
    required this.id,
    required this.points,
    required this.area,
    required this.timestamp,
  });

  // Método para convertir a Map
  Map<String, dynamic> toMap() {
    return {
      'points': points.map((point) => GeoPoint(point.latitude, point.longitude)).toList(),
      'area': area,
      'timestamp': timestamp,
      'id': generateRandomId()
    };
  }

  // Método para crear una instancia desde Map
  factory Calculation.fromMap(Map<String, dynamic> map) {
    return Calculation(
      points: (map['points'] as List<dynamic>).map((geoPoint) {
        return LatLng(geoPoint.latitude, geoPoint.longitude);
      }).toList(),
      area: map['area'],
      timestamp: (map['timestamp'] as Timestamp).toDate(), 
      id: generateRandomId(),
    );
  }
}

String generateRandomId() {
  const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final Random random = Random();
  final int length = 20;

  String randomId = '';

  for (int i = 0; i < length; i++) {
    randomId += chars[random.nextInt(chars.length)];
  }

  return randomId;
}