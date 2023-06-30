import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knitman/Registration.dart';
import 'package:knitman/TabWidgetAdmin.dart';
import 'package:knitman/TabWidgetRider.dart';

import 'ForgotPassword.dart';
import 'generated/l10n.dart';
import 'main.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/PrefData.dart';
import 'util/SizeConfig.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPage createState() {
    return _SignInPage();
  }
}

class _SignInPage extends State<SignInPage> {
  bool isRemember = false;
  int themeMode = 0;
  String signIn;
  TextEditingController textPhoneController = new TextEditingController();
  TextEditingController textPasswordController = new TextEditingController();

  Future<void> login() async {
    signIn = "";
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: false);
    FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: textPhoneController.text)
        .where('password', isEqualTo: textPasswordController.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      final source = (querySnapshot.metadata.isFromCache)
          ? "===================local cache"
          : "==========================server";
      print(source);
      querySnapshot.docs.forEach((doc) {
        print("email " + doc["phone"] + " Password " + doc["password"]);
        if (doc["phone"] == textPhoneController.text &&
            doc["password"] == textPasswordController.text) {
          signIn = doc["role"];
          print(signIn);
          print(doc["role"]);

          PrefData.setIsSignIn(true);
          PrefData.setPhoneNumber(doc["phone"]);
          PrefData.setEmail(doc["email"]);
          PrefData.setFirstName(doc["firstName"]);
          PrefData.setLastName(doc["lastName"]);
          PrefData.setUserId(doc["phone"]);

          if (signIn == "Customer") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ));
          } else if (signIn == "Driver") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Alert!!"),
                  content: new Text(
                      "Location Disclosure: This app collects location data in background to provide GPS information to the readingTechnology Company database. Click yes to accept and continue click No to refuse"),
                  actions: <Widget>[
                    TextButton(
                      child: new Text("Yes"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabWidgetRider(true),
                            ));
                      },
                    ),
                    TextButton(
                      child: new Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else if (signIn == "Admin") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Alert!!"),
                  content: new Text(
                      "Location Disclosure: This app collects location data in background to provide GPS information to the readingTechnology Company database. Click yes to accept and continue click No to refuse"),
                  actions: <Widget>[
                    TextButton(
                      child: new Text("Yes"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabWidgetadmin(true),
                            ));
                      },
                    ),
                    TextButton(
                      child: new Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Alert!!"),
                  content: new Text("incorrect username or password"),
                  actions: <Widget>[
                    TextButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Alert!!"),
                content: new Text("incorrect username or password"),
                actions: <Widget>[
                  TextButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    });
    print(signIn);
    if (signIn.isEmpty) {
      print("incorrect username/password");
      setState(() {});
    }
  }

  Future<bool> _requestPop() {
    Future.delayed(const Duration(milliseconds: 200), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });

    return new Future.value(true);
  }

  @override
  void initState() {
    super.initState();

    setTheme();
  }

  setTheme() async {
    themeMode = await PrefData.getThemeMode();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ConstantData.setThemePosition();

    double height = ConstantWidget.getScreenPercentSize(context, 18);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(
                  ConstantWidget.getScreenPercentSize(context, 2.5)),
              child: ListView(
                children: [
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2),
                  ),
                  Center(
                    child: Image.asset(
                      ConstantData.assetsPath + "logo.png",
                      height: height,
                    ),
                  ),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5),
                  ),
                  ConstantWidget.getTextWidget(
                      S.of(this.context).signIn,
                      ConstantData.mainTextColor,
                      TextAlign.center,
                      FontWeight.bold,
                      ConstantWidget.getScreenPercentSize(context, 4.2)),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2.5),
                  ),
                  ConstantWidget.getDefaultTextFiledWidget(
                      context, S.of(context).yourPhone, textPhoneController),
                  ConstantWidget.getPasswordTextFiled(
                      context, S.of(context).password, textPasswordController),
                  Row(
                    children: [
                      InkWell(
                        child: Icon(
                          isRemember
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: ConstantData.mainTextColor,
                          size: ConstantWidget.getScreenPercentSize(context, 3),
                        ),
                        onTap: () {
                          if (isRemember) {
                            isRemember = false;
                          } else {
                            isRemember = true;
                          }
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        width:
                            ConstantWidget.getScreenPercentSize(context, 0.5),
                      ),
                      ConstantWidget.getTextWidget(
                          S.of(context).rememberMe,
                          ConstantData.mainTextColor,
                          TextAlign.left,
                          FontWeight.w400,
                          ConstantWidget.getScreenPercentSize(context, 1.8)),
                      Expanded(
                        child: InkWell(
                          child: ConstantWidget.getTextWidget(
                            S.of(context).forgotPassword,
                            ConstantData.mainTextColor,
                            TextAlign.end,
                            FontWeight.w400,
                            ConstantWidget.getScreenPercentSize(context, 1.8),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ));
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 4),
                  ),
                  ConstantWidget.getButtonWidget(
                      context, S.of(context).signIn, ConstantData.primaryColor,
                      () {
                    //signIn = "";
                    login();
                  }),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical:
                            ConstantWidget.getScreenPercentSize(context, .5)),
                    child: Center(
                      child: ConstantWidget.getTextWidget(
                          S.of(context).or,
                          ConstantData.textColor,
                          TextAlign.center,
                          FontWeight.w300,
                          ConstantWidget.getScreenPercentSize(context, 1.8)),
                    ),
                  ),
                  ConstantWidget.getButtonWidget(
                      context, S.of(context).signUp, ConstantData.primaryColor,
                      () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Registration(),
                        ));
                  }),
                ],
              ),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }
}
