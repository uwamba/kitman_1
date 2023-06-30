import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class maps extends StatefulWidget {
  LatLng pickingPoint;
  bool isPickingLocation;
  int btnClick;

  maps(this.pickingPoint, this.isPickingLocation, this.btnClick);

  @override
  _HomePageState createState() => _HomePageState(btnClick, pickingPoint);
}

class _HomePageState extends State<maps> {
  double _lat = 13.0827;
  double _lng = 80.2707;
  String distanceText = "Location";

  Completer<GoogleMapController> _controller = Completer();
  final Completer<GoogleMapController> mapController = Completer();
  Location location = new Location();
  LatLng loc;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  CameraPosition _currentPosition;
  Marker marker;
  PolylineId polylineId = PolylineId("order");
  final Set<Marker> markers = Set();
  final Set<Polyline> polys = Set();

  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyDb43xswSOqr64gN2mLA53aqmvTmlseIR8";

  ///String googleAPiKey = "AIzaSyC-dIJ5UWH1sd05F8fx4sHhtZZ7hHNwmbo";

  Set<Marker> markers2 = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  // LatLng startLocation = LatLng(-1.9534712184928378, 30.097560882568363);
  //LatLng endLocation = LatLng(-1.9934712184928378, 30.007560882568363);
  LatLng startLocation;
  LatLng endLocation;
  Widget position;
  double distance = 0.0;
  int btnClick;
  LatLng pickingPoint;
  _HomePageState(this.btnClick, this.pickingPoint);
  @override
  initState() {
    super.initState();
    if (btnClick == 2) {
      startLocation = pickingPoint;
    }
    _currentPosition = CameraPosition(
      target: LatLng(-1.9534712184928378, 30.097560882568363),
      zoom: 12,
    );
    if (widget.isPickingLocation == true) {
      position = Positioned(
          top: 30,
          left: 20,
          child: Container(
              child: Card(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Text("Picking Location",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          )));
    } else {
      position = Positioned(
          top: 30,
          left: 20,
          child: Container(
              child: Card(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Text(distanceText,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          )));

      markers.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        position: widget.pickingPoint,
        markerId: MarkerId("Picking Location"),
      ));
      polys.add(Polyline(
          polylineId: polylineId,
          points: getPoints(widget.pickingPoint, widget.pickingPoint),
          width: 5,
          color: Colors.green,
          visible: true));
    }

    getDirections();
    _locateMe();
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
        print("ooooooooooooooooooooooooooooooooooooooooooooooo");
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
    print("dddddddddddddddddddddddddddddddddddddddddddddd");
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
      color: Colors.redAccent,
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
      // markers.clear();
      if (widget.isPickingLocation == true) {
        markers.clear();
      } else {}
      markers.add(Marker(
          draggable: true,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(
            title: 'Delivery Point',
          ),
          markerId: MarkerId("Delivery Point"),
          position: latLng));
    });
  }

  void onMapCreated(GoogleMapController controller) {
    this.mapController.complete(controller);

    //moveToCurrentUserLocation();
    //getDirections();
  }

  getPoints(LatLng a, LatLng b) {
    return [
      a,
      b,
    ];
  }

  void moveToLocation(LatLng latLng) {
    this.mapController.future.then((controller) {
      loc = latLng;

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 12.0)),
      );
    });

    setMarker(latLng);
    if (widget.isPickingLocation == false) {
      setState(() {
        polys.clear();
        polys.add(Polyline(
            polylineId: polylineId,
            points: getPoints(widget.pickingPoint, latLng),
            width: 5,
            color: Colors.green,
            visible: true));
        print(calculateDistance(
                widget.pickingPoint.latitude,
                widget.pickingPoint.longitude,
                startLocation.latitude,
                startLocation.longitude)
            .toString);
        distanceText = "Total Distance: " +
            calculateDistance(
                    widget.pickingPoint.latitude,
                    widget.pickingPoint.longitude,
                    startLocation.latitude,
                    startLocation.longitude)
                .toString();
      });
    }
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
              mapType: MapType.hybrid, //map type
              onMapCreated: onMapCreated,
              polylines: Set<Polyline>.of(polylines.values),
              onTap: (latLng) {
                if (btnClick == 1) {
                  startLocation = latLng;
                  print("BUTTON 1111111111111111111111111111111");
                } else if (btnClick == 2) {
                  endLocation = latLng;
                  print("BUTTON 22222222222222222222222222");
                }
                //clearOverlay();
                moveToLocation(latLng);
                getDirections();
              },
              markers: markers,
            ),
            Positioned(
                bottom: 200,
                left: 50,
                child: Container(
                    child: Card(
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                          "Total Distance: " +
                              distance.toStringAsFixed(2) +
                              " KM",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                )))
          ])),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Select Location'),
        icon: Icon(Icons.location_searching),
        backgroundColor: Colors.pink,
        onPressed: () => Navigator.of(context)
            .pop(loc.toString() + ";" + distance.toString()),
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
