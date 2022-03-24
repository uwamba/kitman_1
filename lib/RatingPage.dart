import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'generated/l10n.dart';
import 'model/AddressModel.dart';
import 'model/PaymentSelectModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPage createState() {
    return _RatingPage();
  }
}

class _RatingPage extends State<RatingPage> {
  bool isNotify = false;
  List<AddressModel> addressList = DataFile.getAddressList();

  TextEditingController parcelController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  String pointTime, pointDate;
  String deliveryTime, deliveryDate;

  List<PaymentSelectModel> list = DataFile.getPaymentSelect();

  bool isCash = true;

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
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
  double radius;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    margin = ConstantWidget.getScreenPercentSize(context, 2);
    radius = ConstantWidget.getScreenPercentSize(context, 1.5);

    var spaceWidget = new SizedBox(
      height: margin,
    );
    double height = ConstantWidget.getScreenPercentSize(context, 7);

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
            margin: EdgeInsets.symmetric(horizontal: margin),
            height: double.infinity,
            child: ListView(
              children: [
                spaceWidget,
                Row(
                  children: [
                    Container(
                      height: height,
                      width: height,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                              ConstantWidget.getPercentSize(height, 10))),
                          image: DecorationImage(
                              image: AssetImage(
                                  ConstantData.assetsPath + "hugh.png"),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      width: (margin / 2),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstantWidget.getTextWidget(
                            "John Smith",
                            ConstantData.mainTextColor,
                            TextAlign.start,
                            FontWeight.w500,
                            ConstantData.font15Px),
                        SizedBox(
                          height: (ConstantData.font12Px / 2),
                        ),
                        ConstantWidget.getTextWidget(
                            "+91 9876543210",
                            ConstantData.mainTextColor,
                            TextAlign.start,
                            FontWeight.w500,
                            ConstantData.font15Px),
                      ],
                    )
                  ],
                ),
                spaceWidget,
                Divider(
                  height: ConstantWidget.getScreenPercentSize(context, 0.02),
                  color: Colors.grey,
                ),
                spaceWidget,
                ConstantWidget.getTextWidget(
                    S.of(context).rateDeliveryBoy,
                    Colors.grey,
                    TextAlign.start,
                    FontWeight.w500,
                    ConstantData.font15Px),
                spaceWidget,
                Center(
                  child: RatingBar.builder(
                    itemSize: ConstantWidget.getWidthPercentSize(context, 10),
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    tapOnlyMode: true,
                    updateOnDrag: true,
                    unratedColor: Colors.grey,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: ConstantWidget.getWidthPercentSize(context, 10),
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
                spaceWidget,
                Container(
                  padding: EdgeInsets.all(margin),
                  decoration: new BoxDecoration(
                      color: ConstantData.cellColor,
                      boxShadow: [
                        BoxShadow(
                          color: ConstantData.shadowColor,
                        )
                      ],
                      borderRadius:
                          BorderRadius.all(Radius.circular((margin / 1.5)))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: margin),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ConstantWidget.getCustomText(
                                S.of(context).writeReview,
                                ConstantData.textColor,
                                1,
                                TextAlign.start,
                                FontWeight.bold,
                                ConstantData.font12Px),
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: margin),
                        child: TextField(
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: ConstantData.fontFamily,
                              color: ConstantData.mainTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: ConstantData.font15Px),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 3, left: (margin / 2)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ConstantData.textColor),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      ConstantWidget.getCustomText(
                          S.of(context).minimumCharacter,
                          ConstantData.textColor,
                          1,
                          TextAlign.start,
                          FontWeight.w500,
                          ConstantData.font15Px)
                    ],
                  ),
                ),
                spaceWidget,
                ConstantWidget.getBottomText(context, S.of(context).submit, () {
                  Navigator.pop(context);
                })
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }
}
