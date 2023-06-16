import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:knitman/model/OrderTimeline.dart';
import 'package:knitman/model/orderList.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/SizeConfig.dart';

class ActiveOrderDetail extends StatefulWidget {
  //final ActiveOrderModel activeOrderModel;
  final OrderList activeOrderModel;
  ActiveOrderDetail(this.activeOrderModel);
  @override
  _ActiveOrderDetail createState() {
    return _ActiveOrderDetail();
  }
}

class _ActiveOrderDetail extends State<ActiveOrderDetail> {
  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  String firstName = "", lastName = "", driverPhone = "";
  final Set<Marker> markers = Set();
  PolylineId polylineId = PolylineId("area");
  final Set<Polyline> polys = Set();
  GoogleMapController gMapController;
  initState() {
    super.initState();
    senderCoordinates = LatLng(
        widget.activeOrderModel.senderCoordinates.latitude,
        widget.activeOrderModel.senderCoordinates.longitude);
    receiverCoordinates = LatLng(
        widget.activeOrderModel.receiverCoordinates.latitude,
        widget.activeOrderModel.receiverCoordinates.longitude);
    _kGooglePlex = CameraPosition(
      target: senderCoordinates,
      zoom: 12.0,
    );

    markers.add(Marker(
        draggable: true,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
          title: 'Delivery Point',
        ),
        markerId: MarkerId("Delivery Point"),
        position: senderCoordinates));
    markers.add(Marker(
        draggable: true,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
          title: 'Delivery Point',
        ),
        markerId: MarkerId("Delivery Point"),
        position: receiverCoordinates));
    polys.add(Polyline(
        polylineId: polylineId,
        points: getPoints(senderCoordinates, receiverCoordinates),
        width: 5,
        color: Colors.green,
        visible: true));
  }

  final Completer<GoogleMapController> mapController = Completer();
  CameraPosition _kGooglePlex;
  List listMarkerIds = [];
  BitmapDescriptor customIcon1;

  createMarker(context) {
    if (customIcon1 == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);

      BitmapDescriptor.fromAssetImage(
              configuration, ConstantData.assetsPath + 'food-delivery.png')
          .then((icon) {
        setState(() {
          customIcon1 = icon;
        });
      });
    }
  }

  String delivery = "Urgent";
  LatLng senderCoordinates, receiverCoordinates;
  List<OrderTimeLine> timeLine = [];

  @override
  Widget build(BuildContext context) {
    //moveToSenderLocation();

    SizeConfig().init(context);
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = ConstantWidget.getScreenPercentSize(context, 60);
    double bottomHeight = SizeConfig.safeBlockVertical * 20;

    double bottomImageHeight = ConstantWidget.getPercentSize(bottomHeight, 50);
    SizeConfig().init(context);

    timeLine.clear();
    OrderTimeLine model = new OrderTimeLine();
    model.location = widget.activeOrderModel.senderLocation;
    model.phone = widget.activeOrderModel.senderPhone;
    model.isComplete = true;
    timeLine.add(model);

    OrderTimeLine model2 = new OrderTimeLine();
    model2.location = widget.activeOrderModel.receiverLocation;
    model2.phone = widget.activeOrderModel.receiverPhone;
    model2.status = widget.activeOrderModel.status;
    model2.isComplete = true;
    timeLine.add(model2);

    print(widget.activeOrderModel.receiverLocation +
        "sssssssssssssssssssss" +
        widget.activeOrderModel.senderLocation);

    if (widget.activeOrderModel.deliveryType == "0") {
      delivery = "Urgent";
    }
    print(widget.activeOrderModel.driverNumber);
    List lis;
    Future<List> driver() async {
      final DatabaseReference ref = await FirebaseDatabase.instance
          .ref()
          .child("presence/" + widget.activeOrderModel.driverNumber);
      final event = await ref.once(DatabaseEventType.value);
      final data = event.snapshot;
      final parsed = data.children.map((doc) => doc.value).toList();
      lis = parsed.toList();
      print(lis);
      return lis;
    }

    void _callNumber() async {
      String s = driverPhone;

      String url = "tel:" + s;
      await launch(url);
    }

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.primaryColor,
            title: ConstantWidget.getAppBarText(S.of(context).order +
                " " +
                widget.activeOrderModel.orderNumber),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: ConstantWidget.getAppBarIcon(),
                  onPressed: _requestPop,
                );
              },
            ),
          ),
          body: Container(
            height: double.infinity,
            child: FutureBuilder(
              builder: (ctx, snapshot) {
                // Checking if future is resolved or not
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: TextStyle(fontSize: 18),
                      ),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    final List data = snapshot.data;
                    return ListView(
                      children: [
                        Container(
                          height: height,
                          child: Stack(
                            children: [
                              Container(
                                height: height,
                                width: double.infinity,
                                child: GoogleMap(
                                  initialCameraPosition: _kGooglePlex,
                                  myLocationButtonEnabled: true,
                                  compassEnabled: true,
                                  myLocationEnabled: true,
                                  tiltGesturesEnabled: true,
                                  mapToolbarEnabled: true,
                                  mapType: MapType.hybrid, //map type
                                  onMapCreated: onMapCreated,
                                  polylines: polys,
                                  onTap: (latLng) {
                                    //clearOverlay();
                                    moveToLocation(latLng);
                                    // getDirections();
                                  },
                                  markers: markers,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                color: Colors.green,
                                padding: EdgeInsets.all(margin),
                                child: ConstantWidget.getTextWidget(
                                    widget.activeOrderModel.deliveryDate,
                                    Colors.white,
                                    TextAlign.start,
                                    FontWeight.w500,
                                    ConstantData.font18Px),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: margin),
                                width: double.infinity,
                                color: ConstantData.cellColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: (margin / 2),
                                    ),
                                    ConstantWidget.getTextWidget(
                                        widget.activeOrderModel.price,
                                        ConstantData.mainTextColor,
                                        TextAlign.start,
                                        FontWeight.w400,
                                        ConstantWidget.getScreenPercentSize(
                                            context, 3)),
                                    SizedBox(
                                      height: (margin / 2),
                                    ),
                                    ConstantWidget.getTextWidget(
                                        "To be delivered at: " +
                                            widget.activeOrderModel
                                                .receiverLocation,
                                        Colors.grey,
                                        TextAlign.start,
                                        FontWeight.w400,
                                        ConstantData.font18Px),
                                    SizedBox(
                                      height: (margin / 2),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: margin, horizontal: margin),
                                child: ConstantWidget.getTextWidget(
                                    "Courier",
                                    ConstantData.mainTextColor,
                                    TextAlign.start,
                                    FontWeight.bold,
                                    ConstantWidget.getScreenPercentSize(
                                        context, 2)),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: margin),
                                color: ConstantData.cellColor,
                                width: double.infinity,
                                height: SizeConfig.safeBlockVertical * 16,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      // borderRadius: BorderRadius.all(Radius.circular(
                                      //     ConstantWidget.getPercentSize(
                                      //         bottomImageHeight, 12))),
                                      child: Image.asset(
                                        ConstantData.assetsPath + "hugh.png",
                                        fit: BoxFit.cover,
                                        width: bottomImageHeight,
                                        height: bottomImageHeight,
                                      ),
                                    ),
                                    ConstantWidget.getHorizonSpace(
                                        SizeConfig.safeBlockHorizontal * 1.5),
                                    Expanded(
                                        child: InkWell(
                                      onTap: () {},
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ConstantWidget.getCustomText(
                                              data.elementAt(2) +
                                                  " " +
                                                  data.elementAt(3),
                                              ConstantData.mainTextColor,
                                              1,
                                              TextAlign.start,
                                              FontWeight.w500,
                                              ConstantWidget.getPercentSize(
                                                  bottomHeight, 15)),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: ConstantData.accentColor,
                                                size: ConstantWidget
                                                    .getPercentSize(
                                                        bottomHeight, 15),
                                              ),
                                              ConstantWidget.getHorizonSpace(
                                                  SizeConfig
                                                          .safeBlockHorizontal *
                                                      1.2),
                                              ConstantWidget.getCustomText(
                                                  driverPhone,
                                                  Colors.grey,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.normal,
                                                  ConstantWidget.getPercentSize(
                                                      bottomHeight, 12))
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                    IconButton(
                                        icon: Icon(
                                          Icons.call,
                                          color: ConstantData.accentColor,
                                          size: ConstantWidget.getPercentSize(
                                              bottomHeight, 20),
                                        ),
                                        onPressed: () {
                                          _callNumber();
                                        }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: (margin),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: margin),
                                width: double.infinity,
                                color: ConstantData.cellColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: (margin / 2),
                                    ),
                                    ConstantWidget.getTextWidget(
                                        "Information",
                                        Colors.grey,
                                        TextAlign.start,
                                        FontWeight.w400,
                                        ConstantWidget.getScreenPercentSize(
                                            context, 2)),
                                    SizedBox(
                                      height: (margin),
                                    ),

                                    getColumnCell(
                                      "Created",
                                      widget.activeOrderModel.deliveryDate,
                                    ),

                                    SizedBox(
                                      height: ((margin * 1.2)),
                                    ),

                                    getColumnCell(
                                      "Weight",
                                      widget.activeOrderModel.packageWeight,
                                    ),

                                    //
                                    SizedBox(
                                      height: ((margin * 1.2)),
                                    ),
                                    getColumnCell(
                                      "Delivery Method",
                                      widget.activeOrderModel.deliveryType,
                                    ),
                                    //
                                    SizedBox(
                                      height: ((margin * 1.2)),
                                    ),
                                    getColumnCell(
                                      "Contents",
                                      widget.activeOrderModel.packageType,
                                    ),

                                    //
                                    SizedBox(
                                      height: ((margin * 1.2)),
                                    ),
                                    getColumnCell(
                                      "Stated value",
                                      widget.activeOrderModel.packageValue,
                                    ),
                                    //
                                    SizedBox(
                                      height: ((margin * 1.2)),
                                    ),
                                    getColumnCell(
                                      "Payment Type",
                                      widget.activeOrderModel.paymentMethod,
                                    ),
                                    SizedBox(
                                      height: ((margin * 1.2)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: margin,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: margin, vertical: margin),
                                color: ConstantData.cellColor,
                                child: _DeliveryProcesses(processes: timeLine),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                }

                // Displaying LoadingSpinner to indicate waiting state
                return Center(
                  child: CircularProgressIndicator(),
                );
              },

              // Future that needs to be resolved
              // inorder to display something on the Canvas
              future: driver(),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  getColumnCell(String s, String s1) {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstantWidget.getTextWidget(s, Colors.grey, TextAlign.start,
            FontWeight.w400, ConstantData.font18Px),
        SizedBox(
          height: (margin / 4),
        ),
        ConstantWidget.getTextWidget(s1, ConstantData.mainTextColor,
            TextAlign.start, FontWeight.w400, ConstantData.font18Px),
      ],
    );
  }

  void onMapCreated(GoogleMapController controller) {
    this.mapController.complete(controller);
    gMapController = controller;
    senderCoordinates = LatLng(
        widget.activeOrderModel.senderCoordinates.latitude,
        widget.activeOrderModel.senderCoordinates.longitude);
    receiverCoordinates = LatLng(
        widget.activeOrderModel.receiverCoordinates.latitude,
        widget.activeOrderModel.receiverCoordinates.longitude);
    LatLngBounds bound = LatLngBounds(
        southwest: senderCoordinates, northeast: receiverCoordinates);
    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
    this.gMapController.animateCamera(u2).then((void v) {
      check(u2, this.gMapController);
    });

    // moveToSenderLocation();
    //getDirections();
  }

  void moveToLocation(LatLng latLng) {
    this.mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 12.0)),
      );
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
}

getPoints(LatLng a, LatLng b) {
  return [
    a,
    b,
  ];
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({Key key, @required this.processes})
      : assert(processes != null),
        super(key: key);

  final List<OrderTimeLine> processes;

  @override
  Widget build(BuildContext context) {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);

    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: EdgeInsets.zero,
        // padding: EdgeInsets.all(
        //   ConstantWidget.getScreenPercentSize(context, 3),
        // ),
        // padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Colors.grey.shade300,
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: ConstantWidget.getScreenPercentSize(context, 1.8),
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 1.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              // if (processes[index].isCompleted) return null;

              // return Container(height: 300,color: Colors.redAccent,);
              return Container(
                padding: EdgeInsets.only(
                    left: ConstantWidget.getScreenPercentSize(context, 1.5),
                    bottom: (index != (processes.length - 1))
                        ? ConstantWidget.getScreenPercentSize(context, 3)
                        : 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      processes[index].location,
                      textAlign: TextAlign.start,
                      style: DefaultTextStyle.of(context).style.copyWith(
                          fontSize:
                              ConstantWidget.getScreenPercentSize(context, 1.8),
                          // fontSize: ConstantData.font18Px,
                          fontFamily: ConstantData.fontFamily,
                          color: ConstantData.textColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: ConstantWidget.getScreenPercentSize(context, 3),
                    ),
                    Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstantWidget.getTextWidget(
                                "Contact",
                                Colors.grey,
                                TextAlign.start,
                                FontWeight.w400,
                                ConstantData.font18Px),
                            SizedBox(
                              height: (margin / 4),
                            ),
                            ConstantWidget.getTextWidget(
                                processes[index].phone,
                                ConstantData.mainTextColor,
                                TextAlign.start,
                                FontWeight.w400,
                                ConstantData.font18Px),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.call,
                            color: Colors.grey,
                            size:
                                ConstantWidget.getScreenPercentSize(context, 3),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (processes[index].isComplete) {
                // return DotIndicator(
                //   color: Color(0xff66c97f),
                //   child: Icon(
                //     Icons.check,
                //     color: Colors.white,
                //     size: 12.0,
                //   ),
                // );

                return OutlinedDotIndicator(
                  borderWidth: 1.5,
                  color: ConstantData.accentColor,
                );
              } else {
                return OutlinedDotIndicator(
                  borderWidth: 1.5,
                  color: Colors.grey,
                );
              }
            },
            connectorBuilder: (_, index, ___) {
              if (processes[index].isComplete) {
                return SolidLineConnector(
                  color: processes[index].isComplete
                      ? ConstantData.accentColor
                      : null,
                );
              } else {
                return null;
              }
            },
          ),
        ),
      ),
    );
  }
}
