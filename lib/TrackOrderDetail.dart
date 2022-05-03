import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:knitman/model/orderList.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

import 'generated/l10n.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/SizeConfig.dart';

class TrackOrderDetail extends StatefulWidget {
  final String keyword;
  final OrderList list;
  TrackOrderDetail(this.keyword, this.list);

  @override
  _TrackOrderDetail createState() {
    return _TrackOrderDetail();
  }
}

class _TrackOrderDetail extends State<TrackOrderDetail> {
  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  CameraPosition _kGooglePlex;

  Completer _controller = Completer();
  Map<MarkerId, Marker> markers = {};

  List listMarkerIds = [];

  BitmapDescriptor customIcon1;
  LatLng senderCoordinates, receiverCoordinates;
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

  double margin;
  // List<OrderList> activeOrderListModel;
  getList() async {
    print(widget.keyword);
    senderCoordinates = LatLng(widget.list.senderCoordinates.latitude,
        widget.list.senderCoordinates.longitude);
    receiverCoordinates = LatLng(widget.list.receiverCoordinates.latitude,
        widget.list.receiverCoordinates.longitude);
    print(receiverCoordinates);
    _kGooglePlex = CameraPosition(
      target: senderCoordinates,
      zoom: 12.0,
    );
    getPoints();
  }

  @override
  Widget build(BuildContext context) {
    getList();
    // print(list.elementAt(0).orderNumber);
    //senderCoordinates = LatLng(list.elementAt(0).senderCoordinates.latitude,
    //list.elementAt(0).senderCoordinates.longitude);
    //receiverCoordinates = LatLng(list.elementAt(0).receiverCoordinates.latitude,
    // list.elementAt(0).receiverCoordinates.longitude);
    //_kGooglePlex = CameraPosition(
    //  target: senderCoordinates,
    //  zoom: 12.0,
    // );
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.list.senderCoordinates.latitude,
          widget.list.senderCoordinates.longitude),
      zoom: 12.0,
    );
    createMarker(context);
    PolylineId polylineId = PolylineId("area");
    SizeConfig().init(context);
    margin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = ConstantWidget.getScreenPercentSize(context, 40);
    double bottomHeight = SizeConfig.safeBlockVertical * 20;

    double bottomImageHeight = ConstantWidget.getPercentSize(bottomHeight, 50);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.primaryColor,
            title: ConstantWidget.getAppBarText(S.of(context).trackOrder),
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
              child: ListView(
                children: [
                  Container(
                    height: height * 2,
                    child: Stack(
                      children: [
                        Container(
                          height: height * 2,
                          width: double.infinity,
                          child: GoogleMap(
                            initialCameraPosition: _kGooglePlex,
                            onTap: (_) {},
                            markers: Set.of(markers.values),
                            polylines: Set<Polyline>.of(<Polyline>[
                              Polyline(
                                  polylineId: polylineId,
                                  points: getPoints(),
                                  width: 5,
                                  color: Colors.green,
                                  visible: true),
                            ]),
                            onMapCreated: (GoogleMapController controler) {
                              print("complete-----true");
                              _controller.complete(controler);

                              MarkerId markerId1 = MarkerId("1");
                              MarkerId markerId2 = MarkerId("2");
                              MarkerId markerId3 = MarkerId("3");
                              MarkerId markerId4 = MarkerId("4");
                              MarkerId markerId5 = MarkerId("5");
                              MarkerId markerId6 = MarkerId("6");

                              listMarkerIds.add(markerId1);
                              listMarkerIds.add(markerId2);
                              listMarkerIds.add(markerId3);
                              listMarkerIds.add(markerId4);
                              listMarkerIds.add(markerId5);
                              listMarkerIds.add(markerId6);

                              Marker marker1 = Marker(
                                  markerId: markerId1,
                                  position: LatLng(
                                      widget.list.senderCoordinates.latitude,
                                      widget.list.senderCoordinates.longitude),
                                  icon: customIcon1
                                  // LatLng(21.214571209464843, 72.88491829958917),
                                  );

                              Marker marker2 = Marker(
                                markerId: markerId2,
                                position: LatLng(
                                    widget.list.receiverCoordinates.latitude,
                                    widget.list.receiverCoordinates.longitude),

                                // LatLng(21.21103054325307, 72.89371594512971),
                              );

                              setState(() {
                                markers[markerId1] = marker1;
                                markers[markerId2] = marker2;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: margin),
                    color: ConstantData.cellColor,
                    width: double.infinity,
                    height: SizeConfig.safeBlockVertical * 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstantWidget.getHorizonSpace(
                            SizeConfig.safeBlockHorizontal * 1.5),
                        Expanded(
                            child: InkWell(
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstantWidget.getCustomText(
                                  "Status:" + widget.list.status,
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
                                    size: ConstantWidget.getPercentSize(
                                        bottomHeight, 15),
                                  ),
                                  ConstantWidget.getHorizonSpace(
                                      SizeConfig.safeBlockHorizontal * 1.2),
                                  ConstantWidget.getCustomText(
                                      "Driver: " +
                                          widget.list.driverNumber.toString(),
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
                              _callNumber(widget.list.driverNumber);
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (margin),
                  ),
                  //_DeliveryProcesses(processes: _data(0).deliveryProcesses),
                ],
              )),
        ),
        onWillPop: _requestPop);
  }

  void _callNumber(number) async {
    String url = "tel:" + number;
    await launch(url);
  }

  getPoints() {
    return [senderCoordinates, receiverCoordinates];
  }

  _OrderInfo _data(int id) => _OrderInfo(
        deliveryProcesses: [
          _DeliveryProcess(
            'FLIGHT 6E 2341',
            '7:00AM',
            true,
            'Order Placed by jatin maheta',
            messages: [
              // _DeliveryMessage('8:30am', 'Package received by driver'),
              // _DeliveryMessage('11:30am', 'Reached halfway mark'),
            ],
          ),
          _DeliveryProcess(
            '7:00AM',
            'Package Process',
            true,
            'Delivery boy assigned:Manan Singh',
            messages: [
              // _DeliveryMessage('8:30am', 'Package received by driver'),
              // _DeliveryMessage('11:30am', 'Reached halfway mark'),
            ],
          ),
          _DeliveryProcess(
            '7:00AM',
            'Package Process',
            false,
            'Courier is picked up',
            messages: [
              // _DeliveryMessage('8:30am', 'Package received by driver'),
              // _DeliveryMessage('11:30am', 'Reached halfway mark'),
            ],
          ),
          _DeliveryProcess(
            '7:00AM',
            'Package Process',
            false,
            'Courier is on the way to deliver package',
            messages: [
              // _DeliveryMessage('8:30am', 'Package received by driver'),
              // _DeliveryMessage('11:30am', 'Reached halfway mark'),
            ],
          ),
          _DeliveryProcess(
            '7:00AM',
            'In Transit',
            false,
            'Courier is delivered',
            messages: [
              // _DeliveryMessage('13:00pm', 'Driver arrived at destination'),
              // _DeliveryMessage('11:35am', 'Package delivered by m.vassiliades'),
            ],
          ),
          // _DeliveryProcess.complete(),
        ],
      );
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({Key key, @required this.processes})
      : assert(processes != null),
        super(key: key);

  final List<_DeliveryProcess> processes;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          ConstantWidget.getScreenPercentSize(context, 3),
        ),
        // padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Colors.grey.shade300,
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: ConstantWidget.getScreenPercentSize(context, 2.3),
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
                    bottom: ConstantWidget.getScreenPercentSize(context, 7)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      processes[index].name,
                      textAlign: TextAlign.start,
                      style: DefaultTextStyle.of(context).style.copyWith(
                          fontSize:
                              ConstantWidget.getScreenPercentSize(context, 2),
                          // fontSize: ConstantData.font18Px,
                          fontFamily: ConstantData.fontFamily,
                          color: ConstantData.mainTextColor,
                          fontWeight: FontWeight.w600),
                    ),

                    SizedBox(
                      height: ConstantWidget.getScreenPercentSize(context, 0.5),
                    ),
                    Text(
                      processes[index].address,
                      textAlign: TextAlign.start,
                      style: DefaultTextStyle.of(context).style.copyWith(
                          fontSize:
                              ConstantWidget.getScreenPercentSize(context, 1.8),
                          // fontSize: ConstantData.font18Px,
                          fontFamily: ConstantData.fontFamily,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400),
                    ),

                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       left: ConstantWidget.getScreenPercentSize(context, 1.5),
                    //       bottom: ConstantWidget.getScreenPercentSize(context, 7)),
                    //   child: Align(
                    //     alignment: Alignment.topLeft,
                    //     child: Text(
                    //
                    //       processes[index].name,
                    //       textAlign: TextAlign.start,
                    //       style: DefaultTextStyle.of(context).style.copyWith(
                    //
                    //           fontSize: ConstantWidget.getScreenPercentSize(context, 1.8),
                    //           // fontSize: ConstantData.font18Px,
                    //           fontFamily: ConstantData.fontFamily,
                    //           color: ConstantData.mainTextColor,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //   ),
                    //
                    //
                    // )
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

class _DeliveryMessage {
  const _DeliveryMessage(this.createdAt, this.message);

  final String createdAt; // final DateTime createdAt;
  final String message;

  @override
  String toString() {
    return '$createdAt $message';
  }
}

class _DeliveryProcess {
  const _DeliveryProcess(
    this.timeStamp,
    this.address,
    this.isComplete,
    this.name, {
    this.messages = const [],
  });

  final String name;
  final String timeStamp;
  final bool isComplete;
  final String address;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
}

class _OrderInfo {
  const _OrderInfo({
    @required this.deliveryProcesses,
  });

  final List<_DeliveryProcess> deliveryProcesses;
}
