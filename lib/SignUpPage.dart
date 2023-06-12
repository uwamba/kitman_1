import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knitman/Database/Db.dart';
import 'package:knitman/PhoneVerification.dart';

import 'SignInPage.dart';
import 'TermsConditionPage.dart';
import 'generated/l10n.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/PrefData.dart';
import 'util/SizeConfig.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPage createState() {
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool isRemember = false;
  int themeMode = 0;
  double margin;
  double radius;
  bool term = false;
  int _totalNotifications;
  PushNotification _notificationInfo;
  TextEditingController textEmailController = new TextEditingController();
  TextEditingController textFirstNameController = new TextEditingController();
  TextEditingController textPasswordController = new TextEditingController();
  TextEditingController textPasswordConfirmController =
      new TextEditingController();
  TextEditingController textPhoneController = new TextEditingController();
  TextEditingController textLastNameController = new TextEditingController();

  bool isCheck = false;

  void registerNotification() async {
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<bool> _requestPop() {
    Future.delayed(const Duration(milliseconds: 200), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
    return new Future.value(false);
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
    Db db = new Db();
    String date = DateTime.now().toString();
    SizeConfig().init(context);
    margin = ConstantWidget.getScreenPercentSize(context, 2);
    // radius = ConstantWidget.getScreenPercentSize(context, 1.5);
    ConstantData.setThemePosition();

    double subHeight = ConstantWidget.getScreenPercentSize(context, 8.5);

    double radius = ConstantWidget.getPercentSize(subHeight, 20);
    double fontSize = ConstantWidget.getPercentSize(subHeight, 25);
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
                      S.of(context).signUp,
                      ConstantData.mainTextColor,
                      TextAlign.center,
                      FontWeight.bold,
                      ConstantWidget.getScreenPercentSize(context, 4.2)),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2.5),
                  ),
                  ConstantWidget.getDefaultTextFiledWidget(context,
                      S.of(context).yourPhoneNumber, textPhoneController),
                  ConstantWidget.getTextFiledWidget(
                      context, S.of(context).yourEmail, textEmailController),
                  ConstantWidget.getTextFiledWidget(context,
                      S.of(context).yourFirstName, textFirstNameController),
                  ConstantWidget.getTextFiledWidget(context,
                      S.of(context).yourLastName, textLastNameController),
                  ConstantWidget.getPasswordTextFiled(
                      context, S.of(context).password, textPasswordController),
                  ConstantWidget.getPasswordTextFiled(
                      context,
                      S.of(context).confirmPassword,
                      textPasswordConfirmController),
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          (isCheck)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.grey,
                          size: ConstantData.font18Px,
                        ),
                        SizedBox(
                          width: ConstantData.font12Px,
                        ),
                        ConstantWidget.getTextWidget(
                            "terms and conditions",
                            ConstantData.mainTextColor,
                            TextAlign.start,
                            FontWeight.w400,
                            ConstantData.font15Px)
                      ],
                    ),
                    onTap: () async {
                      isCheck = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsConditionPage(isCheck),
                          ));
                      print(isCheck);
                      setState(() {
                        if (isCheck) {
                          isCheck = true;
                        } else {
                          isCheck = false;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: ConstantData.font18Px,
                  ),
                  ConstantWidget.getButtonWidget(
                      context, S.of(context).signUp, ConstantData.primaryColor,
                      () {
                    String pas1 = textPasswordController.text;
                    String pas2 = textPasswordConfirmController.text;
                    if (pas1 == pas2) {
                      print("+++++++++++++++++++++++++++++++++"+textPhoneController.text);
                      db.signUp(
                          textPhoneController.text,
                          textEmailController.text,
                          textFirstNameController.text,
                          textLastNameController.text,
                          "Customer",
                          date,
                          textPasswordController.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PhoneVerification(textPhoneController.text),
                          ));
                    } else {
                      print("--------------------");
                      setState(() {
                        bottomDeliverDialog();
                      });
                    }
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstantWidget.getTextWidget(
                          S.of(context).youHaveAnAlreadyAccount,
                          ConstantData.mainTextColor,
                          TextAlign.left,
                          FontWeight.w500,
                          ConstantWidget.getScreenPercentSize(context, 1.8)),
                      SizedBox(
                        width:
                            ConstantWidget.getScreenPercentSize(context, 0.5),
                      ),
                      InkWell(
                        child: ConstantWidget.getTextWidget(
                            S.of(context).signIn,
                            ConstantData.primaryColor,
                            TextAlign.start,
                            FontWeight.bold,
                            ConstantWidget.getScreenPercentSize(context, 2)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ));
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: _requestPop);
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
                    S.of(context).error,
                    ConstantData.mainTextColor,
                    TextAlign.start,
                    FontWeight.w700,
                    ConstantWidget.getScreenPercentSize(context, 3)),
                widget,
                ConstantWidget.getCustomText(
                    "Password you entered not match try  again!.",
                    Colors.grey,
                    2,
                    TextAlign.start,
                    FontWeight.w500,
                    ConstantData.font18Px),
                widget,
                Divider(
                  height: ConstantWidget.getScreenPercentSize(context, 0.02),
                ),
                widget,
                widget,
                widget,
                widget,
                ConstantWidget.getBottomText(context, "Ok", () {
                  Navigator.pop(context);
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  getWeightCell() {
    double size = ConstantWidget.getScreenPercentSize(context, 4);
    return Container(
      height: size,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.all(
              Radius.circular(ConstantWidget.getPercentSize(size, 50)))),
      child: Row(
        children: [
          // Icon(
          //   Icons.,
          //   size: ConstantWidget.getPercentSize(size, 60),
          //   color: Colors.grey,
          // ),
          Image.asset(
            ConstantData.assetsPath + "weight_icon.png",
            height: ConstantWidget.getPercentSize(size, 60),
            color: Colors.grey,
          ),
          SizedBox(
            width: (margin / 3),
          ),
          Image.asset(
            ConstantData.assetsPath + "weight_icon.png",
            height: ConstantWidget.getPercentSize(size, 60),
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  getCircleCell(var color, var icon) {
    double size = ConstantWidget.getScreenPercentSize(context, 4);
    return Container(
      height: size,
      width: size,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.2)),
      child: Center(
        child: Icon(
          icon,
          size: ConstantWidget.getPercentSize(size, 60),
          color: color,
        ),
      ),
    );
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String title;
  String body;
}
