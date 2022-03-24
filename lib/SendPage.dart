import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'LocationPage.dart';
import 'generated/l10n.dart';
import 'model/SendModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';

class SendPage extends StatefulWidget {
  SendPage();

  @override
  _SendPage createState() {
    return _SendPage();
  }
}

class _SendPage extends State<SendPage> {
  List<SendModel> orderTypeList = DataFile.getSendModelList();

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  int colorPostion = -1;

  @override
  Widget build(BuildContext context) {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);

    var _crossAxisSpacing = 1;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;

    double width =
        ConstantWidget.getWidthPercentSize(context, 100) - ((margin * 1.5) * 2);
    var cellHeight = width / 2;
    // var cellHeight = ConstantWidget.getScreenPercentSize(context, 22);

    var _aspectRatio = _width / cellHeight;

    double imageSize = ConstantWidget.getPercentSize(cellHeight, 25);
    double radius = ConstantWidget.getPercentSize(cellHeight, 8);
    double circle = ConstantWidget.getPercentSize(cellHeight, 40);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.primaryColor,
            title:
                ConstantWidget.getAppBarText(S.of(context).whatAreYouSending),
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
            padding: EdgeInsets.symmetric(horizontal: margin),
            margin: EdgeInsets.symmetric(vertical: margin),
            child: GridView.count(
              crossAxisCount: _crossAxisCount,
              shrinkWrap: true,
              childAspectRatio: _aspectRatio,
              mainAxisSpacing: ((margin * 1.5)),
              crossAxisSpacing: (margin * 1.5),
              // childAspectRatio: 0.64,
              primary: false,
              children: List.generate(orderTypeList.length, (index) {
                if (colorPostion == (ConstantData.colorList().length - 1)) {
                  colorPostion = 0;
                } else {
                  colorPostion++;
                }

                var color = ConstantData.colorList()[colorPostion];

                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        color: ConstantData.cellColor,
                        borderRadius: BorderRadius.circular(radius),
                        boxShadow: [
                          BoxShadow(
                              color: ConstantData.shadowColor.withOpacity(0.2),
                              blurRadius: 2,
                              offset: Offset(0, 2),
                              spreadRadius: 1)
                        ]),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConstantWidget.getTextWidget(
                                orderTypeList[index].title,
                                ConstantData.mainTextColor,
                                TextAlign.center,
                                FontWeight.bold,
                                ConstantWidget.getPercentSize(cellHeight, 10)),
                            SizedBox(
                              height: margin,
                            ),
                            Center(
                              child: Container(
                                height: circle,
                                width: circle,
                                padding: EdgeInsets.all(
                                    ConstantWidget.getPercentSize(circle, 30)),
                                decoration: BoxDecoration(
                                    color: ConstantData.bgColor,
                                    shape: BoxShape.circle),
                                child: Image.asset(
                                    ConstantData.assetsPath +
                                        orderTypeList[index].image,
                                    color: color),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: (imageSize),
                            width: (imageSize),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(radius),
                                  bottomRight: Radius.circular(radius)),
                            ),
                            child: Center(
                              child: Transform.scale(
                                scale: -1,
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back_sharp,
                                    color: Colors.white,
                                    size: ConstantWidget.getPercentSize(
                                        imageSize, 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationPage(),
                        ));
                  },
                );
              }),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }
}
