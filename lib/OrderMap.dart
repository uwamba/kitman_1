import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMap extends StatefulWidget {
  static const String idScreen = "MainScreen";

  String orderNumber, driverNumber;
  OrderMap(this.orderNumber, this.driverNumber);

  @override
  _OrderMap createState() => _OrderMap();
}

class _OrderMap extends State<OrderMap> {
  Marker _markers;
  LocationCoordinates currentCoordinates;
  List<LocationCoordinates> lsc = [];
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-2.5825288719982, 29.01545043904463),
    zoom: 12,
    tilt: 70,
  );
  BitmapDescriptor icon;
  List listMarkerIds = [];
  final Set<Marker> markers = Set();
  driverUpdate() {
    DatabaseReference usersQuery = FirebaseDatabase.instance.ref('presence');
    usersQuery.onChildChanged.listen((event) {
      getAllDriversLocation();
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

  getIcons() async {
    final Uint8List markerIcon =
        await getBytesFromAsset("assets/images/moto_icon.png", 80);
    //final Marker marker = Marker(icon: BitmapDescriptor.fromBytes(markerIcon));
    var icon = BitmapDescriptor.fromBytes(markerIcon);
    setState(() {
      this.icon = icon;
    });
  }

  getAllDriversLocation() {
    DatabaseReference usersQuery = FirebaseDatabase.instance.ref('presence');
    LinkedHashMap<Object, Object> map;
    Map<String, dynamic> presenceStatusTrue;

    usersQuery
        .once()
        .then((result) => result.snapshot.children.forEach((element) {
              print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
              //print(element.value);

              map = element.value;
              //print(map.values.elementAt(0));
              //lsc.add(map.values.elementAt(0).toString());

              print((map.values.elementAt(4).toString()) +
                  "," +
                  map.values.elementAt(7).toString() +
                  " " +
                  map.values.elementAt(0).toString());
              if (map.values.elementAt(0) == widget.driverNumber) {
                setState(() {
                  markers.add(Marker(
                    icon: icon,
                    markerId: MarkerId(map.values.elementAt(0)),
                    position: LatLng(
                        map.values.elementAt(4), map.values.elementAt(7)),
                    infoWindow: InfoWindow(title: widget.orderNumber),
                  ));
                });
              }
            }));
    // print(lsc[0].latitude);
  }

  void addMarker(lat, long, name) {
    //Making this markerId dynamic
    final MarkerId markerId = MarkerId(name);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      infoWindow: InfoWindow(title: name),
    );
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
    getIcons();
    getAllDriversLocation();

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
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.only(top: 100),
            // padding: EdgeInsets.fromLTRB(0, 100, 0, 15) + MediaQuery.of(context).padding,
            markers: markers,
            trafficEnabled: true,
            compassEnabled: false,
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              // startForegroundService();
              // goTOCurrentUserLocation();
              // getCurrentLocation();
              getAllDriversLocation();
            },
          ),
        ],
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
