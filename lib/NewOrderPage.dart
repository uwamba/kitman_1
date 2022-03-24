import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'WeightPage.dart';
import 'generated/l10n.dart';
import 'model/NewOrderTypeModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class NewOrderPage extends StatefulWidget {
  @override
  _NewOrderPage createState() {
    return _NewOrderPage();
  }
}

class _NewOrderPage extends State<NewOrderPage> {
  List<NewOrderTypeModel> orderTypeList = DataFile.getOrderTypeList();

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              title: ConstantWidget.getAppBarText(S.of(context).newOrderType),
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
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: orderTypeList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                          height: height,
                          color: ConstantData.cellColor,
                          margin: EdgeInsets.only(bottom: margin),
                          padding: EdgeInsets.symmetric(horizontal: margin),
                          child: Row(
                            children: [
                              Container(
                                height: cellHeight,
                                width: cellHeight,
                                margin: EdgeInsets.only(right: margin),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ConstantWidget.getPercentSize(
                                          cellHeight, 20)),
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: ConstantWidget.getWidthPercentSize(
                                          context, 0.08)),
                                ),
                                padding: EdgeInsets.all(
                                    ConstantWidget.getPercentSize(
                                        cellHeight, 20)),
                                child: Image.asset(
                                  ConstantData.assetsPath +
                                      orderTypeList[index].image,
                                  color: ConstantData.primaryColor,
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
                                builder: (context) =>
                                    WeightPage(orderTypeList[index].title),
                              ));
                        },
                      );
                    },
                  )
                ],
              ),
            )),
        onWillPop: _requestPop);
  }
}
// we will assign delivery boy
