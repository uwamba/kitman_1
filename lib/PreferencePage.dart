import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AddNewCardPage.dart';
import 'MyVouchers.dart';
import 'SubmitOrderPage.dart';
import 'generated/l10n.dart';
import 'model/AddressModel.dart';
import 'model/PaymentCardModel.dart';
import 'model/PaymentSelectModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class PreferencePage extends StatefulWidget {
  @override
  _PreferencePage createState() {
    return _PreferencePage();
  }
}

class _PreferencePage extends State<PreferencePage> {
  bool isNotify = false;
  List<AddressModel> addressList = DataFile.getAddressList();
  List<PaymentCardModel> paymentModelList = DataFile.getPaymentCardList();

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

  int _selectedAddress = 0;
  int _selectedCard = 0;

  double margin;
  double radius;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    margin = ConstantWidget.getScreenPercentSize(context, 2);
    radius = ConstantWidget.getScreenPercentSize(context, 1.5);
    double image = ConstantWidget.getScreenPercentSize(context, 3);

    var spaceWidget = new SizedBox(
      height: margin,
    );
    double cellHeight = MediaQuery.of(context).size.width * 0.2;
    double topMargin = ConstantWidget.getScreenPercentSize(context, 1);
    double bottomHeight = ConstantWidget.getScreenPercentSize(context, 7);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.primaryColor,
            title: ConstantWidget.getAppBarText(S.of(context).preference),
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
                        getParcelCell(parcelController),
                        spaceWidget,
                        getPhoneCell(phoneController),
                        spaceWidget,
                        getNotifyCell(),
                        spaceWidget,
                        getPromoCodeCell(),
                        spaceWidget,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: margin),
                          child: Row(
                            children: [
                              ConstantWidget.getTextWidget(
                                  S.of(context).paymentMode,
                                  ConstantData.textColor,
                                  TextAlign.start,
                                  FontWeight.w500,
                                  ConstantData.font18Px),
                              new Spacer(),
                              InkWell(
                                child: ConstantWidget.getUnderlineText(
                                    S.of(context).newCard,
                                    ConstantData.accentColor,
                                    1,
                                    TextAlign.start,
                                    FontWeight.w500,
                                    ConstantData.font18Px),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddNewCardPage(),
                                      ));
                                },
                              )
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(vertical: (margin)),
                          padding: EdgeInsets.symmetric(
                              horizontal: margin, vertical: (margin * 1.8)),
                          color: ConstantData.cellColor,
                          child: ListView.separated(
                            itemCount: list.length,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return Container(
                                height: ConstantWidget.getScreenPercentSize(
                                    context, 0.02),
                                color: ConstantData.textColor,
                                margin:
                                    EdgeInsets.symmetric(vertical: (margin)),
                              );
                            },
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: (margin / 2)),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            list[index].icon,
                                            color: ConstantData.textColor,
                                            size: image,
                                          ),
                                          SizedBox(
                                            width: margin,
                                          ),
                                          ConstantWidget.getCustomText(
                                              list[index].name,
                                              ConstantData.textColor,
                                              1,
                                              TextAlign.start,
                                              FontWeight.bold,
                                              ConstantWidget
                                                  .getScreenPercentSize(
                                                      context, 2.3)),
                                          new Spacer(),

                                          Icon(
                                            (list[index].select == 1)
                                                ? CupertinoIcons
                                                    .checkmark_alt_circle_fill
                                                : Icons.radio_button_off,
                                            color: (list[index].select == 1)
                                                ? Colors.orange
                                                : ConstantData.textColor,
                                            size: image,
                                          ),

                                          // InkWell(
                                          //   child: Icon((list[index].select == 1) ? CupertinoIcons
                                          //       .checkmark_alt_circle_fill : Icons
                                          //       .radio_button_off,
                                          //     color: (list[index].select == 1)
                                          //         ? Colors.orange
                                          //         : ConstantData.textColor, size: image,),
                                          //   onTap: () {
                                          //     setState(() {
                                          //       list[index].select = 1;
                                          //       if (index == 0) {
                                          //         list[1].select = 0;
                                          //       } else {
                                          //         list[0].select = 0;
                                          //       }
                                          //       if (list[0].select == 1) {
                                          //         isCash = true;
                                          //       } else {
                                          //         isCash = false;
                                          //       }
                                          //     });
                                          //   },
                                          // )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    list[index].select = 1;
                                    if (index == 0) {
                                      list[1].select = 0;
                                    } else {
                                      list[0].select = 0;
                                    }
                                    if (list[0].select == 1) {
                                      isCash = true;
                                    } else {
                                      isCash = false;
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),

                        Visibility(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: margin),
                            child: Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: paymentModelList.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: ConstantWidget
                                                  .getWidthPercentSize(
                                                      context, 3.5)),
                                          padding: EdgeInsets.all(ConstantWidget
                                              .getScreenPercentSize(
                                                  context, 2)),
                                          decoration: getDecoration(),

                                          // decoration: BoxDecoration(
                                          //     color: ConstantData.bgColor,
                                          //     borderRadius: BorderRadius.circular(
                                          //         ConstantWidget.getScreenPercentSize(
                                          //             context, 1.5)),
                                          //     border: Border.all(
                                          //         color: ConstantData.borderColor,
                                          //         width: ConstantWidget.getWidthPercentSize(
                                          //             context, 0.08)),
                                          //     boxShadow: [
                                          //       BoxShadow(
                                          //         color: Colors.grey.shade200,
                                          //       )
                                          //     ]),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    paymentModelList[index]
                                                        .image,
                                                    height: ConstantWidget
                                                        .getScreenPercentSize(
                                                            context, 4),
                                                  ),
                                                  SizedBox(
                                                    width: ConstantWidget
                                                        .getScreenPercentSize(
                                                            context, 2),
                                                  ),
                                                  Expanded(
                                                    child: Stack(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ConstantWidget.getCustomTextWithoutAlign(
                                                                    paymentModelList[
                                                                            index]
                                                                        .name,
                                                                    ConstantData
                                                                        .mainTextColor,
                                                                    FontWeight
                                                                        .w700,
                                                                    ConstantData
                                                                        .font22Px),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: ConstantWidget.getScreenPercentSize(
                                                                          context,
                                                                          0.5)),
                                                                  child: ConstantWidget.getCustomTextWithoutAlign(
                                                                      paymentModelList[
                                                                              index]
                                                                          .desc,
                                                                      ConstantData
                                                                          .textColor,
                                                                      FontWeight
                                                                          .w500,
                                                                      ConstantData
                                                                          .font18Px),
                                                                )
                                                              ],
                                                            ),
                                                            // new Spacer(),
                                                            // Align(
                                                            //   alignment:
                                                            //   Alignment.centerRight,
                                                            //   child: Padding(
                                                            //     padding:
                                                            //     EdgeInsets.only(
                                                            //         right: 3),
                                                            //     child: Icon(
                                                            //       (index ==
                                                            //           _selectedAddress)
                                                            //           ? Icons
                                                            //           .radio_button_checked
                                                            //           : Icons
                                                            //           .radio_button_unchecked,
                                                            //       color: (index ==
                                                            //           _selectedAddress)
                                                            //           ? ConstantData
                                                            //           .textColor
                                                            //           : Colors.grey,
                                                            //       size: ConstantWidget.getPercentSize(cellHeight,
                                                            //           25),
                                                            //     ),
                                                            //   ),
                                                            // )
                                                          ],
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 3),
                                                            child: Icon(
                                                              (index ==
                                                                      _selectedCard)
                                                                  ? Icons
                                                                      .radio_button_checked
                                                                  : Icons
                                                                      .radio_button_unchecked,
                                                              color: (index ==
                                                                      _selectedCard)
                                                                  ? ConstantData
                                                                      .primaryColor
                                                                  : Colors.grey,
                                                              size: ConstantWidget
                                                                  .getPercentSize(
                                                                      cellHeight,
                                                                      30),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    flex: 1,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          _selectedCard = index;
                                          setState(() {});
                                        },
                                      );
                                    }),
                                spaceWidget,
                                Container(
                                  height: ConstantWidget.getScreenPercentSize(
                                      context, 0.05),
                                  color: Colors.grey,
                                ),
                                spaceWidget,
                              ],
                            ),
                          ),
                          visible: (!isCash),
                        ),
                        spaceWidget,
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: margin),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: addressList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom:
                                            ConstantWidget.getWidthPercentSize(
                                                context, 3)),
                                    padding: EdgeInsets.all(
                                        ConstantWidget.getPercentSize(
                                            cellHeight, 10)),

                                    decoration: getDecoration(),
                                    // decoration: BoxDecoration(
                                    //     color: ConstantData.bgColor,
                                    //     borderRadius: BorderRadius.circular(ConstantWidget.getPercentSize(
                                    //         cellHeight,10 )),
                                    //     border: Border.all(
                                    //         color: ConstantData.borderColor,
                                    //         width: ConstantWidget.getWidthPercentSize(
                                    //             context, 0.08)),
                                    //     boxShadow: [
                                    //       BoxShadow(
                                    //         color: Colors.grey.shade200,
                                    //       )
                                    //     ]),

                                    height: cellHeight,

                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ConstantWidget
                                                          .getCustomTextWithoutAlign(
                                                              addressList[index]
                                                                  .name,
                                                              ConstantData
                                                                  .mainTextColor,
                                                              FontWeight.w700,
                                                              ConstantWidget
                                                                  .getPercentSize(
                                                                      cellHeight,
                                                                      20)),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top:
                                                                    (topMargin /
                                                                        2)),
                                                        child: ConstantWidget
                                                            .getCustomTextWithoutAlign(
                                                                addressList[
                                                                        index]
                                                                    .location,
                                                                ConstantData
                                                                    .textColor,
                                                                FontWeight.w500,
                                                                ConstantWidget
                                                                    .getPercentSize(
                                                                        cellHeight,
                                                                        15)),
                                                      )
                                                    ],
                                                  ),
                                                  new Spacer(),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 3),
                                                      child: Icon(
                                                        (index ==
                                                                _selectedAddress)
                                                            ? Icons
                                                                .radio_button_checked
                                                            : Icons
                                                                .radio_button_unchecked,
                                                        color: (index ==
                                                                _selectedAddress)
                                                            ? ConstantData
                                                                .primaryColor
                                                            : Colors.grey,
                                                        size: ConstantWidget
                                                            .getPercentSize(
                                                                cellHeight, 30),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              flex: 1,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    _selectedAddress = index;
                                    setState(() {});
                                  },
                                );
                              }),
                        ),
                        spaceWidget,

                        // ConstantWidget.getBottomText(context, S.of(context).continueText, (){
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitOrderPage(),));
                        // })
                      ],
                    ),
                  ),
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
                          Expanded(
                            child: InkWell(
                              child: ConstantWidget.getTextWidget(
                                  "₹40",
                                  Colors.white,
                                  TextAlign.start,
                                  FontWeight.w700,
                                  ConstantWidget.getPercentSize(
                                      bottomHeight, 35)),
                              onTap: () {
                                bottomDialog();
                              },
                            ),
                          ),
                          InkWell(
                            child: ConstantWidget.getTextWidget(
                                S.of(context).done,
                                Colors.white,
                                TextAlign.start,
                                FontWeight.w700,
                                ConstantWidget.getPercentSize(
                                    bottomHeight, 35)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubmitOrderPage(),
                                  ));
                            },
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      // bottomDialog();
                    },
                  )
                ],
              )),
        ),
        onWillPop: _requestPop);
  }

  void bottomDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConstantData.bgColor,
      builder: (builder) {
        return new Container(
          height: ConstantWidget.getScreenPercentSize(context, 24),
          padding: EdgeInsets.all(
            ConstantData.font22Px,
          ),
          decoration: new BoxDecoration(
            color: ConstantData.bgColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  ConstantWidget.getTextWidget(
                      "Delivery Fee",
                      ConstantData.mainTextColor,
                      TextAlign.start,
                      FontWeight.w400,
                      ConstantData.font22Px),
                  new Spacer(),
                  ConstantWidget.getTextWidget(
                      "₹10",
                      ConstantData.mainTextColor,
                      TextAlign.start,
                      FontWeight.w400,
                      ConstantData.font22Px),
                ],
              ),
              SizedBox(
                height: ConstantData.font22Px,
              ),
              Row(
                children: [
                  ConstantWidget.getTextWidget(
                      "Weight Fee",
                      ConstantData.mainTextColor,
                      TextAlign.start,
                      FontWeight.w400,
                      ConstantData.font22Px),
                  new Spacer(),
                  ConstantWidget.getTextWidget(
                      "₹30",
                      ConstantData.mainTextColor,
                      TextAlign.start,
                      FontWeight.w400,
                      ConstantData.font22Px),
                ],
              ),
              SizedBox(
                height: ConstantData.font22Px,
              ),
              Row(
                children: [
                  ConstantWidget.getTextWidget(
                      "Security Fee",
                      ConstantData.mainTextColor,
                      TextAlign.start,
                      FontWeight.w400,
                      ConstantData.font22Px),
                  new Spacer(),
                  ConstantWidget.getTextWidget("₹5", ConstantData.mainTextColor,
                      TextAlign.start, FontWeight.w400, ConstantData.font22Px),
                ],
              ),
            ],
          ),
        );
      },
    );
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

  getPhoneCell(TextEditingController textEditingController) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration: getDecoration(),
      child: TextField(
        keyboardType: TextInputType.number,
        enabled: true,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: TextStyle(
            fontFamily: ConstantData.fontFamily,
            color: ConstantData.mainTextColor),
        controller: textEditingController,
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            suffixIcon: Icon(
              Icons.phone_android,
              color: Colors.grey,
            ),
            hintText: "Phone",
            hintStyle: TextStyle(
                fontFamily: ConstantData.fontFamily, color: Colors.grey)),
      ),
    );
  }

  getPromoCodeCell() {
    return InkWell(
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: getDecoration(),
        child: Row(
          children: [
            Icon(
              Icons.local_offer,
              color: ConstantData.accentColor,
            ),
            SizedBox(
              width: (margin / 2),
            ),
            Expanded(
                child: TextField(
              enabled: false,
              style: TextStyle(
                  fontFamily: ConstantData.fontFamily,
                  color: ConstantData.mainTextColor),
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: S.of(context).promoCode,
                  hintStyle: TextStyle(
                      fontFamily: ConstantData.fontFamily,
                      color: ConstantData.mainTextColor)),
            )),
            ConstantWidget.getTextWidget(
                S.of(context).apply,
                ConstantData.mainTextColor,
                TextAlign.end,
                FontWeight.w500,
                ConstantData.font18Px),
            SizedBox(
              width: (margin / 1.5),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyVouchers(true),
            ));
      },
    );
  }

  getNotifyCell() {
    return InkWell(
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: getDecoration(),
        child: TextField(
          enabled: false,
          style: TextStyle(
              fontFamily: ConstantData.fontFamily,
              color: ConstantData.mainTextColor),
          decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              suffixIcon: Icon(
                (!isNotify) ? Icons.toggle_off : Icons.toggle_on_rounded,
                color: (!isNotify) ? Colors.grey : ConstantData.primaryColor,
                size: (margin * 3),
              ),
              hintText: S.of(context).notifyMeBySms,
              hintStyle: TextStyle(
                  fontFamily: ConstantData.fontFamily,
                  color:
                      (!isNotify) ? Colors.grey : ConstantData.mainTextColor)),
        ),
      ),
      onTap: () {
        setState(() {
          if (isNotify) {
            isNotify = false;
          } else {
            isNotify = true;
          }
        });
      },
    );
  }

  getParcelCell(TextEditingController textEditingController) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: (margin / 2), horizontal: margin),
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration: getDecoration(),
      child: TextField(
        controller: textEditingController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        style: TextStyle(
            fontFamily: ConstantData.fontFamily,
            color: ConstantData.mainTextColor),
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            suffixIcon: Icon(
              Icons.help_outline,
              color: Colors.grey,
            ),
            hintText: "Parcel Value",
            hintStyle: TextStyle(
                fontFamily: ConstantData.fontFamily, color: Colors.grey)),
      ),
    );
  }
}
