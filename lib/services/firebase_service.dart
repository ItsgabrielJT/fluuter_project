import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluuter_project/models/calculation.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

Future<List<Map<String, dynamic>>> getUsers() async {
  List<Map<String, dynamic>> users = [];
  CollectionReference collectionReferenceUsers = db.collection('user');
  QuerySnapshot queryUsers = await collectionReferenceUsers.get();
  queryUsers.docs.forEach((element) {
    users.add({
      'name': element['name'],
      'latitud': element['latitud'],
      'longitud': element['longitud'],
      'isActive': element['isActive'],
    });
  });
  return users;
}

// Añadir a base de datos
Future<bool> addCalculation(Calculation calculation) async {
    try {
      await db.collection('calculations').add(calculation.toMap());
      return true;
    } catch (e) {
      print('Error adding calculation: $e');
    }
    return false;
  }
