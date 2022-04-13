import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knitman/model/orderList.dart';
import 'package:knitman/place_picker_custom/place_picker.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ChatScreen.dart';
import 'generated/l10n.dart';
import 'model/Message.dart';
import 'model/TimeLineModel.dart';
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

  List<TimeLineModel> timeLineModel = [];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double bottomHeight = SizeConfig.safeBlockVertical * 20;

    double bottomImageHeight = ConstantWidget.getPercentSize(bottomHeight, 50);

    timeLineModel.clear();
    TimeLineModel model = new TimeLineModel();
    model.text = widget.activeOrderModel.pickingLocation;
    model.contact = widget.activeOrderModel.pointLocation;
    model.isComplete = true;
    timeLineModel.add(model);

    model.text = widget.activeOrderModel.pickingLocation;
    model.contact = widget.activeOrderModel.pointLocation;
    model.isComplete = true;
    timeLineModel.add(model);

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
            child: ListView(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.green,
                  padding: EdgeInsets.all(margin),
                  child: ConstantWidget.getTextWidget(
                      "Complete Order",
                      Colors.white,
                      TextAlign.start,
                      FontWeight.w500,
                      ConstantData.font18Px),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: margin),
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
                                widget.activeOrderModel.receiverAddress,
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
                            ConstantWidget.getScreenPercentSize(context, 2)),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstantWidget.getCustomText(
                                      "James King",
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
                                          widget.activeOrderModel.senderId,
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
                            IconButton(
                                icon: Icon(
                                  CupertinoIcons.chat_bubble_text_fill,
                                  color: ConstantData.accentColor,
                                  size: ConstantWidget.getPercentSize(
                                      bottomHeight, 20),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ChatScreen(user: chats[0].sender),
                                  ));
                                }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: (margin),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: margin),
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

                            // ConstantWidget.getTextWidget(
                            //     "Created",
                            //     Colors.grey,
                            //     TextAlign.start,
                            //     FontWeight.w400,
                            //     ConstantData.font22Px),
                            // SizedBox(
                            //   height: (margin / 3),
                            // ),
                            // ConstantWidget.getTextWidget(
                            //     "257.05.2021 17:15",
                            //     ConstantData.mainTextColor,
                            //     TextAlign.start,
                            //     FontWeight.w400,
                            //     ConstantData.font22Px),
                            //
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
                              "Cash",
                            ),
                            SizedBox(
                              height: ((margin * 1.2)),
                            ),

                            // ConstantWidget.getTextWidget(
                            //     "Weight",
                            //     Colors.grey,
                            //     TextAlign.start,
                            //     FontWeight.w400,
                            //     ConstantData.font22Px),
                            // SizedBox(
                            //   height: (margin / 3),
                            // ),
                            // ConstantWidget.getTextWidget(
                            //     "Up to 1 kg",
                            //     ConstantData.mainTextColor,
                            //     TextAlign.start,
                            //     FontWeight.w400,
                            //     ConstantData.font22Px),
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
                        child: _DeliveryProcesses(processes: timeLineModel),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  getPoints() {
    return [
      LatLng(40.65790014590701, -73.77194564694435),
      // LatLng(21.214571209464843, 72.88491829958917),
      LatLng(40.65214565261112, -73.8060743777546),
      // LatLng(21.21103054325307, 72.89371594512971),
    ];
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

  void _callNumber() async {
    String s = "89898989";

    String url = "tel:" + s;
    await launch(url);
  }
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({Key key, @required this.processes})
      : assert(processes != null),
        super(key: key);

  final List<TimeLineModel> processes;

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
                      processes[index].text,
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
                                "Contact person",
                                Colors.grey,
                                TextAlign.start,
                                FontWeight.w400,
                                ConstantData.font18Px),
                            SizedBox(
                              height: (margin / 4),
                            ),
                            ConstantWidget.getTextWidget(
                                processes[index].contact,
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
                    SizedBox(
                      height: ConstantWidget.getScreenPercentSize(context, 3),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstantWidget.getTextWidget(
                            "Comments",
                            Colors.grey,
                            TextAlign.start,
                            FontWeight.w400,
                            ConstantData.font18Px),
                        SizedBox(
                          height: (margin / 4),
                        ),
                        ConstantWidget.getTextWidget(
                            processes[index].text,
                            ConstantData.mainTextColor,
                            TextAlign.start,
                            FontWeight.w400,
                            ConstantData.font18Px),
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
