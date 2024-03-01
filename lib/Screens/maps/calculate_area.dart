import 'dart:async';
import 'dart:collection';

import 'package:fluuter_project/Screens/homepage/components/home_page_body.dart';
import 'package:fluuter_project/models/calculation.dart';
import 'package:fluuter_project/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
  

class CalculateAreaScreen extends StatefulWidget {
  const CalculateAreaScreen({super.key});

  @override
  State<CalculateAreaScreen> createState() => MapSampleState();
}

class MapSampleState extends State<CalculateAreaScreen> {
  GoogleMapController? _mapController;
  List<LatLng> points = [];
  List<mp.LatLng> coordeantes = [];
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



  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
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

  Future<void> calculateArea() async {
    if (!(coordeantes.length < 3)) {
      var area = mp.SphericalUtil.computeArea(coordeantes);
      Calculation calculation = Calculation(
        id: "",
        points: points,
        area: area,
        timestamp: DateTime.now(),
      );

      await showConfirmationDialog(context, calculation, area);
    } else {
      showErrorMessage("No hay las puntos necesarios para calcular");
    }
  }

  double _calculateSegmentArea(LatLng point1, LatLng point2) {
  double latitude1 = point1.latitude;
  double longitude1 = point1.longitude;
  double latitude2 = point2.latitude;
  double longitude2 = point2.longitude;

  // Fórmula de Gauss para calcular el área de un segmento triangular
  return (latitude1 * longitude2 - latitude2 * longitude1) / 2.0;
}

  Future<void> showConfirmationDialog(
      BuildContext context, Calculation calculation, dynamic area) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: Text('¿Deseas guardar el cálculo: $area ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                // Aquí puedes guardar el cálculo en Firestore u otro lugar según tus necesidades
                saveCalculationInFirestore(calculation);

                Navigator.of(context).pop(); // Cierra el modal
              },
            ),
          ],
        );
      },
    );
  }

// Método para guardar el cálculo en Firestore (puedes personalizar según tus necesidades)
  Future<void> saveCalculationInFirestore(Calculation calculation) async {
    if (await addCalculation(calculation)) {
      Get.snackbar("Success", "Area registrada con exito");
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
      if (user['isActive']) {
        final marker = Marker(
          markerId: MarkerId(user['name']),
          position: LatLng(user['latitud'], user['longitud']),
          infoWindow: InfoWindow(title: user['name']),
        );
        points.add(LatLng(user['latitud'], user['longitud']));
        coordeantes.add(mp.LatLng(user['latitud'], user['longitud']));
        setState(() {
          _markers.add(marker);
          if (_firstMarker == null) {
            _firstMarker = marker;
            _setInitialCameraPosition(marker.position);
          }
        });
      }
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
        15, // Ajusta este valor para establecer el nivel de zoom deseado
      ));
    }
  }

  void cleanArea() {
    setState(() {
      _markers = {};
      _polygone = HashSet<Polygon>();
      points = [];
      _firstMarker = null;
    });
  }

  void drawPolygone() {
    if (points.length == 0) {
      showErrorMessage("No hay ubicaciones para dibujar el area");
    } else {
      setState(() {
        _setPolygone();
      });
    }
  }

  void _addMarkerOnCameraCenter(latlng) {
    final marker = Marker(
      markerId: MarkerId("${_markers.length + 1}"),
      position: latlng,
      infoWindow: InfoWindow(title: "Position ${_markers.length + 1}"),
    );
    setState(() {
      _markers.add(marker);
      points.add(latlng);
      if (_firstMarker == null) {
        _firstMarker = marker;
        _setInitialCameraPosition(marker.position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        onTap: (_ontap) => _addMarkerOnCameraCenter(_ontap),
        markers: _markers, // Usar el conjunto de marcadores actual
        polygons: _polygone,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Stack(
        children: [
           Positioned(
            left: 8.0,
            bottom: 16.0,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: loadUsers,
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 41, 195, 120),
                  tooltip: "Ubicar",
                  child: const Icon(Icons.location_pin),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
                  onPressed: calculateArea,
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 41, 195, 120),
                  tooltip: "Calcular",
                  child: const Icon(Icons.calculate),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
                  onPressed: drawPolygone,
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 41, 195, 120),
                  tooltip: "Dibujar",
                  child: Icon(
                    Icons.polyline,
                  ),
                ),

                SizedBox(height: 16.0), // Ajusta el espacio entre los botones
                FloatingActionButton(
                  onPressed: cleanArea,
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 231, 73, 45),
                  tooltip: "Borrar",
                  child: Icon(
                    Icons.delete,
                  ),
                ),
              ],
            ),
          ) ,
        ],
      ),
    );
  }
}
