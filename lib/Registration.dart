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

class Registration extends StatefulWidget {
  @override
  _Registration createState() {
    return _Registration();
  }
}

class _Registration extends State<Registration> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool isRemember = false;
  int themeMode = 0;
  int _totalNotifications;
  PushNotification _notificationInfo;
  TextEditingController textEmailController = new TextEditingController();
  TextEditingController textFirstNameController = new TextEditingController();
  TextEditingController textPasswordController = new TextEditingController();
  TextEditingController textPasswordConfirmController =
      new TextEditingController();
  TextEditingController textPhoneController = new TextEditingController();
  TextEditingController textLastNameController = new TextEditingController();
  TextEditingController textRoleController = new TextEditingController();

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
                      context, S.of(context).Role, textRoleController),
                  ConstantWidget.getTextFiledWidget(
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
                    onTap: () {
                      // setState(() {
                      //   if (isCheck) {
                      //     isCheck = false;
                      //   } else {
                      //     isCheck = true;
                      //   }
                      //
                      // });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsConditionPage(),
                          ));
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
                      print("+++++++++++++++++++++++++++++++++");
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
                            builder: (context) => PhoneVerification(),
                          ));
                    } else {
                      print("--------------------");
                      setState(() {
                        AlertDialog(
                          title: const Text('AlertDialog Title'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const <Widget>[
                                Text('This is a demo alert dialog.'),
                                Text(
                                    'Would you like to approve of this message?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Approve'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
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
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String title;
  String body;
}
