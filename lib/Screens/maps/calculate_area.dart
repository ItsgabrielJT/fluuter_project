import 'dart:async';
import 'dart:collection';

import 'package:fluuter_project/Screens/homepage/components/home_page_body.dart';
import 'package:fluuter_project/models/calculation.dart';
import 'package:fluuter_project/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class CalculateAreaScreen extends StatefulWidget {
  const CalculateAreaScreen({super.key});

  @override
  State<CalculateAreaScreen> createState() => MapSampleState();
}

class MapSampleState extends State<CalculateAreaScreen> {
  GoogleMapController? _mapController;
  List<LatLng> points = [];
  Set<Marker> _markers = {}; // Conjunto de marcadores
  Set<Polygon> _polygone = HashSet<Polygon>();
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
      _setPolygone();
    });
  }

  Future<void> calculateArea() async {
    int n = points.length;
    double area = 0;

    for (int i = 0; i < n - 1; i++) {
      area += (points[i].latitude * points[i + 1].longitude -
          points[i + 1].latitude * points[i].longitude);
    }

    area += (points[n - 1].latitude * points[0].longitude -
        points[0].latitude * points[n - 1].longitude);

    area = area.abs() / 2.0;

    Calculation calculation = Calculation(
      points: points,
      area: area, 
      timestamp: DateTime.now(),
    );

    if (await addCalculation(calculation)) {
      Get.snackbar("Success", "Arear registrada con exito");
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomeScreenBody()),
      );
    } else {
      Get.snackbar("Error", "Algo ha sucedido, espere un momento");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _addMarkers() {
    for (var user in userList) {
      final marker = Marker(
        markerId: MarkerId(user['name']),
        position: LatLng(user['latitud'], user['longitud']),
        infoWindow: InfoWindow(title: user['name']),
      );
      points.add(LatLng(user['latitud'], user['longitud']));
      //print(marker);
      setState(() {
        _markers.add(marker);
        if (_firstMarker == null) {
          _firstMarker = marker;
          _setInitialCameraPosition(marker.position);
        }
      });
    }
  }

  void _setPolygone() {
    _polygone.add(Polygon(
      polygonId: const PolygonId('1'),
      points: points,
      strokeColor: const Color.fromARGB(255, 41, 195, 120),
      strokeWidth: 5,
      fillColor: Colors.greenAccent.withOpacity(0.5),
    ));
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreenBody()),
            );
          },
        ),
        title: const Text('Calculo de area'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _firstMarker != null
            ? CameraPosition(
                target: _firstMarker!.position,
                zoom:
                    15, // Ajusta este valor para establecer el nivel de zoom deseado
              )
            : const CameraPosition(
                target: LatLng(-0.180653, -78.467834),
                zoom: 15,
              ),
        onMapCreated: _onMapCreated,
        markers: _markers, // Usar el conjunto de marcadores actual
        polygons: _polygone,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: calculateArea,
        
        label: Text(
          "Calcular",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 41, 195, 120),
      ),
    );
  }
}