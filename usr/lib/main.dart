import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Positioning Map',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MapPositioningScreen(),
      },
    );
  }
}

class MapPositioningScreen extends StatefulWidget {
  const MapPositioningScreen({super.key});

  @override
  State<MapPositioningScreen> createState() => _MapPositioningScreenState();
}

class _MapPositioningScreenState extends State<MapPositioningScreen> {
  LatLng? _selectedPosition;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Set a default initial position (e.g., London)
    _selectedPosition = const LatLng(51.509364, -0.128928);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Position'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Display the currently selected coordinates
          if (_selectedPosition != null)
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                children: [
                  const Text(
                    'Selected Coordinates:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lat: ${_selectedPosition!.latitude.toStringAsFixed(5)}, Lng: ${_selectedPosition!.longitude.toStringAsFixed(5)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          // The interactive map
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selectedPosition!,
                initialZoom: 13.0,
                // Update the marker position when the user taps on the map
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedPosition = point;
                  });
                },
              ),
              children: [
                // OpenStreetMap tile layer (Free, no API key required)
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.couldai.userapp',
                ),
                // Layer to display the marker at the selected position
                if (_selectedPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedPosition!,
                        width: 60,
                        height: 60,
                        alignment: Alignment.topCenter,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      // Button to re-center the map on the selected position
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedPosition != null) {
            _mapController.move(_selectedPosition!, 15.0);
          }
        },
        tooltip: 'Center on Marker',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
