import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert';
import 'package:hairloss/const/colors.dart';

class Place {
  final String name;
  final double latitude;
  final double longitude;

  Place({required this.name, required this.latitude, required this.longitude});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  LatLng? _initialPosition;
  GoogleMapController? mapController;
  Set<Marker> markers = {};  // Set to store markers
  Location location = Location();

  @override
  void initState() {
    super.initState();

    // Fetch and set user's current location
    getLocation().then((LatLng? position) {
      if (position != null) {
        setState(() {
          _initialPosition = position;
        });

        // Fetch nearby clinics and pharmacies
        fetchNearbyDermatologistsAndHairClinics(position.latitude, position.longitude, 'AIzaSyAJNdjcyEnrkR3iKsAz2LiLwFVUw-WMlCA').then((result) {
          setState(() {
            markers.clear();
            markers.addAll(result.map((place) {
              return Marker(
                markerId: MarkerId(place.name),
                position: LatLng(place.latitude, place.longitude),
                infoWindow: InfoWindow(title: place.name),
              );
            }).toList());
          });
        });

        fetchNearbyPharmacies(position.latitude, position.longitude, 'AIzaSyAJNdjcyEnrkR3iKsAz2LiLwFVUw-WMlCA').then((result) {
          setState(() {
            markers.clear();
            markers.addAll(result.map((place) {
              return Marker(
                markerId: MarkerId(place.name),
                position: LatLng(place.latitude, place.longitude),
                infoWindow: InfoWindow(title: place.name),
              );
            }).toList());
          });
        });
      }
    });
  }
  Future<LatLng?> getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;  // Return null if location service is not enabled
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;  // Return null if location permission is not granted
      }
    }

    LocationData locationData = await location.getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }


  // Future<LatLng?> getLocation() async {
  //   LatLng seoulStation = LatLng(37.553240, 126.968877);
  //   return seoulStation;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition!,
              zoom: 16.0,
            ),
            markers: markers,  // Use the markers set here
            circles: Set<Circle>.of([_createCircle()]),
          ),
          Positioned(
            bottom: 420.0,
            right: 12.0,
            child: FloatingActionButton(
              backgroundColor: PRIMARY_COLOR,
              foregroundColor: Colors.white,
              onPressed: () {
                if (_initialPosition != null && mapController != null) {
                  mapController!.animateCamera(CameraUpdate.newLatLng(_initialPosition!));
                }
              },
              shape: CircleBorder(),
              child: Icon(Icons.my_location),
            ),
          ),
          Positioned(
            bottom: 360.0,
            right: 12.0,
            child: FloatingActionButton(
              backgroundColor: PRIMARY_COLOR,
              foregroundColor: Colors.white,
              onPressed: _showPharmacies,
              shape: CircleBorder(),
              child: Icon(Icons.local_hospital),
            ),
          ),
        ],
      ),
    );
  }

  Circle _createCircle() {
    return Circle(
      circleId: CircleId('My Location'),
      center: _initialPosition!,
      radius: 6,
      fillColor: Colors.blue.withOpacity(0.5),
      strokeWidth: 1,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<void> _showPharmacies() async {
    final pharmacies = await fetchNearbyPharmacies(_initialPosition!.latitude, _initialPosition!.longitude, 'AIzaSyAJNdjcyEnrkR3iKsAz2LiLwFVUw-WMlCA');

    setState(() {
      // Clear previous markers and add new markers
      markers.clear();
      markers.addAll(pharmacies.map((place) {
        return Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(title: place.name),
        );
      }).toList());
    });
  }

  Future<List<Place>> fetchNearbyDermatologistsAndHairClinics(double lat, double lng, String apiKey) async {
    final apiUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=1000&type=doctor&keyword=dermatologist&key=$apiKey';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      final List<dynamic> results = decodedJson['results'];
      return results.map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception('피부과와 탈모 클리닉 정보를 불러오는데 실패했습니다.');
    }
  }

  Future<List<Place>> fetchNearbyPharmacies(double lat, double lng, String apiKey) async {
    final apiUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=1000&type=pharmacy&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      final List<dynamic> results = decodedJson['results'];
      return results.map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception('약국 정보를 불러오는데 실패했습니다.');
    }
  }
}