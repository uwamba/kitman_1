import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class maps extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<maps> {
  double _lat = 13.0827;
  double _lng = 80.2707;
  Completer<GoogleMapController> _controller = Completer();
  final Completer<GoogleMapController> mapController = Completer();
  Location location = new Location();
  String loc = "";
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  CameraPosition _currentPosition;
  Marker marker;
  final Set<Marker> markers = Set();
  @override
  initState() {
    super.initState();

    _currentPosition = CameraPosition(
      target: LatLng(-2.594528010383094, 29.00782908451525),
      zoom: 12,
    );
    markers.add(Marker(
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(-2.594528010383094, 29.00782908451525),
      markerId: MarkerId("selected-location"),
    ));
  }

  _locateMe() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await location.getLocation().then((res) async {
      final GoogleMapController controller = await _controller.future;
      final _position = CameraPosition(
        target: LatLng(res.latitude, res.longitude),
        zoom: 12,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_position));
      setState(() {
        _lat = res.latitude;
        _lng = res.longitude;
      });
    });
  }

  setUpMarker() async {
    const currentLocationCamera = LatLng(37.42796133580664, -122.085749655962);

    final pickupMarker = Marker(
      markerId: MarkerId("${currentLocationCamera.latitude}"),
      position: LatLng(
          currentLocationCamera.latitude, currentLocationCamera.longitude),
    );
    return pickupMarker;
  }

  void setMarker(LatLng latLng) {
    // markers.clear();
    setState(() {
      markers.clear();
      markers.add(Marker(
          draggable: true,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(
            title: 'Kigali',
          ),
          markerId: MarkerId("selected-location"),
          position: latLng));
    });
  }

  _mapTapped(location) {
    print(location);
    // Location currentLatitude = location.latitude;
    //Location currentLongitude = location.longitude;
    //Show only one marker
    setMarker(location);
  }

  void onMapCreated(GoogleMapController controller) {
    this.mapController.complete(controller);
    moveToCurrentUserLocation();
  }

  void moveToCurrentUserLocation() {
    Location().getLocation().then((locationData) {
      LatLng target = LatLng(locationData.latitude, locationData.longitude);
      moveToLocation(target);
    }).catchError((error) {
      // TODO: Handle the exception here
      print(error);
    });
  }

  void moveToLocation(LatLng latLng) {
    this.mapController.future.then((controller) {
      loc = latLng.toString();
      print(
          "lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll" +
              latLng.toString());
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 12.0)),
      );
    });

    setMarker(latLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: GoogleMap(
          initialCameraPosition: _currentPosition,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: onMapCreated,
          onTap: (latLng) {
            //clearOverlay();
            moveToLocation(latLng);
          },
          markers: markers,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Select Location'),
        icon: Icon(Icons.location_searching),
        backgroundColor: Colors.pink,
        onPressed: () => Navigator.of(context).pop(loc),
      ),
    );
  }
}
//GoogleMap(
//onTap: _mapTapped,
//initialCameraPosition: _currentPosition,
//markers:marker
//onMapCreated: (GoogleMapController controller) {
//_controller.complete(controller);
//},
//),
