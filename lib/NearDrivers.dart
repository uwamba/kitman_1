import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:knitman/Database/Db.dart';
import 'package:knitman/model/onlineUser.dart';

import 'generated/l10n.dart';
import 'model/NotificationModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class NearDrivers extends StatefulWidget {
  @override
  _NearDrivers createState() {
    return _NearDrivers();
  }
}

class _NearDrivers extends State<NearDrivers> {
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
              title: ConstantWidget.getAppBarText(S.of(context).nearDriver),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: ConstantWidget.getAppBarIcon(),
                    onPressed: _requestPop,
                  );
                },
              ),
            ),
            body: getChatPage()),
        onWillPop: _requestPop);
  }

  getChatPage() {
    double leftMargin = MediaQuery.of(context).size.width * 0.04;
    double height = ConstantWidget.getScreenPercentSize(context, 15);
    double imageSize = ConstantWidget.getPercentSize(height, 60);
    final usersQuery = FirebaseDatabase.instance.ref('presence');
    Db db = new Db();
    return Container(
      color: ConstantData.bgColor,
      padding: EdgeInsets.only(
        top: (leftMargin),
        bottom: MediaQuery.of(context).size.width * 0.01,
      ),
      // margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.01),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: leftMargin, bottom: leftMargin),
              child: ConstantWidget.getTextWidget(
                  S.of(context).drivers,
                  ConstantData.mainTextColor,
                  TextAlign.start,
                  FontWeight.w800,
                  ConstantWidget.getScreenPercentSize(context, 2.5)),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                shrinkWrap: true,
                query: usersQuery,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  List<onlineUser> ls;
                  final parsed =
                      snapshot.children.map((doc) => doc.value).toList();

                  List lis = parsed.toList();

                  return chatCellUser(lis, index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chatCellUser(List users, int index) {
    double allMargin = ConstantWidget.getScreenPercentSize(context, 1);
    double height = ConstantWidget.getScreenPercentSize(context, 13);

    double imageSize = ConstantWidget.getPercentSize(height, 60);
    return InkWell(
        child: Container(
          height: height,
          color: ConstantData.cellColor,
          margin: EdgeInsets.symmetric(
              horizontal: (allMargin / 1.6), vertical: (allMargin / 3.5)),
          padding: EdgeInsets.symmetric(
              horizontal: allMargin, vertical: ((allMargin))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: (allMargin * 3)),
                    height: imageSize,
                    width: imageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: ExactAssetImage(
                            ConstantData.assetsPath + "motorcycleicon.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Visibility(
                    child: Positioned.fill(
                        child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: (allMargin * 2), right: (allMargin / 3)),
                        child: Container(
                          height: ConstantWidget.getPercentSize(height, 18),
                          width: ConstantWidget.getPercentSize(height, 18),
                          padding: EdgeInsets.all((allMargin / 2)),
                          decoration: BoxDecoration(
                              color: ConstantData.cellColor,
                              shape: BoxShape.circle),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: (true) ? Colors.green : Colors.red,
                                shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    )),
                    visible: (users[7]),
                  )
                ],
              ),
              SizedBox(
                width: (allMargin * 3),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ConstantWidget.getCustomText(
                                users[0].toString(),
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.start,
                                FontWeight.bold,
                                ConstantWidget.getPercentSize(height, 13)),
                            Container(
                              alignment: Alignment.centerRight,
                              child: ConstantWidget.getCustomText(
                                  "",
                                  ConstantData.color1,
                                  1,
                                  TextAlign.left,
                                  FontWeight.bold,
                                  ConstantWidget.getPercentSize(height, 13)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ConstantWidget.getPercentSize(height, 6),
                        ),
                        Row(
                          children: [
                            ConstantWidget.getCustomText(
                                users[3].toString() +
                                    "  " +
                                    users[1].toString(),
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.start,
                                FontWeight.bold,
                                ConstantWidget.getPercentSize(height, 13)),
                          ],
                        ),
                        SizedBox(
                          height: ConstantWidget.getPercentSize(height, 6),
                        ),
                        ConstantWidget.getCustomText(
                            convertToTime(users[4]).toString(),
                            ConstantData.textColor,
                            2,
                            TextAlign.start,
                            FontWeight.w400,
                            ConstantWidget.getPercentSize(height, 13)),
                        SizedBox(
                          height: ConstantWidget.getPercentSize(height, 6),
                        ),
                        Row(
                          children: [
                            ConstantWidget.getCustomText(
                                users[2].toString(),
                                ConstantData.mainTextColor,
                                1,
                                TextAlign.start,
                                FontWeight.bold,
                                ConstantWidget.getPercentSize(height, 13)),
                          ],
                        )
                      ],
                    )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () => Navigator.of(context).pop(users[0].toString()));
  }

  DateTime convertToTime(int time) {
    //DateFormat formatter = DateFormat('yyyyMMddHHmmssms');
    return DateTime.fromMillisecondsSinceEpoch(time);
  }
}
// we will assign delivery boy
