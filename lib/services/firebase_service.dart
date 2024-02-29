import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    });
  });
  return users;
}

// Leer base de datos
Future<List> getPeople() async {
  List people = [];
  QuerySnapshot querySnapshot = await db.collection('user').get();

  for (var doc in querySnapshot.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final person = {
      "name": data['name'],
      "email": data['email'],
      "uid": doc.id,
      "isAdmin": data['isAdmin'] ?? false,
      "isActive": data['isActive'] ?? false
    };
    people.add(person);
    print('Datos recuperados de Firestore: $people');

  }
  return people;
  
}

// Añadir a base de datos
Future<void> registerUser(String email, String password, String name,
    bool isActive, bool isAdmin) async {
  try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String? uid = userCredential.user?.uid;

    // Una vez registrado el usuario, lo guardamos en Firestore
    if (uid != null) {
      await db.collection('people').doc(uid).set({
        'name': name,
        'email': email,
        'isActive': isActive,
        "isAdmin": isAdmin,
      });
    }
  } catch (e) {
    print(e);
    throw e;
  }
}

// Actualizar
// Actualizar
Future<void> updatePeople(String uid, String name, String email, bool isActive, bool isAdmin) async {
  try {
     print('Updating user with UID: $uid'); // Nuevo punto de registro
    print('Inside updatePeople Service - Updating Firestore...'); // Nuevo punto de registro
    await db.collection("people").doc(uid).update({
      "name": name,
      "email": email,
      "isActive": isActive,
      "isAdmin": isAdmin,
    });
    print('Update successful!'); // Nuevo punto de registro
  } catch (e) {
    print('Update Error: $e'); // Nuevo punto de registro
    if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
      print('Este correo electrónico ya está en uso.');
    }
  }
}


// Eliminar
Future<void> deletePeople(String uid) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    // Eliminar el usuario de Firebase Authentication
    await _auth.currentUser!.delete();

    // Eliminar el documento en Firestore
    await db.collection("people").doc(uid).delete();
  } catch (e) {
    print(e);
    throw e;
  }
}
