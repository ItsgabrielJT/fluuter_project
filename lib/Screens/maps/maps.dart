import 'dart:async';

import 'package:fluuter_project/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapSampleState();
}

class MapSampleState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {}; // Conjunto de marcadores
  List<Map<String, dynamic>> userList = [];
  Marker? _firstMarker;

  @override
  void initState() {
    super.initState();
    loadUsers();

    // Escuchar cambios en Firestore y actualizar los marcadores
    FirebaseFirestore.instance
        .collection('user')
        .snapshots()
        .listen((snapshot) {
      loadUsers(); // Recargar los usuarios y actualizar los marcadores
    });
  }

  Future<void> loadUsers() async {
    final users =
        await getUsers(); // Obtener la lista de usuarios desde el servicio
    setState(() {
      userList = users; // Asignar la lista de usuarios
      _addMarkers(); // Agregar marcadores al mapa cuando se carguen los usuarios
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _addMarkers() {
    userList.forEach((user) {
      final marker = Marker(
        markerId: MarkerId(user['name']),
        position: LatLng(user['latitud'], user['longitud']),
        infoWindow: InfoWindow(title: user['name']),
      );
      print(marker);
      setState(() {
        _markers.add(marker);
        if (_firstMarker == null) {
          _firstMarker = marker;
          _setInitialCameraPosition(marker.position);
        }
      });
    });
  }

  void _setInitialCameraPosition(LatLng position) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(
        position,
        12, // Ajusta este valor para establecer el nivel de zoom deseado
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: GoogleMap(
        initialCameraPosition: _firstMarker != null
            ? CameraPosition(
                target: _firstMarker!.position,
                zoom:
                    12, // Ajusta este valor para establecer el nivel de zoom deseado
              )
            : const CameraPosition(
                target: LatLng(-0.180653, -78.467834),
                zoom: 10,
              ),
        onMapCreated: _onMapCreated,
        markers: _markers, // Usar el conjunto de marcadores actual
      ),
    );
  }
}
