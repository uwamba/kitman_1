import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'WeightPage.dart';
import 'generated/l10n.dart';
import 'model/NotificationModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPage createState() {
    return _NotificationPage();
  }
}

class _NotificationPage extends State<NotificationPage> {
  List<NotificationModel> orderTypeList = DataFile.getNotificationList();

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int colorPosition = -1;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    double margin = ConstantWidget.getScreenPercentSize(context, 3);
    double height = ConstantWidget.getScreenPercentSize(context, 12);
    double cellHeight = ConstantWidget.getPercentSize(height, 60);

    return WillPopScope(
        child: Scaffold(
            backgroundColor: ConstantData.bgColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: ConstantData.primaryColor,
              title: ConstantWidget.getAppBarText(S.of(context).notification),
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
              margin: EdgeInsets.symmetric(vertical: margin),
              child: ListView.builder(
                itemCount: orderTypeList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (colorPosition == (ConstantData.colorList().length - 1)) {
                    colorPosition = 0;
                  } else {
                    colorPosition++;
                  }

                  // var color = ConstantData.primaryColor;
                  var color = ConstantData.colorList()[colorPosition];

                  return InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: (margin / 1.5), right: margin, left: margin),
                      padding: EdgeInsets.symmetric(
                          horizontal: (margin / 2), vertical: (margin / 1.5)),
                      decoration: BoxDecoration(
                        color: ConstantData.bgColor,
                        borderRadius: BorderRadius.circular(
                            ConstantWidget.getScreenPercentSize(context, 1.5)),
                        border: Border.all(
                            color: Colors.grey,
                            width: ConstantWidget.getWidthPercentSize(
                                context, 0.08)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: cellHeight,
                            width: cellHeight,
                            margin: EdgeInsets.only(right: (margin / 2)),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: color),
                            padding: EdgeInsets.all(
                                ConstantWidget.getPercentSize(cellHeight, 20)),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: ConstantWidget.getCustomText(
                                          orderTypeList[index].title,
                                          ConstantData.mainTextColor,
                                          1,
                                          TextAlign.start,
                                          FontWeight.w600,
                                          ConstantWidget.getPercentSize(
                                              height, 20))),
                                  // Expanded(child: ConstantWidget.getTextWidget(
                                  //     orderTypeList[index].title,
                                  //     ConstantData.mainTextColor,
                                  //     TextAlign.start,
                                  //     FontWeight.w600,
                                  //     ConstantWidget.getPercentSize(
                                  //         height, 20)),),
                                  // new Spacer(),
                                  ConstantWidget.getTextWidget(
                                      orderTypeList[index].time,
                                      Colors.grey,
                                      TextAlign.end,
                                      FontWeight.w300,
                                      ConstantWidget.getPercentSize(
                                          height, 12)),
                                ],
                              ),
                              SizedBox(
                                height: (margin / 3),
                              ),
                              ConstantWidget.getCustomText(
                                  orderTypeList[index].desc,
                                  ConstantData.mainTextColor,
                                  3,
                                  TextAlign.start,
                                  FontWeight.w400,
                                  ConstantWidget.getPercentSize(height, 15)),
                            ],
                          ))
                          // ConstantWidget.getTextWidget(
                          //     orderTypeList[index].title,
                          //     ConstantData.mainTextColor,
                          //     TextAlign.center,
                          //     FontWeight.w600,
                          //     ConstantWidget.getPercentSize(height, 20)),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WeightPage(orderTypeList[index].title),
                          ));
                    },
                  );
                },
              ),
            )),
        onWillPop: _requestPop);
  }
}
// we will assign delivery boy
