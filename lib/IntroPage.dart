import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'generated/l10n.dart';
import 'main.dart';
import 'model/IntroModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/PrefData.dart';
import 'util/SizeConfig.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPage createState() {
    return _IntroPage();
  }
}

class _IntroPage extends State<IntroPage> {
  int _position = 0;

  Future<bool> _requestPop() {
    Future.delayed(const Duration(milliseconds: 200), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });

    return new Future.value(false);
  }

  final controller = PageController();

  List<IntroModel> introModelList;

  String s;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    introModelList = DataFile.getIntroModel(context);

    double defMargin = ConstantWidget.getScreenPercentSize(context, 2);
    double mainHeight = ConstantWidget.getScreenPercentSize(context, 55);
    setState(() {});

    if (s == null) {
      s = S.of(context).continueText;
    }

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        child: PageView.builder(
                          controller: controller,
                          itemBuilder: (context, position) {
                            return Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: mainHeight,
                                    margin: EdgeInsets.all(defMargin),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          // image: AssetImage(
                                          //     ConstantData.assetsPath +
                                          //         introModelList[position]
                                          //             .image),
                                          // fit: BoxFit.cover)
                                          ),
                                      // )

                                      child: Image.asset(
                                          ConstantData.assetsPath +
                                              introModelList[position].image),
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: defMargin * 2,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all((defMargin / 2)),
                                        child: ConstantWidget.getCustomText(
                                            introModelList[position].name,
                                            ConstantData.mainTextColor,
                                            2,
                                            TextAlign.start,
                                            FontWeight.bold,
                                            25),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: (defMargin / 2)),
                                        child: ConstantWidget.getCustomText(
                                            introModelList[position].desc,
                                            ConstantData.textColor,
                                            4,
                                            TextAlign.start,
                                            FontWeight.w500,
                                            ConstantData.font18Px),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            );
                          },
                          itemCount: introModelList.length,
                          onPageChanged: _onPageViewChange,
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.all(defMargin),
                //   child: SmoothPageIndicator(
                //     controller: controller, // PageController
                //     count: introModelList.length,
                //
                //     effect: WormEffect(
                //         activeDotColor:
                //             ConstantData.primaryColor), // your preferred effect
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: defMargin * 2),
                  height: ConstantWidget.getScreenPercentSize(context, 15),
                  child: Center(
                    child: getButtonWidget(
                        context, s, ConstantData.primaryColor, () {
                      if (_position == 2) {
                        PrefData.setIsIntro(false);
                        Navigator.of(context).pop(true);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      } else {
                        _position++;
                        controller.jumpToPage(_position);
                        setState(() {});
                      }
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  Widget getButtonWidget(
      BuildContext context, String s, var color, Function function) {
    ConstantData.setThemePosition();
    double height = ConstantWidget.getScreenPercentSize(context, 8.5);
    double radius = ConstantWidget.getPercentSize(height, 50);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return InkWell(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
            vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        child: Center(
            child: ConstantWidget.getDefaultTextWidget(
                s,
                TextAlign.center,
                FontWeight.w500,
                fontSize,
                (color == ConstantData.primaryColor)
                    ? Colors.white
                    : ConstantData.mainTextColor)),
      ),
      onTap: function,
    );
  }

  _onPageViewChange(int page) {
    _position = page;

    // controller.jumpToPage(_position);

    if (_position == 2) {
      s = "Get Started";
    } else {
      s = S.of(context).continueText;
    }
    setState(() {});
  }
}

// class LinePathClass extends CustomClipper {
//   @override
//   Path getClip(Size size) {
//     // TODO: implement getClip
//     var path = new Path();
//     path.lineTo(0, 300);
//     path.lineTo(325, 0);
//     path.lineTo(size.width - 300, size.height - 500);
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper oldClipper) {
//     // TODO: implement shouldReclip
//     return false;
//   }
//
// }
