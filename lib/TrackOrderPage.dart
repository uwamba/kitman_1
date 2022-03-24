import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TrackOrderDetail.dart';
import 'generated/l10n.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/SizeConfig.dart';

class TrackOrderPage extends StatefulWidget {
  @override
  _TrackOrderPage createState() {
    return _TrackOrderPage();
  }
}

class _TrackOrderPage extends State<TrackOrderPage> {
  TextEditingController textController = new TextEditingController();

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
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
                spaceWidget,
                getCell(textController),
                spaceWidget,
                ConstantWidget.getBottomText(context, S.of(context).track, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => PackageDeliveryTrackingPage(),
                        builder: (context) => TrackOrderDetail(),
                      ));
                }),
                spaceWidget,
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

  getCell(TextEditingController textEditingController) {
    return InkWell(
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
        margin: EdgeInsets.symmetric(horizontal: margin),
        // color: ConstantData.cellColor,

        decoration: getDecoration(),
        child: TextField(
          enabled: true,
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
              hintText: S.of(context).enterOrderNumber,
              hintStyle: TextStyle(
                  fontFamily: ConstantData.fontFamily, color: Colors.grey)),
        ),
      ),
    );
  }
}
