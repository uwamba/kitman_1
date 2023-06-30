import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:knitman/Database/Db.dart';
import 'package:knitman/PreferencePage.dart';
//import 'package:knitman/place_picker_custom/entities/location_result.dart';
//import 'package:knitman/place_picker_custom/widgets/place_picker.dart';
//import 'package:place_picker/place_picker.dart';
import 'package:knitman/google_place/place_picker.dart';
import 'package:knitman/maps.dart';
import 'package:knitman/util/PrefData.dart';

import 'generated/l10n.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class LocationPage extends StatefulWidget {
  String priority, weight, type;
  LocationPage(this.priority, this.weight, this.type);

  @override
  _LocationPage createState() {
    return _LocationPage();
  }
}

class _LocationPage extends State<LocationPage> {
  List<String> timeList = DataFile.getTimeList();
  List<String> dateList = DataFile.getDateList();
  GoogleMapController mapController;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  //PickResult selectedPlace;

  TextEditingController senderCoordinatesController = TextEditingController();
  TextEditingController senderLocationController = TextEditingController();
  TextEditingController senderPhoneController = TextEditingController();
  TextEditingController receiverCoordinatesController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();
  TextEditingController receiverLocationController = TextEditingController();
  TextEditingController packageValueController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  LatLng startLocation;
  LatLng endLocation;
  LatLng initialLocation = LatLng(-2.5825288719982, 29.01545043904463);
  //DateFormat formatter = DateFormat('yyyyMMddHHmmss');
  //String pointTime, pointDate;
  //String deliveryTime, deliveryDate;

  String fullName;
  String company;
  int age;
  String status,
      deliveryTime,
      deliveryDate,
      receivedTime,
      receivedDate,
      orderNumber,
      senderId,
      senderLocation,
      senderCoordinate,
      packageType,
      deliveryType,
      packageWeihgt,
      receiverLocation,
      receiverCoordinate,
      orderType,
      senderPhone,
      receiverPhone;

  Db db = new Db();

  //AddUser(this.fullName, this.company, this.age);

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  GeoPoint stringToLatLng(String text) {
    String splitted1 = text.split('LatLng(').toString();
    splitted = splitted1.split(')').toString();
    splitted = splitted.substring(3, splitted.length - 3);
    List<String> latlgn = splitted.split(',');
    double lat = double.parse(latlgn[0]);
    double lng = double.parse(latlgn[1]);
    // print(LatLng(lat, lng));
    return GeoPoint(lat, lng);
  }

  void getphone() async {
    senderId = await PrefData.getPhoneNumber();
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    //FirebaseFirestore firestore = FirebaseFirestore.instance;
    getphone();

    //senderCoordinatesController.text = initialLocation.toString();
    //receiverCoordinatesController.text = initialLocation.toString();
    //stringToLatLng(senderCoordinatesController.text);
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    // initialise database class

    setState(() {
      receivedDate = "Today";
      receivedTime = "13:00-14:00";
      deliveryDate = "Today";
      deliveryTime = "13:00-14:00";
      status = "New";
      packageType = widget.type;
      deliveryType = widget.priority;
      orderType = "Customer";
      packageWeihgt = widget.weight;
    });
  }

  String splitted = "";
  double margin;
  double radius;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    margin = ConstantWidget.getScreenPercentSize(context, 2);
    radius = ConstantWidget.getScreenPercentSize(context, 1.5);

    var spaceWidget = new SizedBox(
      height: margin,
    );

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.primaryColor,
            title: ConstantWidget.getAppBarText(S.of(context).locationDetails),
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
                spaceWidget,
                getPointCell("1", "Pickup Point"),
                spaceWidget,
                getAddressCell(senderCoordinatesController),
                spaceWidget,
                getPhoneCell(senderPhoneController),
                spaceWidget,
                getTimeAndDateCell(true),
                spaceWidget,
                getCommentCell(senderLocationController),
                spaceWidget,
                getPointCell("2", "Delivery Point"),
                spaceWidget,
                getAddressCell2(receiverCoordinatesController),
                spaceWidget,
                getPhoneCell(receiverPhoneController),
                spaceWidget,
                getTimeAndDateCell(false),
                spaceWidget,
                getCommentCell(receiverLocationController),
                spaceWidget,
                getPointCell("3", "Package Value"),
                spaceWidget,
                getPackageValueCell(packageValueController),
                spaceWidget,
                ConstantWidget.getBottomText(context, "Save Order", () {
                  DateTime now = new DateTime.now();
                  DateFormat formatter = DateFormat('yyyyMMddHHmmssms');
                  int number = int.parse(formatter.format(now));

                  // newOrder();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreferencePage(
                            status,
                            deliveryTime,
                            deliveryDate,
                            receivedTime,
                            receivedDate,
                            number.toRadixString(36).toUpperCase(),
                            receiverPhoneController.text,
                            receiverLocationController.text,
                            stringToLatLng(receiverCoordinatesController.text),
                            senderId,
                            senderPhoneController.text,
                            stringToLatLng(senderCoordinatesController.text),
                            senderLocationController.text,
                            widget.type,
                            widget.priority,
                            widget.weight,
                            orderType,
                            packageValueController.text),
                      ));
                })
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  getDecoration() {
    return BoxDecoration(
        color: ConstantData.cellColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
              color: ConstantData.shadowColor.withOpacity(0.2),
              blurRadius: 2,
              offset: Offset(0, 2),
              spreadRadius: 1)
        ]);
  }

  getAddressCell(TextEditingController textEditingController) {
    return InkWell(
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
        margin: EdgeInsets.symmetric(horizontal: margin),
        // color: ConstantData.cellColor,
        alignment: Alignment.centerLeft,

        decoration: getDecoration(),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          enabled: false,
          maxLines: 2,
          controller: textEditingController,
          style: TextStyle(
              fontFamily: ConstantData.fontFamily,
              color: ConstantData.mainTextColor),
          decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              suffixIcon: Icon(
                Icons.my_location,
                color: ConstantData.primaryColor,
              ),
              hintText: "Select location",
              hintStyle: TextStyle(
                  fontFamily: ConstantData.fontFamily, color: Colors.grey)),
        ),
      ),
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Alert!!"),
              content: new Text(
                  "Location Disclosure: This app collects location data to provide GPS information to the readingTechnology Company database. data may be collected in background or while in use. Click yes to continue and No to stop"),
              actions: <Widget>[
                TextButton(
                  child: new Text("Yes"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    startLocation = await Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new maps(initialLocation, true, 1)));
                    print(startLocation);
                    setState(() {
                      senderCoordinatesController.text =
                          startLocation.toString();
                    });
                  },
                ),
                TextButton(
                  child: new Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  getAddressCell2(TextEditingController textEditingController) {
    return InkWell(
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
        margin: EdgeInsets.symmetric(horizontal: margin),
        // color: ConstantData.cellColor,
        alignment: Alignment.centerLeft,

        decoration: getDecoration(),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          enabled: false,
          maxLines: 2,
          controller: textEditingController,
          style: TextStyle(
              fontFamily: ConstantData.fontFamily,
              color: ConstantData.mainTextColor),
          decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              suffixIcon: Icon(
                Icons.my_location,
                color: ConstantData.primaryColor,
              ),
              hintText: "Click To select location",
              hintStyle: TextStyle(
                  fontFamily: ConstantData.fontFamily, color: Colors.grey)),
        ),
      ),
      onTap: () async {
        if (startLocation != null) {
          endLocation = await Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new maps(startLocation, false, 2)));
          print(endLocation.toString());
          setState(() {
            receiverCoordinatesController.text = endLocation.toString();
          });
        }
      },
    );
  }

  void showPlacePicker() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyC-dIJ5UWH1sd05F8fx4sHhtZZ7hHNwmbo")));

    // Handle the result in your way
    //print(result.country);
  }

  void showPlacePicker2() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyC-dIJ5UWH1sd05F8fx4sHhtZZ7hHNwmbopp")));

    // Handle the result in your way
    print("gggggggggggggggggggggggggggg");
    print(result);
  }

  getCommentCell(TextEditingController textEditingController) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration: getDecoration(),
      child: TextField(
        controller: textEditingController,
        maxLines: 3,
        style: TextStyle(
            fontFamily: ConstantData.fontFamily,
            color: ConstantData.mainTextColor),
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Know address,Street, Ex: Makuza Plaza House",
            hintStyle: TextStyle(
                fontFamily: ConstantData.fontFamily, color: Colors.grey)),
      ),
    );
  }

  getDateCell(Text date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
      decoration: getDecoration(),
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          date,
          Padding(
            padding: EdgeInsets.all(margin),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: getCell(true, true),
                    onTap: () {
                      bottomDateDialog((true));
                    },
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: InkWell(
                    child: getCell(true, false),
                    onTap: () {
                      bottomTimeDialog(true);
                    },
                  ),
                  flex: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getTimeAndDateCell(bool isPoint) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
      decoration: getDecoration(),
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstantWidget.getTextWidget(
              S.of(context).whenToArriveAtThisAddAddress,
              Colors.grey,
              TextAlign.start,
              FontWeight.w400,
              ConstantData.font18Px),
          Padding(
            padding: EdgeInsets.all(margin),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: getCell(isPoint, true),
                    onTap: () {
                      bottomDateDialog((isPoint));
                    },
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: InkWell(
                    child: getCell(isPoint, false),
                    onTap: () {
                      bottomTimeDialog(isPoint);
                    },
                  ),
                  flex: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void bottomDateDialog(bool isPoint) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConstantData.bgColor,
      builder: (builder) {
        return new Container(
          padding: EdgeInsets.only(
            left: 5.0,
            right: 5.0,
            top: 5.0,
            bottom: 5.0,
          ),
          decoration: new BoxDecoration(
            color: ConstantData.bgColor,
          ),
          child: new Wrap(
            children: <Widget>[
              ListView.separated(
                shrinkWrap: true,
                itemCount: dateList.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(height: 5, color: ConstantData.mainTextColor),
                itemBuilder: (context, index) {
                  return new ListTile(
                    title: Text(
                      dateList[index],
                      style: TextStyle(
                          fontSize: ConstantData.font22Px,
                          fontWeight: FontWeight.w500,
                          fontFamily: ConstantData.fontFamily,
                          color: ConstantData.mainTextColor),
                    ),
                    onTap: () {
                      setState(() {
                        if (isPoint) {
                          receivedDate = dateList[index];
                        } else {
                          deliveryDate = dateList[index];
                        }
                      });

                      Navigator.pop(context);
                    },
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  void bottomTimeDialog(bool isPoint) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConstantData.bgColor,
      builder: (builder) {
        return new Container(
          padding: EdgeInsets.only(
            left: 5.0,
            right: 5.0,
            top: 5.0,
            bottom: 5.0,
          ),
          decoration: new BoxDecoration(
            color: ConstantData.bgColor,
          ),
          child: new Wrap(
            children: <Widget>[
              ListView.separated(
                shrinkWrap: true,
                itemCount: timeList.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(height: 5, color: ConstantData.mainTextColor),
                itemBuilder: (context, index) {
                  return new ListTile(
                    title: Text(
                      timeList[index],
                      style: TextStyle(
                          fontSize: ConstantData.font22Px,
                          fontWeight: FontWeight.w500,
                          fontFamily: ConstantData.fontFamily,
                          color: ConstantData.mainTextColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        if (isPoint) {
                          receivedTime = dateList[index];
                        } else {
                          deliveryTime = dateList[index];
                        }
                      });
                    },
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  void datePickerDialog(bool isPoint) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConstantData.bgColor,
      builder: (builder) {
        return new Container(
          padding: EdgeInsets.only(
            left: 5.0,
            right: 5.0,
            top: 5.0,
            bottom: 5.0,
          ),
          decoration: new BoxDecoration(
            color: ConstantData.bgColor,
          ),
          child: new Wrap(
            children: <Widget>[
              ListView.separated(
                shrinkWrap: true,
                itemCount: timeList.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(height: 5, color: ConstantData.mainTextColor),
                itemBuilder: (context, index) {
                  return new ListTile(
                    title: Text(
                      timeList[index],
                      style: TextStyle(
                          fontSize: ConstantData.font22Px,
                          fontWeight: FontWeight.w500,
                          fontFamily: ConstantData.fontFamily,
                          color: ConstantData.mainTextColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        if (isPoint) {
                          receivedTime = dateList[index];
                        } else {
                          deliveryTime = dateList[index];
                        }
                      });
                    },
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  getCell(bool isPoint, bool isDate) {
    double height = ConstantWidget.getScreenPercentSize(context, 6);
    double icon = ConstantWidget.getPercentSize(height, 40);
    return Container(
      margin: EdgeInsets.only(right: (margin / 3)),
      height: height,
      padding: EdgeInsets.symmetric(horizontal: (margin / 3)),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(ConstantWidget.getPercentSize(height, 20)),
        border: Border.all(
            color: Colors.grey,
            width: ConstantWidget.getWidthPercentSize(context, 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ConstantWidget.getTextWidget(
                getString(isPoint, isDate),
                Colors.grey,
                TextAlign.start,
                FontWeight.w400,
                ConstantData.font18Px),
          ),
          Icon(
            Icons.expand_more,
            color: ConstantData.mainTextColor,
            size: icon,
          )
        ],
      ),
    );
  }

  String getString(bool isPoint, bool isDate) {
    if (isPoint) {
      if (isDate) {
        return receivedDate;
      } else {
        return receivedTime;
      }
    } else {
      if (isDate) {
        return deliveryDate;
      } else {
        return deliveryTime;
      }
    }
  }

  getPhoneCell(TextEditingController textEditingController) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
      decoration: getDecoration(),
      margin: EdgeInsets.symmetric(horizontal: margin),
      alignment: Alignment.centerLeft,
      child: TextField(
        keyboardType: TextInputType.number,
        enabled: true,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
            fontFamily: ConstantData.fontFamily,
            color: ConstantData.mainTextColor),
        controller: textEditingController,
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            suffixIcon: Icon(
              Icons.phone_android,
              color: ConstantData.primaryColor,
            ),
            hintText: "Phone",
            hintStyle: TextStyle(
                fontFamily: ConstantData.fontFamily, color: Colors.grey)),
      ),
    );
  }

  getPackageValueCell(TextEditingController textEditingController) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
      decoration: getDecoration(),
      margin: EdgeInsets.symmetric(horizontal: margin),
      alignment: Alignment.centerLeft,
      child: TextField(
        keyboardType: TextInputType.number,
        enabled: true,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
            fontFamily: ConstantData.fontFamily,
            color: ConstantData.mainTextColor),
        controller: textEditingController,
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            suffixIcon: Icon(
              Icons.money,
              color: ConstantData.primaryColor,
            ),
            hintText: "Package Value",
            hintStyle: TextStyle(
                fontFamily: ConstantData.fontFamily, color: Colors.grey)),
      ),
    );
  }

  getPointCell(String s, String s1) {
    double circle = ConstantWidget.getScreenPercentSize(context, 4.5);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: margin),
      child: Row(
        children: [
          Container(
            height: circle,
            width: circle,
            decoration: BoxDecoration(
                color: ConstantData.primaryColor, shape: BoxShape.circle),
            child: Center(
              child: ConstantWidget.getTextWidget(
                  s,
                  Colors.white,
                  TextAlign.center,
                  FontWeight.w500,
                  ConstantWidget.getPercentSize(circle, 40)),
            ),
          ),
          SizedBox(
            width: margin,
          ),
          ConstantWidget.getTextWidget(
              s1,
              ConstantData.mainTextColor,
              TextAlign.center,
              FontWeight.w500,
              ConstantWidget.getPercentSize(circle, 40)),
        ],
      ),
    );
  }

  getPriceCell(TextEditingController textEditingController) {
    return Container(
        padding:
            EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
        margin: EdgeInsets.symmetric(horizontal: margin),
        // color: ConstantData.cellColor,
        alignment: Alignment.centerLeft,
        decoration: getDecoration(),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          enabled: false,
          maxLines: 2,
          controller: textEditingController,
          style: TextStyle(
              fontFamily: ConstantData.fontFamily,
              color: ConstantData.mainTextColor),
          decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              suffixIcon: Icon(
                Icons.money,
                color: ConstantData.primaryColor,
              ),
              hintText: "Click To select location",
              hintStyle: TextStyle(
                  fontFamily: ConstantData.fontFamily, color: Colors.grey)),
        ));
  }
}
