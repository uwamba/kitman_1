import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'generated/l10n.dart';
import 'model/VouchersModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class MyVouchers extends StatefulWidget {
  final bool isCopy;

  MyVouchers(this.isCopy);

  @override
  _MyVouchers createState() {
    return _MyVouchers();
  }
}

class _MyVouchers extends State<MyVouchers> {
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

    SizeConfig().init(context);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.primaryColor,
            title: ConstantWidget.getAppBarText(S.of(context).myVouchers),
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
                        hintText: S.of(context).searchVouchers,
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
                    S.of(context).myVouchers,
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
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: voucherList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                top: defMargin, bottom: defMargin),
                            padding: EdgeInsets.all(defMargin),
                            decoration: BoxDecoration(
                                color: ConstantData.cellColor,
                                borderRadius: BorderRadius.circular(radius),
                                boxShadow: [
                                  BoxShadow(
                                    color: ConstantData.shadowColor,
                                  )
                                ]),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: defMargin),
                                  child: Image.asset(
                                    ConstantData.assetsPath +
                                        voucherList[index].image,
                                    height: imgSize,
                                    width: imgSize,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstantWidget.getCustomTextWithoutAlign(
                                          voucherList[index].name,
                                          ConstantData.mainTextColor,
                                          FontWeight.w700,
                                          ConstantData.font18Px),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: defMargin,
                                            top: (defMargin / 3)),
                                        child: ConstantWidget
                                            .getCustomTextWithoutAlign(
                                                voucherList[index].desc,
                                                ConstantData.mainTextColor,
                                                FontWeight.w500,
                                                ConstantData.font15Px),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            child: Container(
                                              height: ConstantWidget
                                                  .getScreenPercentSize(
                                                      context, 4),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      (defMargin / 1.5)),
                                              // width: 120,
                                              decoration: BoxDecoration(
                                                color:
                                                    ConstantData.primaryColor,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        (defMargin / 2)),
                                              ),
                                              child: Center(
                                                child: ConstantWidget
                                                    .getCustomTextWithoutAlign(
                                                        voucherList[index].code,
                                                        Colors.white,
                                                        FontWeight.w500,
                                                        ConstantData.font15Px),
                                              ),
                                            ),
                                            onTap: () {
                                              if (widget.isCopy) {
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                          new Spacer()
                                        ],
                                      )
                                    ],
                                  ),
                                  flex: 1,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ConstantWidget.getCustomTextWithoutAlign(
                                          S.of(context).exp,
                                          ConstantData.mainTextColor,
                                          FontWeight.w500,
                                          ConstantData.font15Px),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: defMargin),
                                        child: ConstantWidget
                                            .getCustomTextWithoutAlign(
                                                voucherList[index].date,
                                                ConstantData.textColor,
                                                FontWeight.w700,
                                                ConstantData.font12Px),
                                      ),
                                      ConstantWidget.getCustomTextWithoutAlign(
                                          voucherList[index].month,
                                          ConstantData.mainTextColor,
                                          FontWeight.w500,
                                          ConstantData.font15Px),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                    flex: 1,
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }
}
