import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SubmitOrderDetail.dart';
import 'TabWidget.dart';
import 'generated/l10n.dart';
import 'model/AddressModel.dart';
import 'model/PaymentSelectModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class SubmitOrderPage extends StatefulWidget {
  @override
  _SubmitOrderPage createState() {
    return _SubmitOrderPage();
  }
}

class _SubmitOrderPage extends State<SubmitOrderPage> {
  bool isNotify = false;
  List<AddressModel> addressList = DataFile.getAddressList();

  TextEditingController parcelController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  String pointTime, pointDate;
  String deliveryTime, deliveryDate;

  List<PaymentSelectModel> list = DataFile.getPaymentSelect();

  bool isCash = true;

  Future<bool> _requestPop() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabWidget(false),
        ));
    return new Future.value(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      pointDate = "Today";
      pointTime = "13:00-14:00";
      deliveryDate = "Today";
      deliveryTime = "13:00-14:00";
    });
  }

  double margin;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    margin = ConstantWidget.getScreenPercentSize(context, 2);
    double bottomHeight = ConstantWidget.getScreenPercentSize(context, 7);
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
            title: ConstantWidget.getAppBarText(S.of(context).submitOrder),
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
            child: Column(
              children: [
                Expanded(
                    child: ListView(
                  children: [
                    spaceWidget,
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: margin),
                        child: Icon(CupertinoIcons.timer_fill,
                            color: ConstantData.primaryColor,
                            size: ConstantWidget.getScreenPercentSize(
                              context,
                              5,
                            )),
                      ),
                    ),
                    spaceWidget,
                    Padding(
                      padding: EdgeInsets.only(left: margin),
                      child: ConstantWidget.getTextWidget(
                          "We will assign the nearest courier boy to pick up and deliver as soon as possible.",
                          Colors.grey,
                          TextAlign.start,
                          FontWeight.w500,
                          ConstantData.font18Px),
                    ),
                    spaceWidget,
                    Padding(
                      padding: EdgeInsets.only(left: margin),
                      child: ConstantWidget.getTextWidget(
                          "What's in it:Document",
                          ConstantData.mainTextColor,
                          TextAlign.start,
                          FontWeight.w500,
                          ConstantData.font18Px),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: margin),
                      child: ConstantWidget.getTextWidget(
                          "Up to 5kg,book a courier",
                          Colors.grey,
                          TextAlign.start,
                          FontWeight.w500,
                          ConstantData.font15Px),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: margin, top: margin),
                      child: Row(
                        children: [
                          ConstantWidget.getTextWidget(
                              "Stated Value:",
                              Colors.grey,
                              TextAlign.start,
                              FontWeight.w500,
                              ConstantData.font18Px),
                          SizedBox(
                            width: margin,
                          ),
                          ConstantWidget.getTextWidget(
                              "₹452",
                              ConstantData.mainTextColor,
                              TextAlign.start,
                              FontWeight.w500,
                              ConstantData.font18Px),
                        ],
                      ),
                    ),
                    spaceWidget,
                    getCell("Point Address"),
                    spaceWidget,
                    getCell("Delivery Address"),
                  ],
                )),
                InkWell(
                  child: Container(
                    height: bottomHeight,
                    padding: EdgeInsets.symmetric(
                        vertical:
                            ConstantWidget.getPercentSize(bottomHeight, 10),
                        horizontal:
                            ConstantWidget.getPercentSize(bottomHeight, 20)),
                    color: ConstantData.primaryColor,
                    child: Row(
                      children: [
                        ConstantWidget.getTextWidget(
                            "₹40",
                            Colors.white,
                            TextAlign.start,
                            FontWeight.w700,
                            ConstantWidget.getPercentSize(bottomHeight, 35)),
                        new Spacer(),
                        ConstantWidget.getTextWidget(
                            S.of(context).done,
                            Colors.white,
                            TextAlign.start,
                            FontWeight.w700,
                            ConstantWidget.getPercentSize(bottomHeight, 35))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubmitOrderDetail(
                              DataFile.getActiveOrderList()[0]),
                        ));
                  },
                )
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  getCell(String s) {
    double height = ConstantWidget.getScreenPercentSize(context, 7.5);
    double width = ConstantWidget.getWidthPercentSize(context, 43);
    return Container(
      margin: EdgeInsets.all(margin),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: (height / 2)),
            padding: EdgeInsets.only(
                top: (height / 1.3),
                bottom: (margin),
                left: (margin),
                right: (margin)),
            decoration: BoxDecoration(
                color: ConstantData.cellColor,
                boxShadow: [
                  BoxShadow(
                      color: ConstantData.shadowColor.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 5),
                      spreadRadius: 1)
                ],
                borderRadius: BorderRadius.all(Radius.circular(
                    ConstantWidget.getScreenPercentSize(context, 2)))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstantWidget.getTextWidget(
                    "1,Link Rd,Bhagat Sign Nagar 1,Colony No 1,Bhagat Singh ,Goregaon west,Mumbai,Maharashtra 400104,India",
                    ConstantData.textColor,
                    TextAlign.start,
                    FontWeight.w300,
                    ConstantData.font18Px),
                SizedBox(
                  height: (margin / 2),
                ),
                ConstantWidget.getTextWidget(
                    "Today till 12:21",
                    ConstantData.textColor,
                    TextAlign.start,
                    FontWeight.w300,
                    ConstantData.font18Px),
                SizedBox(
                  height: (margin / 2),
                ),
                ConstantWidget.getTextWidget(
                    "+91 111 222 3324",
                    ConstantData.textColor,
                    TextAlign.start,
                    FontWeight.w300,
                    ConstantData.font18Px),
              ],
            ),
          ),
          Wrap(
            children: [
              Container(
                width: ConstantWidget.getWidthPercentSize(context, 43),
                height: height,
                padding: EdgeInsets.all(margin / 2),
                margin: EdgeInsets.only(left: margin),
                decoration: BoxDecoration(
                    color: ConstantData.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(
                        ConstantWidget.getScreenPercentSize(context, 2.5)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: ConstantWidget.getPercentSize(width, 10),
                    ),
                    SizedBox(
                      width: (margin / 2),
                    ),
                    ConstantWidget.getTextWidget(
                        s,
                        Colors.white,
                        TextAlign.start,
                        FontWeight.bold,
                        ConstantWidget.getPercentSize(width, 8))
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
