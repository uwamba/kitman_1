import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Database/Db.dart';
import 'generated/l10n.dart';
import 'model/UserlListModel.dart';
import 'model/VouchersModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersList createState() {
    return _UsersList();
  }
}

class _UsersList extends State<UsersList> {
  List<VouchersModel> voucherList = DataFile.getVouchersList();

  @override
  void initState() {
    super.initState();
    voucherList = DataFile.getVouchersList();
    setState(() {});
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = SizeConfig.safeBlockVertical * 7;
    double defMargin = ConstantWidget.getScreenPercentSize(context, 2);
    double imgSize = ConstantWidget.getScreenPercentSize(context, 10);
    double radius = ConstantWidget.getScreenPercentSize(context, 1.2);
    double fontSize = ConstantWidget.getScreenPercentSize(context, 1.8);
    Db db = new Db();
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = ConstantWidget.getScreenPercentSize(context, 5);

    SizeConfig().init(context);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.primaryColor,
            title: ConstantWidget.getAppBarText(S.of(context).users),
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
            child: Container(
              margin: EdgeInsets.only(
                  left: defMargin,
                  right: defMargin,
                  top: defMargin,
                  bottom: defMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(bottom: (defMargin), top: defMargin),
                    padding: EdgeInsets.only(left: (defMargin / 2)),
                    height: imageSize,
                    decoration: BoxDecoration(
                        color: ConstantData.cellColor,
                        borderRadius: BorderRadius.circular(radius),
                        boxShadow: [
                          BoxShadow(
                            color: ConstantData.shadowColor,
                          )
                        ]),
                    child: TextField(
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(
                          fontFamily: ConstantData.fontFamily,
                          color: ConstantData.mainTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: fontSize),
                      decoration: InputDecoration(
                        hintText: S.of(context).users,
                        hintStyle: TextStyle(
                            fontFamily: ConstantData.fontFamily,
                            color: ConstantData.mainTextColor,
                            fontWeight: FontWeight.w400,
                            fontSize: fontSize),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  //
                  // Container(
                  //   margin: EdgeInsets.only(bottom: (defMargin*2)),
                  //   padding: EdgeInsets.only(left: (defMargin/2)),
                  //   height: imageSize,
                  //
                  //   decoration: BoxDecoration(
                  //       color:    ConstantData.cellColor,
                  //       borderRadius: BorderRadius.circular(radius),
                  //       boxShadow: [
                  //         BoxShadow(
                  //             color: ConstantData.shadowColor,)
                  //
                  //       ]),
                  //
                  //   child: TextField(
                  //     maxLines: 1,
                  //     textInputAction: TextInputAction.done,
                  //
                  //     style: TextStyle(
                  //         fontFamily: ConstantData.fontFamily,
                  //         color: ConstantData.mainTextColor,
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: fontSize),
                  //     decoration: InputDecoration(
                  //
                  //       hintText:S.of(context).searchVouchers,
                  //       hintStyle: TextStyle(
                  //           fontFamily: ConstantData.fontFamily,
                  //           color: ConstantData.mainTextColor,
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: fontSize),
                  //       border: InputBorder.none,
                  //       contentPadding: EdgeInsets.zero,
                  //     ),
                  //   ),
                  // ),

                  Text(
                    S.of(context).users,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: ConstantData.fontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: ConstantData.font18Px,
                        color: ConstantData.textColor),
                  ),

                  SizedBox(
                    height: (defMargin),
                  ),
                  Expanded(
                    child: FutureBuilder<List<UserListModel>>(
                      builder: (context, orderSnap) {
                        if (!orderSnap.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            itemCount: orderSnap.data.length,
                            itemBuilder: (context, index) {
                              //OrderList listModel = orderSnap.data[index];
                              return InkWell(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: (margin / 2),
                                      horizontal: margin),
                                  padding: EdgeInsets.all((margin / 1.5)),
                                  decoration: getDecoration(),
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: ConstantWidget
                                                    .getCustomText(
                                                        orderSnap.data[index]
                                                            .lastName,
                                                        Colors.grey,
                                                        2,
                                                        TextAlign.start,
                                                        FontWeight.w500,
                                                        ConstantData.font15Px)),
                                            Container(
                                              color: ConstantData.primaryColor,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: (margin / 2)),
                                              child:
                                                  ConstantWidget.getCustomText(
                                                      orderSnap
                                                          .data[index].lastName,
                                                      Colors.white,
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.w500,
                                                      ConstantData.font18Px),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: (margin / 2),
                                        ),
                                        ConstantWidget.getCustomText(
                                            orderSnap.data[index].email,
                                            ConstantData.mainTextColor,
                                            1,
                                            TextAlign.start,
                                            FontWeight.bold,
                                            ConstantData.font22Px),
                                        SizedBox(
                                          height: (margin / 2),
                                        ),
                                        ConstantWidget.getCustomText(
                                            "Role: " +
                                                orderSnap.data[index].role
                                                    .toString(),
                                            Colors.grey,
                                            2,
                                            TextAlign.start,
                                            FontWeight.w500,
                                            ConstantData.font18Px),
                                        SizedBox(
                                          height: (margin / 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  //Navigator.push(
                                  // context,
                                  // MaterialPageRoute(
                                  //  builder: (context) => CompleteOrderDetail(
                                  // DataFile.getActiveOrderList()[0]),
                                  // ));
                                },
                              );
                            },
                          );
                        }
                      },
                      future: db.usersList(),
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  getDecoration() {
    return BoxDecoration(
        color: ConstantData.cellColor,
        borderRadius: BorderRadius.circular(
            ConstantWidget.getScreenPercentSize(context, 2)),
        boxShadow: [
          BoxShadow(
              color: ConstantData.shadowColor.withOpacity(0.2),
              blurRadius: 2,
              offset: Offset(0, 2),
              spreadRadius: 1)
        ]);
  }
}
