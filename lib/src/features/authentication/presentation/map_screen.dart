import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:hot_spot/src/features/overview/domain/menue.dart';
import 'package:hot_spot/src/data/auth_repository.dart';
import 'package:hot_spot/src/data/database_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class MapScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;
  final AuthRepository authRepository;
  final String username;
  final String profileImageUrl;

  const MapScreen({
    Key? key,
    required this.databaseRepository,
    required this.authRepository,
    required this.username,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController mapController;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController markerDescriptionController =
      TextEditingController();
  bool isSearching = false;
  Map<String, String> markerDescriptions = {};
  Map<String, GeoPoint> markers = {};

  @override
  void initState() {
    super.initState();
    mapController = MapController(
      initPosition: GeoPoint(latitude: 51.1657, longitude: 10.4515),
    );
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    GeoPoint initialLocation = await _getInitialLocation();
    await mapController.changeLocation(initialLocation);
    await mapController.setZoom(zoomLevel: 12);
    _addMapListeners();
    await _loadMarkersFromFirestore();
    await _updateMapMarkers();
  }

  Future<GeoPoint> _getInitialLocation() async {
    try {
      Position? position = await _getCurrentLocation();
      if (position != null) {
        await _saveLastKnownLocation(position);
        return GeoPoint(
            latitude: position.latitude, longitude: position.longitude);
      }
    } catch (e) {
      debugPrint("Fehler beim Abrufen des aktuellen Standorts: $e");
    }

    GeoPoint? lastKnownLocation = await _getLastKnownLocation();
    if (lastKnownLocation != null) {
      return lastKnownLocation;
    }

    return GeoPoint(latitude: 51.1657, longitude: 10.4515);
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _saveLastKnownLocation(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('last_known_latitude', position.latitude);
    await prefs.setDouble('last_known_longitude', position.longitude);
  }

  Future<GeoPoint?> _getLastKnownLocation() async {
    final prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('last_known_latitude');
    double? longitude = prefs.getDouble('last_known_longitude');
    if (latitude != null && longitude != null) {
      return GeoPoint(latitude: latitude, longitude: longitude);
    }
    return null;
  }

  void _addMapListeners() {
    mapController.listenerMapSingleTapping.addListener(() {
      if (mapController.listenerMapSingleTapping.value != null) {
        var position = mapController.listenerMapSingleTapping.value;
        _checkForMarkerTap(position!);
      }
    });

    mapController.listenerRegionIsChanging.addListener(() {
      var region = mapController.listenerRegionIsChanging.value;
      if (region != null) {
        debugPrint("Region geändert: Zentrum: ${region.center}");
      }
    });
  }

  void _checkForMarkerTap(GeoPoint position) {
    String markerId = "${position.latitude},${position.longitude}";
    if (markers.containsKey(markerId)) {
      _showMarkerInfo(position);
    } else {
      _showAddMarkerDialog(position);
    }
  }

  void _showAddMarkerDialog(GeoPoint position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Marker hinzufügen'),
          content: TextField(
            controller: markerDescriptionController,
            decoration:
                const InputDecoration(hintText: "Beschreibung eingeben"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hinzufügen'),
              onPressed: () {
                _addMarker(position, markerDescriptionController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addMarker(GeoPoint position, String description) async {
    String markerId = "${position.latitude},${position.longitude}";
    markerDescriptions[markerId] = description;

    await mapController.addMarker(
      position,
      markerIcon: const MarkerIcon(
        icon: Icon(Icons.location_on, color: Colors.red, size: 48),
      ),
    );

    markers[markerId] = position;

    await _saveMarkerToFirestore(position, description);

    debugPrint(
        "Marker hinzugefügt bei ${position.latitude}, ${position.longitude} mit Beschreibung: $description");
    markerDescriptionController.clear();

    await _updateMapMarkers();
  }

  Future<void> _saveMarkerToFirestore(
      GeoPoint position, String description) async {
    try {
      await firestore.FirebaseFirestore.instance.collection('gewaesser').add({
        'name': description,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'location': firestore.GeoPoint(position.latitude, position.longitude),
        'createdAt': firestore.FieldValue.serverTimestamp(),
        'createdBy': widget.username,
      });
      debugPrint("Marker erfolgreich in Firestore gespeichert");
    } catch (e) {
      debugPrint("Fehler beim Speichern des Markers in Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler beim Speichern des Markers')),
      );
    }
  }

  void _showMarkerInfo(GeoPoint position) {
    String markerId = "${position.latitude},${position.longitude}";
    String description =
        markerDescriptions[markerId] ?? "Keine Beschreibung verfügbar";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Marker Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Beschreibung: $description'),
              const SizedBox(height: 8),
              Text('Breitengrad: ${position.latitude.toStringAsFixed(6)}'),
              Text('Längengrad: ${position.longitude.toStringAsFixed(6)}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Schließen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadMarkersFromFirestore() async {
    try {
      firestore.QuerySnapshot querySnapshot = await firestore
          .FirebaseFirestore.instance
          .collection('gewaesser')
          .get();
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String markerId = "${data['latitude']},${data['longitude']}";
        GeoPoint position =
            GeoPoint(latitude: data['latitude'], longitude: data['longitude']);
        markerDescriptions[markerId] = data['name'];

        markers[markerId] = position;
      }
      debugPrint("${markers.length} Marker aus Firestore geladen");
    } catch (e) {
      debugPrint("Fehler beim Laden der Marker aus Firestore: $e");
    }
  }

  Future<void> _updateMapMarkers() async {
    // Manuelles Entfernen aller Marker
    for (var marker in markers.values) {
      await mapController.removeMarker(marker);
    }

    // Hinzufügen aller Marker zur Karte
    for (var entry in markers.entries) {
      await mapController.addMarker(
        entry.value,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.location_on, color: Colors.red, size: 48),
        ),
      );
    }
    debugPrint("Karte mit ${markers.length} Markern aktualisiert");
  }

  Future<void> _searchLocation() async {
    setState(() {
      isSearching = true;
    });

    String searchQuery = searchController.text;
    try {
      var searchResult = await addressSuggestion(searchQuery);
      if (searchResult.isNotEmpty) {
        var location = searchResult.first;
        await mapController.setZoom(zoomLevel: 12);
        await mapController.changeLocation(
          GeoPoint(
              latitude: location.point!.latitude,
              longitude: location.point!.longitude),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ort nicht gefunden')),
        );
      }
    } catch (e) {
      debugPrint("Fehler bei der Ortssuche: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler bei der Suche')),
      );
    } finally {
      setState(() {
        isSearching = false;
      });
    }
  }

  void _zoomIn() {
    mapController.zoomIn();
  }

  void _zoomOut() {
    mapController.zoomOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Gewässer Karte'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: CustomDrawer(
        username: widget.username,
        profileImageUrl: widget.profileImageUrl,
        databaseRepository: widget.databaseRepository,
        authRepository: widget.authRepository,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/hintergründe/Blancscreen.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      OSMFlutter(
                        controller: mapController,
                        osmOption: OSMOption(
                          userTrackingOption: UserTrackingOption(
                            enableTracking: false,
                            unFollowUser: false,
                          ),
                          zoomOption: ZoomOption(
                            initZoom: 12,
                            minZoomLevel: 2,
                            maxZoomLevel: 19,
                            stepZoom: 1.0,
                          ),
                          userLocationMarker: UserLocationMaker(
                            personMarker: const MarkerIcon(
                              icon: Icon(Icons.location_on,
                                  color: Colors.red, size: 48),
                            ),
                            directionArrowMarker: const MarkerIcon(
                              icon: Icon(Icons.navigation,
                                  color: Colors.green, size: 48),
                            ),
                          ),
                          roadConfiguration: RoadOption(
                            roadColor: Colors.yellowAccent,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: Column(
                          children: [
                            FloatingActionButton(
                              onPressed: _zoomIn,
                              child: const Icon(Icons.add),
                              mini: true,
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton(
                              onPressed: _zoomOut,
                              child: const Icon(Icons.remove),
                              mini: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Suche nach einem Ort',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: isSearching
                          ? const CircularProgressIndicator()
                          : IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _searchLocation,
                            ),
                    ),
                    onSubmitted: (_) => _searchLocation(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
