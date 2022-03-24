import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SendPage.dart';
import 'model/WeightModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';

class WeightPage extends StatefulWidget {
  final String title;

  WeightPage(this.title);

  @override
  _WeightPage createState() {
    return _WeightPage();
  }
}

class _WeightPage extends State<WeightPage> {
  List<WeightModel> orderTypeList = DataFile.getWeightModel();

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  int colorPosition = -1;

  @override
  Widget build(BuildContext context) {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);

    double height = ConstantWidget.getScreenPercentSize(context, 12);
    double cellHeight = ConstantWidget.getPercentSize(height, 65);

    //
    // var _crossAxisSpacing = 1;
    // var _screenWidth = MediaQuery.of(context).size.width;
    // var _crossAxisCount = 2;
    // var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
    //     _crossAxisCount;
    //
    // double width =
    //     ConstantWidget.getWidthPercentSize(context, 100) - ((margin * 1.5) * 2);
    // var cellHeight = width / 2;
    // // var cellHeight = ConstantWidget.getScreenPercentSize(context, 22);
    //
    // var _aspectRatio = _width / cellHeight;
    //
    // double imageSize = ConstantWidget.getPercentSize(cellHeight, 25);
    double radius = ConstantWidget.getPercentSize(height, 15);
    // double circle = ConstantWidget.getPercentSize(cellHeight, 35);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.primaryColor,
            title: ConstantWidget.getAppBarText(widget.title),
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
            // padding: EdgeInsets.symmetric(horizontal: margin),
            margin: EdgeInsets.symmetric(vertical: margin),

//             child: GridView.count(
//               crossAxisCount: _crossAxisCount,
//               shrinkWrap: true,
//               childAspectRatio: _aspectRatio,
//               mainAxisSpacing: ((margin * 1.5)),
//               crossAxisSpacing: (margin * 1.5),
//               // childAspectRatio: 0.64,
//               primary: false,
//               children: List.generate(orderTypeList.length, (index) {
//                 if (colorPosition == (ConstantData.colorList().length - 1)) {
//                   colorPosition = 0;
//                 } else {
//                   colorPosition++;
//                 }
//
//                 // var color = ConstantData.primaryColor;
//                 var color = ConstantData.colorList()[colorPosition];
//
//                 return InkWell(
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: ConstantData.cellColor,
//                         borderRadius: BorderRadius.circular(radius),
//                         boxShadow: [
//                           BoxShadow(
//                               color: ConstantData.shadowColor.withOpacity(0.2),
//                               blurRadius: 2,
//                               offset: Offset(0, 2),
//                               spreadRadius: 1)
//                         ]),
//                     child: Stack(
//                       children: [
//
//
//
//
//
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: Container(
//                             height: ((imageSize*2.5)),
//                             width: ((imageSize*2.5)),
//                             child: Image.asset(
//                                 ConstantData.assetsPath +
//                                     orderTypeList[index].image,
//                                 color: color.withOpacity(0.03)),
//
//
//                           ),
//                         )
// ,
//
//
//
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//
//                             Expanded(child: Container(),flex: 1,),
//                             Expanded(child: Padding(padding: EdgeInsets.only(right: (margin),bottom: margin),child: ConstantWidget.getTextWidget(
//                                 orderTypeList[index].title,
//                                 ConstantData.mainTextColor,
//                                 TextAlign.center,
//                                 FontWeight.bold,
//                                 ConstantWidget.getPercentSize(cellHeight, 10)),),
//                               flex: 1,)
//
//
//                             // SizedBox(height: margin,),
//                             // Center(
//                             //   child: Container(
//                             //     height: circle,
//                             //     width: circle,
//                             //     padding: EdgeInsets.all(
//                             //         ConstantWidget.getPercentSize(circle, 30)),
//                             //     decoration: BoxDecoration(
//                             //         color: ConstantData.bgColor,
//                             //         shape: BoxShape.circle),
//                             //     child: Image.asset(
//                             //         ConstantData.assetsPath +
//                             //             orderTypeList[index].image,
//                             //         color: color),
//                             //   ),
//                             // ),
//                           ],
//                         ),
//
//                         Container(
//                           height: circle,
//                           width: circle,
//                           padding: EdgeInsets.all(
//                               ConstantWidget.getPercentSize(circle, 30)),
//                           decoration: BoxDecoration(
//                               color: color,
//                               shape: BoxShape.circle),
//                           child: Image.asset(
//                               ConstantData.assetsPath +
//                                   orderTypeList[index].image,
//                               color: Colors.white),
//                         ),
//
//
//
//                       ],
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => SendPage(),));
//                   },
//                 );
//               }),
//             ),
            child: ListView.builder(
              itemCount: orderTypeList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (colorPosition == (ConstantData.colorList().length - 1)) {
                  colorPosition = 0;
                } else {
                  colorPosition++;
                }

                // var color = ConstantData.primaryColor;
                var color = ConstantData.colorList()[colorPosition];

                return InkWell(
                    child: Container(
                      height: height,
                      // margin: EdgeInsets.only(bottom: margin),
                      margin: EdgeInsets.symmetric(
                          horizontal: margin, vertical: (margin / 2)),
                      padding: EdgeInsets.all(margin / 2),

                      decoration: BoxDecoration(
                          color: ConstantData.cellColor,
                          borderRadius: BorderRadius.circular(radius),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    ConstantData.shadowColor.withOpacity(0.2),
                                blurRadius: 2,
                                offset: Offset(0, 2),
                                spreadRadius: 1)
                          ]),
                      child: Row(
                        children: [
                          Container(
                            height: cellHeight,
                            width: cellHeight,
                            margin: EdgeInsets.only(right: margin),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: color
                                // borderRadius: BorderRadius.circular(
                                //     ConstantWidget.getPercentSize(
                                //         cellHeight, 20)),
                                // border: Border.all(
                                //     color: Colors.grey,
                                //     width: ConstantWidget.getWidthPercentSize(
                                //         context, 0.08)),
                                ),
                            padding: EdgeInsets.all(
                                ConstantWidget.getPercentSize(cellHeight, 30)),
                            child: Image.asset(
                              ConstantData.assetsPath +
                                  orderTypeList[index].image,
                              color: Colors.white,
                            ),
                          ),
                          ConstantWidget.getTextWidget(
                              orderTypeList[index].title,
                              ConstantData.mainTextColor,
                              TextAlign.center,
                              FontWeight.w600,
                              ConstantWidget.getPercentSize(height, 20)),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendPage(),
                          ));
                    });
              },
            ),
          ),
        ),
        onWillPop: _requestPop);
  }
}
