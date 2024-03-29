import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knitman/TabWidget.dart';
import 'package:knitman/util/PrefData.dart';

import 'Database/Db.dart';
import 'MyVouchers.dart';
import 'generated/l10n.dart';
import 'model/AddressModel.dart';
import 'model/PaymentCardModel.dart';
import 'model/PaymentSelectModel.dart';
import 'model/variables.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class PreferencePage extends StatefulWidget {
  final status,
      deliveryTime,
      deliveryDate,
      receivedTime,
      receivedDate,
      orderNumber,
      receiverPhone,
      receiverLocation,
      senderLocation,
      senderPhone,
      senderId,
      type,
      priority,
      weight,
      orderType,
      packageValue;
  double distance;
  GeoPoint receiverCoordinates, senderCoordinates;
  PreferencePage(
      this.status,
      this.deliveryTime,
      this.deliveryDate,
      this.receivedTime,
      this.receivedDate,
      this.orderNumber,
      this.receiverPhone,
      this.receiverLocation,
      this.receiverCoordinates,
      this.senderId,
      this.senderPhone,
      this.senderCoordinates,
      this.senderLocation,
      this.type,
      this.priority,
      this.weight,
      this.orderType,
      this.packageValue,
      this.distance);

  @override
  _PreferencePage createState() {
    return _PreferencePage();
  }
}

class _PreferencePage extends State<PreferencePage> {
  Db db = new Db();
  bool isNotify = false;
  List<AddressModel> addressList = DataFile.getAddressList();
  List<PaymentCardModel> paymentModelList = DataFile.getPaymentCardList();
  double servicePrice;

  //TextEditingController parcelController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  String pointTime, pointDate;
  String deliveryTime, deliveryDate;
  String price;
  String bottomButton = "Continue";

  List<PaymentSelectModel> list = DataFile.getPaymentSelect();
  String userId;
  bool isCash = true;
  void getUser() async {
    userId = await PrefData.getPhoneNumber();
  }

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
  // TODO: implement widget
  PreferencePage get widget => super.widget;
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: margin),
                          child: Row(
                            children: [
                              ConstantWidget.getTextWidget(
                                  S.of(context).paymentMode,
                                  ConstantData.textColor,
                                  TextAlign.start,
                                  FontWeight.bold,
                                  ConstantData.font18Px),
                              new Spacer(),
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
                                      bottomButton = "Finish";
                                    } else {
                                      list[0].select = 0;
                                      bottomButton = "Pay";
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

                        // Visibility(
                        //   child: Container(
                        //     margin: EdgeInsets.symmetric(horizontal: margin),
                        //     child: Column(
                        //       children: [
                        //         ListView.builder(
                        //             shrinkWrap: true,
                        //             physics: NeverScrollableScrollPhysics(),
                        //             itemCount: 1,
                        //             itemBuilder: (context, index) {
                        //               return InkWell(
                        //                 child: Container(
                        //                   margin: EdgeInsets.only(
                        //                       bottom: ConstantWidget
                        //                           .getWidthPercentSize(
                        //                               context, 3.5)),
                        //                   padding: EdgeInsets.all(ConstantWidget
                        //                       .getScreenPercentSize(
                        //                           context, 2)),
                        //                   decoration: getDecoration(),
                        //
                        //                   // decoration: BoxDecoration(
                        //                   //     color: ConstantData.bgColor,
                        //                   //     borderRadius: BorderRadius.circular(
                        //                   //         ConstantWidget.getScreenPercentSize(
                        //                   //             context, 1.5)),
                        //                   //     border: Border.all(
                        //                   //         color: ConstantData.borderColor,
                        //                   //         width: ConstantWidget.getWidthPercentSize(
                        //                   //             context, 0.08)),
                        //                   //     boxShadow: [
                        //                   //       BoxShadow(
                        //                   //         color: Colors.grey.shade200,
                        //                   //       )
                        //                   //     ]),
                        //                   child: Column(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.center,
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.center,
                        //                     children: [
                        //                       Row(
                        //                         children: [
                        //                           Image.asset(
                        //                             paymentModelList[index]
                        //                                 .image,
                        //                             height: ConstantWidget
                        //                                 .getScreenPercentSize(
                        //                                     context, 4),
                        //                           ),
                        //                           SizedBox(
                        //                             width: ConstantWidget
                        //                                 .getScreenPercentSize(
                        //                                     context, 2),
                        //                           ),
                        //                           Expanded(
                        //                             child: Stack(
                        //                               children: [
                        //                                 Row(
                        //                                   mainAxisAlignment:
                        //                                       MainAxisAlignment
                        //                                           .start,
                        //                                   crossAxisAlignment:
                        //                                       CrossAxisAlignment
                        //                                           .center,
                        //                                   children: [
                        //                                     Column(
                        //                                       mainAxisAlignment:
                        //                                           MainAxisAlignment
                        //                                               .start,
                        //                                       crossAxisAlignment:
                        //                                           CrossAxisAlignment
                        //                                               .start,
                        //                                       children: [
                        //                                         ConstantWidget.getCustomTextWithoutAlign(
                        //                                             "Momo Pay",
                        //                                             ConstantData
                        //                                                 .mainTextColor,
                        //                                             FontWeight
                        //                                                 .w700,
                        //                                             ConstantData
                        //                                                 .font22Px),
                        //                                         Padding(
                        //                                           padding: EdgeInsets.only(
                        //                                               top: ConstantWidget.getScreenPercentSize(
                        //                                                   context,
                        //                                                   0.5)),
                        //                                           child: ConstantWidget.getCustomTextWithoutAlign(
                        //                                               "+25078XXXXXXX",
                        //                                               ConstantData
                        //                                                   .textColor,
                        //                                               FontWeight
                        //                                                   .w500,
                        //                                               ConstantData
                        //                                                   .font18Px),
                        //                                         )
                        //                                       ],
                        //                                     ),
                        //                                     // new Spacer(),
                        //                                     // Align(
                        //                                     //   alignment:
                        //                                     //   Alignment.centerRight,
                        //                                     //   child: Padding(
                        //                                     //     padding:
                        //                                     //     EdgeInsets.only(
                        //                                     //         right: 3),
                        //                                     //     child: Icon(
                        //                                     //       (index ==
                        //                                     //           _selectedAddress)
                        //                                     //           ? Icons
                        //                                     //           .radio_button_checked
                        //                                     //           : Icons
                        //                                     //           .radio_button_unchecked,
                        //                                     //       color: (index ==
                        //                                     //           _selectedAddress)
                        //                                     //           ? ConstantData
                        //                                     //           .textColor
                        //                                     //           : Colors.grey,
                        //                                     //       size: ConstantWidget.getPercentSize(cellHeight,
                        //                                     //           25),
                        //                                     //     ),
                        //                                     //   ),
                        //                                     // )
                        //                                   ],
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                             flex: 1,
                        //                           )
                        //                         ],
                        //                       ),
                        //                       spaceWidget,
                        //                       getPhoneCell(phoneController),
                        //                     ],
                        //                   ),
                        //                 ),
                        //                 onTap: () {
                        //                   _selectedCard = index;
                        //                   setState(() {});
                        //                 },
                        //               );
                        //             }),
                        //         spaceWidget,
                        //         Container(
                        //           height: ConstantWidget.getScreenPercentSize(
                        //               context, 0.05),
                        //           color: Colors.grey,
                        //         ),
                        //         spaceWidget,
                        //       ],
                        //     ),
                        //   ),
                        //   visible: (!isCash),
                        // ),
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
                            child: FutureBuilder<List<Variables>>(
                              builder: (ctx, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return InkWell(
                                    child: ConstantWidget.getTextWidget(
                                        "RWF " +
                                            ((super.widget.distance *
                                                        snapshot.data[0].price)
                                                    .toInt())
                                                .toString(),
                                        Colors.white,
                                        TextAlign.start,
                                        FontWeight.w700,
                                        ConstantWidget.getPercentSize(
                                            bottomHeight, 35)),
                                    onTap: () {
                                      bottomDialog();
                                    },
                                  );
                                }
                              },
                              future: db.getVariables(),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              height: bottomHeight,
                              width: ConstantWidget.getWidthPercentSize(
                                  context, 40),
                              decoration: BoxDecoration(
                                  color: ConstantData.accentColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ConstantWidget.getPercentSize(
                                              bottomHeight, 30)))),
                              child: Center(
                                child: ConstantWidget.getCustomText(
                                    bottomButton,
                                    Colors.white,
                                    1,
                                    TextAlign.center,
                                    FontWeight.w500,
                                    ConstantWidget.getPercentSize(
                                        bottomHeight, 40)),
                              ),
                            ),
                            onTap: () {
                              // Navigator.push(
                              //context,
                              // MaterialPageRoute(
                              // builder: (context) => SubmitOrderPage(),
                              // ));
                              if (isCash == true) {
                                int dis = super.widget.distance.round();
                                servicePrice = dis.toDouble() * 120;
                                db
                                    .addOrder(
                                      widget.status,
                                      widget.deliveryTime,
                                      widget.deliveryDate,
                                      widget.receivedTime,
                                      widget.receivedDate,
                                      widget.orderNumber,
                                      widget.senderId,
                                      widget.senderPhone,
                                      widget.senderLocation,
                                      widget.receiverPhone,
                                      widget.receiverLocation,
                                      widget.type,
                                      widget.priority,
                                      widget.orderType,
                                      widget.weight,
                                      widget.packageValue,
                                      phoneController.text,
                                      servicePrice.toString(),
                                      "Cash",
                                      widget.receiverCoordinates,
                                      widget.senderCoordinates,
                                    )
                                    .whenComplete(() => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TabWidget(true),
                                        )));
                              } else {
                                bottomDeliverDialog();
                              }
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

  double priceCalculators(String packageType, double distance, double orderType,
      double packageValue, double price, double weight) {
    double newPrice;

    switch (packageType) {
      case "Document":
        {
          if (orderType == 0) {
            newPrice = price * distance * weight;
            newPrice = newPrice + newPrice * 1.5;
            if (newPrice < 100) {
              newPrice = 100;
            } else if (newPrice > 5000) {
              newPrice = 5000;
            }
          } else {
            newPrice = price * distance * weight;
            if (newPrice < 500) {
              newPrice = 500;
            } else if (newPrice > 3000) {
              newPrice = 3000;
            }
          }
        }
        break;

      case "Food Or Meal":
        {
          if (orderType == 0) {
            newPrice = price * distance * weight;
            newPrice = newPrice + newPrice * 1.5;
            if (newPrice < 100) {
              newPrice = 100;
            } else if (newPrice > 5000) {
              newPrice = 5000;
            }
          } else {
            newPrice = price * distance * weight;
            if (newPrice < 500) {
              newPrice = 500;
            } else if (newPrice > 3000) {
              newPrice = 3000;
            }
          }
        }
        break;

      case "Cloths":
        {
          if (orderType == 0) {
            newPrice = price * distance * weight;
            newPrice = newPrice + newPrice * 1.5;
            if (newPrice < 100) {
              newPrice = 100;
            } else if (newPrice > 5000) {
              newPrice = 5000;
            }
          } else {
            newPrice = price * distance * weight;
            if (newPrice < 500) {
              newPrice = 500;
            } else if (newPrice > 3000) {
              newPrice = 3000;
            }
          }
        }
        break;

      case "Groceries":
        {
          if (orderType == 0) {
            newPrice = price * distance * weight;
            newPrice = newPrice + newPrice * 1.5;
            if (newPrice < 100) {
              newPrice = 100;
            } else if (newPrice > 5000) {
              newPrice = 5000;
            }
          } else {
            newPrice = price * distance * weight;
            if (newPrice < 500) {
              newPrice = 500;
            } else if (newPrice > 3000) {
              newPrice = 3000;
            }
          }
        }
        break;
      case "Flowers":
        {
          if (orderType == 0) {
            newPrice = price * distance * weight;
            newPrice = newPrice + newPrice * 1.5;
            if (newPrice < 100) {
              newPrice = 100;
            } else if (newPrice > 5000) {
              newPrice = 5000;
            }
          } else {
            newPrice = price * distance * weight;
            if (newPrice < 500) {
              newPrice = 500;
            } else if (newPrice > 3000) {
              newPrice = 3000;
            }
          }
        }
        break;
      case "Cake":
        {
          if (orderType == 0) {
            newPrice = price * distance * weight;
            newPrice = newPrice + newPrice * 1.5;
            if (newPrice < 100) {
              newPrice = 100;
            } else if (newPrice > 5000) {
              newPrice = 5000;
            }
          } else {
            newPrice = price * distance * weight;
            if (newPrice < 500) {
              newPrice = 500;
            } else if (newPrice > 3000) {
              newPrice = 3000;
            }
          }
        }
        break;
      case "Spare part":
        {
          if (orderType == 0) {
            newPrice = price * distance * weight;
            newPrice = newPrice + newPrice * 1.5;
            if (newPrice < 100) {
              newPrice = 100;
            } else if (newPrice > 5000) {
              newPrice = 5000;
            }
          } else {
            newPrice = price * distance * weight;
            if (newPrice < 500) {
              newPrice = 500;
            } else if (newPrice > 3000) {
              newPrice = 3000;
            }
          }
        }
        break;
      case "other":
        {
          if (orderType == 0) {
            newPrice = price * distance * weight;
            newPrice = newPrice + newPrice * 1.5;
            if (newPrice < 100) {
              newPrice = 100;
            } else if (newPrice > 5000) {
              newPrice = 5000;
            }
          } else {
            newPrice = price * distance * weight;
            if (newPrice < 500) {
              newPrice = 500;
            } else if (newPrice > 3000) {
              newPrice = 3000;
            }
          }
        }
        break;

      default:
        {
          print("Invalid choice");
        }
        break;
    }
    this.price = newPrice.toString();
    servicePrice = newPrice;
    return newPrice;
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
                    S.of(context).payNow,
                    ConstantData.mainTextColor,
                    TextAlign.start,
                    FontWeight.w700,
                    ConstantWidget.getScreenPercentSize(context, 3)),
                widget,
                FutureBuilder<List<Variables>>(
                  builder: (context, orderSnap) {
                    if (!orderSnap.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ConstantWidget.getCustomText(
                          orderSnap.data[0].momoCode +
                              "\n " +
                              orderSnap.data[0].momoNumber +
                              "\n " +
                              orderSnap.data[0].bankAccount,
                          Colors.blue,
                          6,
                          TextAlign.start,
                          FontWeight.w900,
                          ConstantData.font22Px);
                    }
                  },
                  future: db.getVariables(),
                ),
                widget,
                SizedBox(
                  height: (margin / 2),
                ),
                ConstantWidget.getCustomText(
                    "The order will be assigned to the nearest courier as soon as possible",
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
                SizedBox(
                  height: (margin / 2),
                ),
                ConstantWidget.getCustomText(
                    "After payment click on continue or Call our team for any issue on :078XXXXXXX",
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
                ConstantWidget.getBottomText(context, "Continue", () {
                  if (isCash == false) {
                    int dis = super.widget.distance.round();
                    servicePrice = dis.toDouble() * 120;
                    db
                        .addOrder(
                          super.widget.status,
                          super.widget.deliveryTime,
                          super.widget.deliveryDate,
                          super.widget.receivedTime,
                          super.widget.receivedDate,
                          super.widget.orderNumber,
                          super.widget.senderId,
                          super.widget.senderPhone,
                          super.widget.senderLocation,
                          super.widget.receiverPhone,
                          super.widget.receiverLocation,
                          super.widget.type,
                          super.widget.priority,
                          super.widget.orderType,
                          super.widget.weight,
                          super.widget.packageValue,
                          phoneController.text,
                          servicePrice.toString(),
                          "Other",
                          super.widget.senderCoordinates,
                          super.widget.receiverCoordinates,
                        )
                        .whenComplete(() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabWidget(true),
                            )));
                  }
                })
              ],
            ),
          )
        ],
      ),
    );
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
                  ConstantWidget.getTextWidget("", ConstantData.mainTextColor,
                      TextAlign.start, FontWeight.w400, ConstantData.font22Px),
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
                  ConstantWidget.getTextWidget("", ConstantData.mainTextColor,
                      TextAlign.start, FontWeight.w400, ConstantData.font22Px),
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
                  ConstantWidget.getTextWidget("", ConstantData.mainTextColor,
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
            hintText: "MoMo Number",
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
