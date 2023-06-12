import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'generated/l10n.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/SizeConfig.dart';

class TermsConditionPage extends StatefulWidget {
  bool isCheck;
  TermsConditionPage(this.isCheck);

  @override
  _TermsConditionPage createState() {
    return _TermsConditionPage(isCheck);
  }
}

class _TermsConditionPage extends State<TermsConditionPage> {
  _TermsConditionPage(this.isCheck);
  bool isCheck;
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
    ConstantData.setThemePosition();

    double margin = ConstantWidget.getScreenPercentSize(context, 1.5);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ConstantData.primaryColor,
            title: ConstantWidget.getAppBarText(S.of(context).termsConditions),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: ConstantWidget.getAppBarIcon(),
                  onPressed: _requestPop,
                );
              },
            ),
          ),
          body: SingleChildScrollView(
              child: Column(children: [
            Container(
                margin: EdgeInsets.all(margin),
                child: Html(data: S.of(context).html_terms)),
            (isCheck)
                ? ConstantWidget.getBottomText(context, "Disagree", () {
                    Navigator.of(context).pop(false);
                  })
                : ConstantWidget.getBottomText(context, "Agree", () {
                    Navigator.of(context).pop(true);
                  })
          ])),
        ),
        onWillPop: _requestPop);
  }
}
