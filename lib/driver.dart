import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DriverTrackingPage extends StatefulWidget {
  @override
  _DriverTrackingPageState createState() => _DriverTrackingPageState();
}

class _DriverTrackingPageState extends State<DriverTrackingPage> {
  late final MapController _mapController;
  LatLng driverPosition = const LatLng(48.8566, 2.3522); // Paris coordinates
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _simulateDriverMovement();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _simulateDriverMovement() async {
    while (!_isDisposed) {
      await Future.delayed(const Duration(seconds: 3));

      if (_isDisposed) return;

      setState(() {
        // Move driver north-east
        driverPosition = LatLng(
          driverPosition.latitude + 0.001,
          driverPosition.longitude + 0.001,
        );
      });

      // Smoothly move the map to new position
      _mapController.move(driverPosition, _mapController.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Tracking'), centerTitle: true),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: driverPosition,
          initialZoom: 15.0,
          onMapReady: () {
            // Optional: Add any map ready logic
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: driverPosition,
                width: 60.0,
                height: 60.0,
                child: const Icon(
                  Icons.directions_car,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Center map on driver position
          _mapController.move(driverPosition, _mapController.camera.zoom);
        },
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }
}
