import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NewOrderPage.dart';
import 'generated/l10n.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/SizeConfig.dart';

class SchedulePage extends StatefulWidget {
  final bool isBack;

  SchedulePage(this.isBack);

  @override
  _SchedulePage createState() {
    return _SchedulePage();
  }
}

class _SchedulePage extends State<SchedulePage> {
  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double margin;
  double radius;
  int selectedPosition = 0;

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
            title: ConstantWidget.getAppBarText(S.of(context).newOrder),
            leading: (widget.isBack)
                ? Container()
                : Builder(
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
            height: double.infinity,
            child: Column(
              children: [
                spaceWidget,
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      getCell(0, CupertinoIcons.timer_fill,
                          S.of(context).deliverNow, "from RWF40"),
                      getCell(1, CupertinoIcons.calendar_today,
                          S.of(context).schedule, "from RWF40"),
                      getCell(2, CupertinoIcons.calendar_today,
                          "4-hour interval", "from RWF40"),
                    ],
                  ),
                ),
                ConstantWidget.getBottomText(
                    context, S.of(context).continueText, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewOrderPage(),
                      ));
                }),
                spaceWidget,
                spaceWidget,
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  getDecoration(var color, var shadowColor) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
              color: shadowColor.withOpacity(0.2),
              blurRadius: 2,
              offset: Offset(0, 2),
              spreadRadius: 1)
        ]);
  }

  getCell(int position, var icon, String s, String s1) {
    bool isSelect = (position == selectedPosition);
    var textColor = (isSelect) ? Colors.white : ConstantData.mainTextColor;
    double width = ConstantWidget.getWidthPercentSize(context, 35);
    return Wrap(
      children: [
        InkWell(
          child: Container(
            width: width,
            margin: EdgeInsets.symmetric(horizontal: (margin / 2)),
            padding: EdgeInsets.all(margin),
            decoration: getDecoration(
              (isSelect) ? ConstantData.primaryColor : ConstantData.cellColor,
              (isSelect) ? ConstantData.primaryColor : ConstantData.shadowColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: ConstantWidget.getScreenPercentSize(context, 3),
                  color: (isSelect) ? Colors.white : ConstantData.mainTextColor,
                ),
                SizedBox(
                  height: (margin / 3),
                ),
                ConstantWidget.getTextWidget(s, textColor, TextAlign.start,
                    FontWeight.w500, ConstantData.font15Px),
                SizedBox(
                  height: (margin / 1.2),
                ),
                Row(
                  children: [
                    ConstantWidget.getTextWidget(
                        s1,
                        textColor,
                        TextAlign.start,
                        FontWeight.w700,
                        ConstantWidget.getPercentSize(width, 10)),
                    // Visibility(
                    //   child: ConstantWidget.getTextWidget("Per address", textColor,
                    //       TextAlign.start, FontWeight.w500, ConstantData.font12Px),
                    //   visible: (position == 2),
                    // )
                  ],
                )
              ],
            ),
          ),
          onTap: () {
            setState(() {
              if (selectedPosition == position) {
                if (position == 0) {
                  bottomDeliverDialog();
                } else {
                  bottomScheduleDialog();
                }
              } else {
                selectedPosition = position;
              }
            });
          },
        )
      ],
    );
  }

  void bottomDeliverDialog() {
    var widget = SizedBox(
      height: (margin * 1.2),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Wrap(
        children: [
          Container(
            padding:
                EdgeInsets.all(ConstantWidget.getScreenPercentSize(context, 2)),
            // height: MediaQuery.of(context).size.height * 0.85,
            decoration: new BoxDecoration(
              color: ConstantData.cellColor,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(
                    ConstantWidget.getScreenPercentSize(context, 5)),
                topRight: Radius.circular(
                    ConstantWidget.getScreenPercentSize(context, 5)),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    new Spacer(),
                    InkWell(
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: ConstantWidget.getScreenPercentSize(context, 3),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    CupertinoIcons.timer_fill,
                    size: ConstantWidget.getScreenPercentSize(context, 6),
                    color: ConstantData.primaryColor,
                  ),
                ),
                widget,
                ConstantWidget.getTextWidget(
                    S.of(context).deliverNow,
                    ConstantData.mainTextColor,
                    TextAlign.start,
                    FontWeight.w700,
                    ConstantWidget.getScreenPercentSize(context, 3)),
                widget,
                ConstantWidget.getCustomText(
                    "We will assign the nearest courier to pick-up and deliver as soon as possible.",
                    Colors.grey,
                    2,
                    TextAlign.start,
                    FontWeight.w500,
                    ConstantData.font18Px),
                widget,
                ConstantWidget.getTextWidget(
                    "from ₹40",
                    ConstantData.mainTextColor,
                    TextAlign.start,
                    FontWeight.w400,
                    ConstantWidget.getScreenPercentSize(context, 3)),
                widget,
                Divider(
                  height: ConstantWidget.getScreenPercentSize(context, 0.02),
                ),
                widget,
                Row(
                  children: [
                    getCircleCell(
                        ConstantData.accentColor, Icons.directions_run),
                    SizedBox(
                      width: (margin / 3),
                    ),
                    getCircleCell(
                        ConstantData.accentColor, Icons.motorcycle_outlined),
                  ],
                ),
                SizedBox(
                  height: (margin / 2),
                ),
                ConstantWidget.getCustomText(
                    "Delivery be 2-wheelers or public transport.",
                    ConstantData.textColor,
                    2,
                    TextAlign.start,
                    FontWeight.w500,
                    ConstantData.font18Px),
                SizedBox(
                  height: (margin / 2),
                ),
                Divider(
                  height: ConstantWidget.getScreenPercentSize(context, 0.02),
                ),
                widget,
                widget,
                Row(
                  children: [getWeightCell()],
                ),
                SizedBox(
                  height: (margin / 2),
                ),
                ConstantWidget.getCustomText(
                    "Up to 20 kg",
                    ConstantData.textColor,
                    2,
                    TextAlign.start,
                    FontWeight.w500,
                    ConstantData.font18Px),
                SizedBox(
                  height: (margin / 2),
                ),
                Divider(
                  height: ConstantWidget.getScreenPercentSize(context, 0.02),
                ),
                widget,
                widget,
                Row(
                  children: [
                    getCircleCell(Colors.grey, Icons.privacy_tip),
                  ],
                ),
                SizedBox(
                  height: (margin / 2),
                ),
                ConstantWidget.getCustomText(
                    "You can choose insurance amount.",
                    ConstantData.textColor,
                    2,
                    TextAlign.start,
                    FontWeight.w500,
                    ConstantData.font18Px),
                SizedBox(
                  height: (margin / 2),
                ),
                Divider(
                  height: ConstantWidget.getScreenPercentSize(context, 0.02),
                ),
                widget,
                widget,
                widget,
                widget,
                ConstantWidget.getBottomText(context, "Confirm", () {
                  Navigator.pop(context);
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  void bottomScheduleDialog() {
    var widget = SizedBox(
      height: (margin * 1.2),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Wrap(
        children: [
          Container(
            padding:
                EdgeInsets.all(ConstantWidget.getScreenPercentSize(context, 2)),
            // height: MediaQuery.of(context).size.height * 0.85,
            decoration: new BoxDecoration(
              color: ConstantData.cellColor,
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(
                    ConstantWidget.getScreenPercentSize(context, 5)),
                topRight: Radius.circular(
                    ConstantWidget.getScreenPercentSize(context, 5)),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    new Spacer(),
                    InkWell(
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: ConstantWidget.getScreenPercentSize(context, 3),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    CupertinoIcons.calendar_today,
                    size: ConstantWidget.getScreenPercentSize(context, 6),
                    color: ConstantData.primaryColor,
                  ),
                ),
                widget,
                ConstantWidget.getTextWidget(
                    S.of(context).schedule,
                    ConstantData.mainTextColor,
                    TextAlign.start,
                    FontWeight.w700,
                    ConstantWidget.getScreenPercentSize(context, 3)),
                widget,
                ConstantWidget.getCustomText(
                    S.of(context).weWillArriveAtEachAddressAtSpecifiedTimes,
                    Colors.grey,
                    2,
                    TextAlign.start,
                    FontWeight.w500,
                    ConstantData.font18Px),
                widget,
                ConstantWidget.getTextWidget(
                    "from ₹40",
                    ConstantData.mainTextColor,
                    TextAlign.start,
                    FontWeight.w400,
                    ConstantWidget.getScreenPercentSize(context, 3)),
                widget,
                Divider(
                  height: ConstantWidget.getScreenPercentSize(context, 0.02),
                ),
                widget,
                Row(
                  children: [
                    getCircleCell(
                        ConstantData.accentColor, Icons.directions_run),
                    SizedBox(
                      width: (margin / 3),
                    ),
                    getCircleCell(
                        ConstantData.accentColor, Icons.motorcycle_outlined),
                  ],
                ),
                SizedBox(
                  height: (margin / 2),
                ),
                ConstantWidget.getCustomText(
                    "Delivery be 2-wheelers or public transport.",
                    ConstantData.textColor,
                    2,
                    TextAlign.start,
                    FontWeight.w500,
                    ConstantData.font18Px),
                SizedBox(
                  height: (margin / 2),
                ),
                Divider(
                  height: ConstantWidget.getScreenPercentSize(context, 0.02),
                ),
                widget,
                widget,
                Row(
                  children: [getWeightCell()],
                ),
                SizedBox(
                  height: (margin / 2),
                ),
                ConstantWidget.getCustomText(
                    "Up to 20 kg",
                    ConstantData.textColor,
                    2,
                    TextAlign.start,
                    FontWeight.w500,
                    ConstantData.font18Px),
                SizedBox(
                  height: (margin / 2),
                ),
                Divider(
                  height: ConstantWidget.getScreenPercentSize(context, 0.02),
                ),
                widget,
                widget,
                Row(
                  children: [
                    getCircleCell(Colors.grey, Icons.privacy_tip),
                  ],
                ),
                SizedBox(
                  height: (margin / 2),
                ),
                ConstantWidget.getCustomText(
                    "You can choose insurance amount.",
                    ConstantData.textColor,
                    2,
                    TextAlign.start,
                    FontWeight.w500,
                    ConstantData.font18Px),
                SizedBox(
                  height: (margin / 2),
                ),
                Divider(
                  height: ConstantWidget.getScreenPercentSize(context, 0.02),
                ),
                widget,
                widget,
                widget,
                widget,
                ConstantWidget.getBottomText(context, "Confirm", () {
                  Navigator.pop(context);
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  getWeightCell() {
    double size = ConstantWidget.getScreenPercentSize(context, 4);
    return Container(
      height: size,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.all(
              Radius.circular(ConstantWidget.getPercentSize(size, 50)))),
      child: Row(
        children: [
          // Icon(
          //   Icons.,
          //   size: ConstantWidget.getPercentSize(size, 60),
          //   color: Colors.grey,
          // ),
          Image.asset(
            ConstantData.assetsPath + "weight_icon.png",
            height: ConstantWidget.getPercentSize(size, 60),
            color: Colors.grey,
          ),
          SizedBox(
            width: (margin / 3),
          ),
          Image.asset(
            ConstantData.assetsPath + "weight_icon.png",
            height: ConstantWidget.getPercentSize(size, 60),
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  getCircleCell(var color, var icon) {
    double size = ConstantWidget.getScreenPercentSize(context, 4);
    return Container(
      height: size,
      width: size,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.2)),
      child: Center(
        child: Icon(
          icon,
          size: ConstantWidget.getPercentSize(size, 60),
          color: color,
        ),
      ),
    );
  }
}
