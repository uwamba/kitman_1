import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'generated/l10n.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/SizeConfig.dart';

class AddNewAddressPage extends StatefulWidget {
  @override
  _AddNewAddressPage createState() {
    return _AddNewAddressPage();
  }
}

class _AddNewAddressPage extends State<AddNewAddressPage> {
  int _selectedRadio = 0;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController zipController = new TextEditingController();
  TextEditingController addController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double leftMargin = MediaQuery.of(context).size.width * 0.05;
    double topMargin = ConstantWidget.getScreenPercentSize(context, 1);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.primaryColor,
            title: ConstantWidget.getAppBarText(S.of(context).addressTitle),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: ConstantWidget.getAppBarIcon(),
                  onPressed: _requestPop,
                );
              },
            ),
          ),
          bottomNavigationBar:
              ConstantWidget.getBottomText(context, S.of(context).save, () {
            Navigator.of(context).pop(true);
          }),
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.all(leftMargin),
                        child: Column(
                          children: [
                            ConstantWidget.getDefaultTextFiledWidget(context,
                                S.of(context).yourName, nameController),
                            ConstantWidget.getDefaultTextFiledWidget(
                                context,
                                S.of(context).phoneNumber,
                                phoneNumberController),
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      ConstantWidget.getDefaultTextFiledWidget(
                                          context,
                                          S.of(context).cityDistrict,
                                          cityController),
                                  flex: 1,
                                ),
                                SizedBox(
                                  width: ConstantWidget.getScreenPercentSize(
                                      context, 1),
                                ),
                                Expanded(
                                  child:
                                      ConstantWidget.getDefaultTextFiledWidget(
                                          context,
                                          S.of(context).zip,
                                          zipController),
                                  flex: 1,
                                )
                              ],
                            ),
                            ConstantWidget.getPrescriptionDesc(context,
                                S.of(context).addressTitle, addController),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: topMargin, bottom: topMargin),
                              child: _radioView(S.of(context).houseApartment,
                                  (_selectedRadio == 0), 0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: topMargin, bottom: topMargin),
                              child: _radioView(S.of(context).agencyCompany,
                                  (_selectedRadio == 1), 1),
                            ),
                          ],
                        ),
                      )
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

  Widget _radioView(String s, bool isSelected, int position) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? ConstantData.textColor : Colors.grey,
            size: ConstantWidget.getScreenPercentSize(context, 2),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: ConstantWidget.getScreenPercentSize(context, 2.5)),
            child: Text(
              s,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontFamily: ConstantData.fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: ConstantData.font18Px,
                  color: ConstantData.mainTextColor),
            ),
          )
        ],
      ),
      onTap: () {
        if (position != _selectedRadio) {
          if (_selectedRadio == 0) {
            _selectedRadio = 1;
          } else {
            _selectedRadio = 0;
          }
        }
        setState(() {});
      },
    );
  }
}
