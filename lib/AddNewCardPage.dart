import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'generated/l10n.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/SizeConfig.dart';

class AddNewCardPage extends StatefulWidget {
  @override
  _AddNewCardPage createState() {
    return _AddNewCardPage();
  }
}

class _AddNewCardPage extends State<AddNewCardPage> {
  TextEditingController cardNumberController = new TextEditingController();
  TextEditingController cardHolderNameController = new TextEditingController();
  TextEditingController expDateController = new TextEditingController();
  TextEditingController cvvController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    // cardNumberController.text = "2342 22** **** **00";
    // cardHolderNameController.text = "Claudla T.Reyes";
    // cvvController.text = "2653***";
    // expDateController.text = "06/23";
    //
    //
    // setState(() {});
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double leftMargin = MediaQuery.of(context).size.width * 0.05;

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.primaryColor,
            title: ConstantWidget.getAppBarText(S.of(context).newCard),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: ConstantWidget.getAppBarIcon(),
                  onPressed: _requestPop,
                );
              },
            ),
          ),

          // bottomNavigationBar: Container(
          //   color: ConstantData.bgColor,
          //   height: bottomHeight,
          //   child: Container(
          //     padding: EdgeInsets.all(
          //         ConstantWidget.getPercentSize(bottomHeight, 5)),
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(radius),
          //             topRight: Radius.circular(radius)),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.grey.withOpacity(0.2),
          //             blurRadius: 10,
          //           )
          //         ]),
          //     child: InkWell(
          //       child: Container(
          //         margin: EdgeInsets.symmetric(
          //             horizontal:
          //             ConstantWidget.getPercentSize(bottomHeight, 10),
          //             vertical:
          //             ConstantWidget.getPercentSize(bottomHeight, 16)),
          //         decoration: BoxDecoration(
          //           color: ConstantData.primaryColor,
          //           borderRadius: BorderRadius.all(Radius.circular(subRadius)),
          //         ),
          //         child: Center(
          //           child: ConstantWidget.getTextWidget(
          //               S.of(context).savedCards,
          //               Colors.white,
          //               TextAlign.start,
          //               FontWeight.bold,
          //               ConstantWidget.getPercentSize(bottomHeight, 16)),
          //         ),
          //       ),
          //       onTap: () {
          //         Navigator.of(context).pop(true);
          //       },
          //     ),
          //   ),
          // ),

          bottomNavigationBar: ConstantWidget.getBottomText(
              context, S.of(context).savedCards, () {
            Navigator.of(context).pop(true);
          }),

          body: Container(
            margin: EdgeInsets.only(top: leftMargin),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(top: leftMargin),
                        padding: EdgeInsets.symmetric(horizontal: leftMargin),
                        margin: EdgeInsets.only(bottom: leftMargin),

                        color: ConstantData.bgColor,

                        child: Column(
                          children: [
                            // Padding(
                            //   padding: EdgeInsets.only(bottom: (topMargin*2)),
                            //   child: Align(
                            //     alignment: Alignment.topLeft,
                            //
                            //
                            //     child: ConstantWidget.getTextWidget(
                            //         S.of(context).payment,
                            //         ConstantData.mainTextColor,
                            //         TextAlign.start,
                            //         FontWeight.w800,
                            //         ConstantWidget.getScreenPercentSize(
                            //             context, 2.5)),
                            //
                            //
                            //
                            //   ),
                            // ),

                            // Container(
                            //   margin: EdgeInsets.only(bottom: (topMargin*2),top:topMargin),
                            //   height: editTextHeight,
                            //   child: TextField(
                            //     maxLines: 1,
                            //     controller: cardNumberController,
                            //     style: TextStyle(
                            //         fontFamily: ConstantData.fontFamily,
                            //         color: ConstantData.textColor,
                            //         fontWeight: FontWeight.w400,
                            //         fontSize: ConstantData.font18Px),
                            //
                            //     decoration: InputDecoration(
                            //       enabledBorder:  OutlineInputBorder(
                            //         // width: 0.0 produces a thin "hairline" border
                            //         borderSide:  BorderSide(
                            //             color: ConstantData.textColor, width: 0.0),
                            //       ),
                            //
                            //       border: OutlineInputBorder(
                            //         borderSide:  BorderSide(
                            //             color: ConstantData.textColor, width: 0.0),
                            //       ),
                            //
                            //       labelStyle: TextStyle(
                            //           fontFamily: ConstantData.fontFamily,
                            //           color: ConstantData.textColor
                            //       ),
                            //       labelText: S.of(context).cardNumber,
                            //       // hintText: 'Full Name',
                            //     ),
                            //
                            //
                            //   ),
                            // ),

                            ConstantWidget.getDefaultTextFiledWidget(context,
                                S.of(context).cardNumber, cardNumberController),

                            ConstantWidget.getDefaultTextFiledWidget(
                                context,
                                S.of(context).cardHolderName,
                                cardHolderNameController),

                            Row(
                              children: [
                                Expanded(
                                  child:
                                      ConstantWidget.getDefaultTextFiledWidget(
                                          context,
                                          S.of(context).expDateHint,
                                          expDateController),
                                  flex: 1,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child:
                                      ConstantWidget.getDefaultTextFiledWidget(
                                          context,
                                          S.of(context).cvvHint,
                                          cvvController),
                                  flex: 1,
                                ),
                              ],
                            )

                            // Container(
                            //   margin: EdgeInsets.only(bottom: (topMargin*2)),
                            //   height: editTextHeight,
                            //
                            //   child: TextField(
                            //     maxLines: 1,
                            //     controller: cardHolderNameController,
                            //     style: TextStyle(
                            //         fontFamily: ConstantData.fontFamily,
                            //         color: ConstantData.textColor,
                            //         fontWeight: FontWeight.w400,
                            //         fontSize: ConstantData.font18Px),
                            //
                            //     decoration: InputDecoration(
                            //       enabledBorder:  OutlineInputBorder(
                            //         // width: 0.0 produces a thin "hairline" border
                            //         borderSide:  BorderSide(
                            //             color: ConstantData.textColor, width: 0.0),
                            //       ),
                            //
                            //       border: OutlineInputBorder(
                            //         borderSide:  BorderSide(
                            //             color: ConstantData.textColor, width: 0.0),
                            //       ),
                            //
                            //       labelStyle: TextStyle(
                            //           fontFamily: ConstantData.fontFamily,
                            //           color: ConstantData.textColor
                            //       ),
                            //       labelText: S.of(context).cardHolderName,
                            //
                            //       // hintText: 'Full Name',
                            //     ),
                            //
                            //   ),
                            // ),

                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Column(
                            //         children: [
                            //
                            //           Container(
                            //             height: editTextHeight,
                            //             child: TextField(
                            //               controller: expDateController,
                            //               maxLines: 1,
                            //               style: TextStyle(
                            //                   fontFamily: ConstantData.fontFamily,
                            //                   color: ConstantData.textColor,
                            //                   fontWeight: FontWeight.w400,
                            //                   fontSize: ConstantData.font18Px),
                            //
                            //               decoration: InputDecoration(
                            //                 enabledBorder:  OutlineInputBorder(
                            //                   // width: 0.0 produces a thin "hairline" border
                            //                   borderSide:  BorderSide(
                            //                       color: ConstantData.textColor, width: 0.0),
                            //                 ),
                            //
                            //                 border: OutlineInputBorder(
                            //                   borderSide:  BorderSide(
                            //                       color: ConstantData.textColor, width: 0.0),
                            //                 ),
                            //
                            //                 labelStyle: TextStyle(
                            //                     fontFamily: ConstantData.fontFamily,
                            //                     color: ConstantData.textColor
                            //                 ),
                            //                 labelText: S.of(context).expDateHint,
                            //                 // hintText: 'Full Name',
                            //               ),
                            //
                            //
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       flex: 1,
                            //     ),
                            //     Expanded(
                            //       child: Column(
                            //         children: [
                            //
                            //           Container(
                            //             margin: EdgeInsets.only(left: topMargin),
                            //
                            //             height: editTextHeight,
                            //             child: TextField(
                            //               maxLines: 1,
                            //               controller: cvvController,
                            //
                            //               style: TextStyle(
                            //                   fontFamily: ConstantData.fontFamily,
                            //                   color: ConstantData.textColor,
                            //                   fontWeight: FontWeight.w400,
                            //                   fontSize: ConstantData.font18Px),
                            //
                            //               decoration: InputDecoration(
                            //                 enabledBorder:  OutlineInputBorder(
                            //                   // width: 0.0 produces a thin "hairline" border
                            //                   borderSide:  BorderSide(
                            //                       color: ConstantData.textColor, width: 0.0),
                            //                 ),
                            //
                            //                 border: OutlineInputBorder(
                            //                   borderSide:  BorderSide(
                            //                       color: ConstantData.textColor, width: 0.0),
                            //                 ),
                            //
                            //                 labelStyle: TextStyle(
                            //                     fontFamily: ConstantData.fontFamily,
                            //                     color: ConstantData.textColor
                            //                 ),
                            //                 labelText: S.of(context).cvvHint,
                            //                 // hintText: 'Full Name',
                            //               ),
                            //
                            //
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       flex: 1,
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }
}
