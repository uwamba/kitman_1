import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'generated/l10n.dart';
import 'model/ActiveOrderModel.dart';
import 'place_picker_custom/entities/location_result.dart';
import 'place_picker_custom/widgets/place_picker.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class EditPage extends StatefulWidget {
  final ActiveOrderModel activeOrderModel;

  EditPage(this.activeOrderModel);

  @override
  _EditPage createState() {
    return _EditPage();
  }
}

class _EditPage extends State<EditPage> {
  List<String> timeList = DataFile.getTimeList();
  List<String> dateList = DataFile.getDateList();

  TextEditingController pointAddressController = new TextEditingController();
  TextEditingController pointPhoneController = new TextEditingController();
  TextEditingController pointCommentController = new TextEditingController();
  TextEditingController deliveryAddressController = new TextEditingController();
  TextEditingController deliveryPhoneController = new TextEditingController();
  TextEditingController deliveryCommentController = new TextEditingController();
  String pointTime, pointDate;
  String deliveryTime, deliveryDate;

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pointAddressController.text =
        "Mubarak masjid ,Patakar compound,Glibert Hill Rd,Munshi Nagar,Andheri west.";
    deliveryAddressController.text =
        "VRL,Bus Terminal Seshadri Rd,Gandhi Nagar,Bengluru,Karnataka 560009,India.";
    pointPhoneController.text = "+91 9845632173";
    deliveryPhoneController.text = "+91 9845632173";
    pointCommentController.text = "klfjklgj";
    deliveryCommentController.text = "klfjklgj";

    setState(() {
      pointDate = "Today";
      pointTime = "13:00-14:00";
      deliveryDate = "Today";
      deliveryTime = "13:00-14:00";
    });
  }

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
            title: ConstantWidget.getAppBarText(S.of(context).editOrder),
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
                getAddressCell(pointAddressController),
                spaceWidget,
                getPhoneCell(pointPhoneController),
                spaceWidget,
                getTimeAndDateCell(true),
                spaceWidget,
                getCommentCell(pointCommentController),
                spaceWidget,
                getPointCell("2", "Delivery Point"),
                spaceWidget,
                getAddressCell(deliveryAddressController),
                spaceWidget,
                getPhoneCell(deliveryPhoneController),
                spaceWidget,
                getTimeAndDateCell(false),
                spaceWidget,
                getCommentCell(deliveryCommentController),
                spaceWidget,
                ConstantWidget.getBottomText(context, S.of(context).save, () {
                  Navigator.pop(context);
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
              hintText: "Address",
              hintStyle: TextStyle(
                  fontFamily: ConstantData.fontFamily, color: Colors.grey)),
        ),
      ),
      onTap: () {
        showPlacePicker();
      },
    );
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyAZ6df2DrqkaZLPYjUMX4D_4iMCqeFMsZ0")));

    // Handle the result in your way
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
            hintText: S.of(context).comment,
            hintStyle: TextStyle(
                fontFamily: ConstantData.fontFamily, color: Colors.grey)),
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
                          pointDate = dateList[index];
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
                          pointTime = dateList[index];
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
        return pointDate;
      } else {
        return pointTime;
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
}
