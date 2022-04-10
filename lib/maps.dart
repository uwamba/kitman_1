import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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

  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyC-dIJ5UWH1sd05F8fx4sHhtZZ7hHNwmbo";

  Set<Marker> markers2 = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  LatLng startLocation = LatLng(-2.5825288719982, 29.01545043904463);
  LatLng endLocation = LatLng(-2.6115797815698643, 29.01829060711035);

  double distance = 0.0;
  @override
  initState() {
    super.initState();

    _currentPosition = CameraPosition(
      target: LatLng(-2.5825288719982, 29.01545043904463),
      zoom: 12,
    );
    markers.add(Marker(
      icon: BitmapDescriptor.defaultMarker,
      position: startLocation,
      markerId: MarkerId("start location"),
    ));
    markers.add(Marker(
      icon: BitmapDescriptor.defaultMarker,
      position: endLocation,
      markerId: MarkerId("end location"),
    ));
    getDirections();
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

  Future getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        print(polylineCoordinates);
        print(
            "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
      });
    } else {
      print(result.errorMessage);
    }

    //polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print(
        "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
    print(totalDistance);

    setState(() {
      distance = totalDistance;
    });

    //add to the list of poly line coordinates
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  setUpMarker() async {
    const currentLocationCamera = LatLng(-2.5825288719982, 29.01545043904463);

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
    //getDirections();
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
          child: Stack(children: [
            GoogleMap(
              initialCameraPosition: _currentPosition,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.normal, //map type
              onMapCreated: onMapCreated,

              onTap: (latLng) {
                //clearOverlay();
                moveToLocation(latLng);
                // getDirections();
              },
              markers: markers,
            ),
            // Positioned(
            // bottom: 200,
            // left: 50,
            // child: Container(
            //child: Card(
            //child: Container(
            //padding: EdgeInsets.all(20),
            //child: Text(
            // "Total Distance: " +
            // distance.toStringAsFixed(2) +
            //  " KM",
            // style: TextStyle(
            // fontSize: 20, fontWeight: FontWeight.bold))),
            //)))
          ])),
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
