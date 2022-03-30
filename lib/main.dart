import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'IntroPage.dart';
import 'SignUpPage.dart';
import 'TabWidget.dart';
import 'generated/l10n.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/PrefData.dart';

Future<void> main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  //await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],
      debugShowCheckedModeBanner: false,
      title: 'kitman1',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: ConstantData.primaryColor,
        primaryColorDark: ConstantData.primaryColor,
        accentColor: ConstantData.accentColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    signInValue();

    setState(() {});
  }

  bool _isSignIn = false;
  bool _isIntro = false;

  void signInValue() async {
    _isSignIn = await PrefData.getIsSignIn();
    _isIntro = await PrefData.getIsIntro();

    ConstantData.setThemePosition();

    print("isSignIn--" + _isSignIn.toString());

    // SystemChrome.setSystemUIOverlayStyle((themMode == 0)
    //     ? SystemUiOverlayStyle.light
    //     : SystemUiOverlayStyle.dark);

    if (_isIntro) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IntroPage(),
          ));
    } else {
      if (!_isSignIn) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpPage(),
            ));
      } else {
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                // builder: (context) => PreferencePage(),
                // builder: (context) => SubmitOrderPage(),
                builder: (context) => TabWidget(false),
              ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          body: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 5),
                  ),

                  Image.asset(
                    ConstantData.assetsPath + "main_screen_icon.png",
                    height: ConstantWidget.getWidthPercentSize(context, 60),
                  ),
                  // height: ConstantWidget.getWidthPercentSize(context, 60),),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 5),
                  ),
                  ConstantWidget.getTextWidget(
                      "Express Delivery",
                      ConstantData.primaryColor,
                      TextAlign.center,
                      FontWeight.bold,
                      ConstantWidget.getWidthPercentSize(context, 7)),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 5),
                  ),

                  Container(
                    width: ConstantWidget.getWidthPercentSize(context, 20),
                    height: ConstantWidget.getScreenPercentSize(context, 7),
                    decoration: BoxDecoration(
                        color: ConstantData.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(
                            ConstantWidget.getScreenPercentSize(context, 15)))),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),

            // decoration: BoxDecoration(
            //   color: ConstantData.bgColor,
            //   image: DecorationImage(
            //     colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
            //     image: ExactAssetImage(ConstantData.assetsPath + "splash.jpg"),
            //     fit: BoxFit.cover,
            //   ),
            //
            // ),
          ),
        ),
        onWillPop: _requestPop);
  }

  Future<bool> _requestPop() {
    Future.delayed(const Duration(milliseconds: 200), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });

    return new Future.value(false);
  }
}
