import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tadbiro/controllers/mapController.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  LatLng? locationToGo;
  bool isAdding;

  MapScreen({
    super.key,
    required this.locationToGo,
    required this.isAdding,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  MapType _currentMapType = MapType.normal; // Default map type
  Marker? selectedPointMarker;
  LatLng? selectedPOintLocation;
  Placemark? placeName;

  @override
  void initState() {
    super.initState();
    mapController.locationToGo = widget.locationToGo;
    mapController.initLocationService((location) {
      setState(() {
        mapController.myCurrentLocation = location;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
        backgroundColor: Colors.green[700],
        actions: [
          DropdownButton<MapType>(
            value: _currentMapType,
            icon: const Icon(Icons.map, color: Colors.white),
            dropdownColor: Colors.green[700],
            items: const [
              DropdownMenuItem(
                value: MapType.normal,
                child: Text('Normal'),
              ),
              DropdownMenuItem(
                value: MapType.satellite,
                child: Text('Satellite'),
              ),
              DropdownMenuItem(
                value: MapType.terrain,
                child: Text('Terrain'),
              ),
              DropdownMenuItem(
                value: MapType.hybrid,
                child: Text('Hybrid'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _currentMapType = value!;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (mapController.myCurrentLocation != null)
            GoogleMap(
              onMapCreated: mapController.onMapCreated,
              onCameraMove: (position) {
                selectedPOintLocation = position.target;
                mapController.onCameraMove(position, (newLocation) {
                  setState(() {
                    selectedPointMarker = Marker(
                      markerId: MarkerId(widget.locationToGo.toString()),
                      position: newLocation,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                    );
                  });
                });
              },
              initialCameraPosition: CameraPosition(
                target: widget.locationToGo ?? mapController.myCurrentLocation!,
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: _currentMapType, // Set the map type
              markers: {
                if (mapController.myCurrentLocation != null)
                  Marker(
                    markerId: const MarkerId("MyLocation"),
                    position: mapController.myCurrentLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure),
                    infoWindow: const InfoWindow(
                      title: "My Location",
                    ),
                  ),
                if (selectedPointMarker != null) selectedPointMarker!,
              },
              polylines: mapController.polylines,
            ),
          Positioned(
            top: 20,
            left: 10, // Moved the IconButton column to the left
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Align children to the start (left)
                children: [
                  IconButton(
                    icon: const Icon(Icons.directions_walk),
                    onPressed: () {
                      mapController
                          .onTravelModeButtonPressed(TravelMode.walking, () {
                        setState(() {});
                      });
                    },
                    color: mapController.currentTravelMode == TravelMode.walking
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  IconButton(
                    icon: const Icon(Icons.directions_bike),
                    onPressed: () {
                      mapController
                          .onTravelModeButtonPressed(TravelMode.bicycling, () {
                        setState(() {});
                      });
                    },
                    color:
                        mapController.currentTravelMode == TravelMode.bicycling
                            ? Colors.blue
                            : Colors.grey,
                  ),
                  IconButton(
                    icon: const Icon(Icons.directions_car),
                    onPressed: () {
                      mapController
                          .onTravelModeButtonPressed(TravelMode.driving, () {
                        setState(() {});
                      });
                    },
                    color: mapController.currentTravelMode == TravelMode.driving
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: widget.isAdding
          ? FloatingActionButton(
              onPressed: () async {
                mapController.addMarker(
                  (updatedPolylines) {
                    setState(() {
                      mapController.polylines = updatedPolylines;
                    });
                  },
                );
                if (selectedPOintLocation != null) {
                  placeName = await mapController.getAddressFromLatLng(
                      selectedPOintLocation!.latitude,
                      selectedPOintLocation!.longitude);
                }
                Navigator.pop(context, [selectedPOintLocation, placeName]);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
