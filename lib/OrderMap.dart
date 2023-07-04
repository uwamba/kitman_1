import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderLocation extends StatefulWidget {
  static const String idScreen = "MainScreen";

  String orderNumber, driverNumber;
  GeoPoint pickupPoint;
  GeoPoint deliveryPoint;
  OrderLocation(this.orderNumber, this.driverNumber, this.pickupPoint,
      this.deliveryPoint);

  @override
  _OrderMap createState() => _OrderMap();
}

class _OrderMap extends State<OrderLocation> {
  LocationCoordinates currentCoordinates;
  List<LocationCoordinates> lsc = [];
  GoogleMapController gMapController;
  LatLng senderCoordinates, receiverCoordinates;
  final Completer<GoogleMapController> mapController = Completer();
  BitmapDescriptor icon;
  Map<PolylineId, Polyline> polylines = {};
  List listMarkerIds = [];
  List<LatLng> list;
  final Set<Polyline> polys = Set();
  String distanceText = "Location";
  PolylinePoints polylinePoints = PolylinePoints();
  double distance = 0.0;
  PolylineId polylineId = PolylineId("order");
  String googleAPiKey = "AIzaSyDb43xswSOqr64gN2mLA53aqmvTmlseIR8";
  final Set<Marker> markers = Set();
  driverUpdate() {
    DatabaseReference usersQuery = FirebaseDatabase.instance.ref('presence');
    usersQuery.onChildChanged.listen((event) {
      getDriversLocation();
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  getPoints(LatLng a, LatLng b) {
    return [
      a,
      b,
    ];
  }

  Future getDriversLocation() async {
    Map<String, String> map;
    final Uint8List markerIcon =
        await getBytesFromAsset("assets/images/moto_icon.png", 120);
    //final Marker marker = Marker(icon: BitmapDescriptor.fromBytes(markerIcon));
    var icon = BitmapDescriptor.fromBytes(markerIcon);

    this.icon = icon;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("presence/" + widget.driverNumber);
    DatabaseReference child = ref.child("email");
    print(ref.key);
    print(ref.parent.key); // "users"
    print(child.get());
    DatabaseEvent event = await ref.once();
    //final data = event.snapshot.value;
    final dataMap = new Map<String, dynamic>.from(event.snapshot.value);
    return dataMap;
    // print(lsc[0].latitude);
  }

  Future getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(widget.pickupPoint.latitude, widget.pickupPoint.longitude),
      PointLatLng(
          widget.deliveryPoint.latitude, widget.deliveryPoint.longitude),
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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
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

  void onMapCreated(GoogleMapController controller) {
    this.mapController.complete(controller);
    gMapController = controller;
    senderCoordinates =
        LatLng(widget.pickupPoint.latitude, widget.pickupPoint.longitude);
    receiverCoordinates =
        LatLng(widget.deliveryPoint.latitude, widget.deliveryPoint.longitude);
    list = [senderCoordinates, receiverCoordinates];

    moveToLocation(list);
    getDirections();
  }

  void moveToLocation(List<LatLng> listLatLng) {
    setState(() {
      LatLngBounds bound = boundsFromLatLngList(listLatLng);
      Future.delayed(Duration(milliseconds: 500)).then((v) async {
        CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 100);
        this.gMapController.animateCamera(u2).then((void v) {
          check(u2, this.gMapController);
        });
      });

      LatLng latLng =
          LatLng(widget.deliveryPoint.latitude, widget.deliveryPoint.longitude);
      polys.clear();
      polys.add(Polyline(
          polylineId: polylineId,
          points: getPoints(latLng, latLng),
          width: 5,
          color: Colors.green,
          visible: true));
      print(calculateDistance(
              widget.pickupPoint.latitude,
              widget.pickupPoint.longitude,
              widget.deliveryPoint.latitude,
              widget.deliveryPoint.longitude)
          .toString);
      distanceText = "Total Distance: " +
          calculateDistance(
                  widget.pickupPoint.latitude,
                  widget.pickupPoint.longitude,
                  widget.deliveryPoint.latitude,
                  widget.deliveryPoint.longitude)
              .toString();
    });
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    gMapController.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();

    driverUpdate();
  }

  @override
  Widget build(BuildContext context) {
    // getIcons();
    LatLng from = LatLng(-1.9298076, 30.2829831);
    final CameraPosition _kGooglePlex = CameraPosition(
      target: from,
      zoom: 12,
      tilt: 70,
    );
    markers.add(Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: MarkerId("Delivery Point"),
      position:
          LatLng(widget.deliveryPoint.latitude, widget.deliveryPoint.longitude),
      infoWindow: InfoWindow(title: "Delivery Point"),
    ));
    markers.add(Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: MarkerId("Pickup Point"),
      position:
          LatLng(widget.pickupPoint.latitude, widget.pickupPoint.longitude),
      infoWindow: InfoWindow(title: "Pickup Point"),
    ));
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        toolbarHeight: 50,
        // shadowColor: Colors.grey,
        backgroundColor: Colors.white.withOpacity(0.0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Order Tracking",
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        builder: (context, orderSnap) {
          if (!orderSnap.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            markers.add(Marker(
              icon: icon,
              markerId: MarkerId(orderSnap.data['UID']),
              position: LatLng(
                  orderSnap.data["latitude"], orderSnap.data["longitude"]),
              infoWindow: InfoWindow(title: orderSnap.data["UID"]),
            ));
            try {
              return Stack(
                children: [
                  GoogleMap(
                    padding: const EdgeInsets.only(top: 100),
                    // padding: EdgeInsets.fromLTRB(0, 100, 0, 15) + MediaQuery.of(context).padding,
                    markers: markers,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    mapType: MapType.hybrid,
                    trafficEnabled: true,
                    compassEnabled: false,
                    tiltGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    polylines: Set<Polyline>.of(polylines.values),
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: onMapCreated,
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
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                      )))
                ],
              );
            } on SocketException catch (_) {
              return Center(child: Text("no internet connection"));
            }
          }
        },
        future: getDriversLocation(),
      ),
    );
  }
}

class LocationCoordinates {
  double latitude;
  double longitude;
  String name;
}

displayToastMessage(String message, BuildContext context) {
  // create the displayToastMessage method.
  // giveit a parameter that will be a message.
  //Fluttertoast.showToast(msg: (message));
}
