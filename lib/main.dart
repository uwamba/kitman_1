import 'dart:async';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:knitman/util/PrefData.dart';

import 'Database/Db.dart';
import 'IntroPage.dart';
import 'SignInPage.dart';
import 'TabWidget.dart';
import 'generated/l10n.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().whenComplete(() {
    FirebaseFirestore.instance.clearPersistence();
  });
  // WidgetsFlutterBinding.ensureInitialized();

  //Firebase.onBackgroundFirestore(_firebaseMessagingBackgroundHandler);
  initializeService();
  runApp(MyApp());
}

Future<void> _firebaseBackgroundHandler() async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  Db db = new Db();
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('orders');

  collectionRef.snapshots().listen((querySnapshot) {
    querySnapshot?.docChanges?.forEach(
      (docChange) => {
        if (docChange.type.toString() == "DocumentChangeType.added")
          {print("document added")},
        print("document changed"),
        print(docChange.type),
        print(docChange.doc.get("status"))
        //db.addNotification("from", "to", "text", "action")
        // If you need to do something for each document change, do it here.
      },
    );
    // Anything you might do every time you get a fresh snapshot can be done here.

    print(
        "background changeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
  });

  print("Handling a background message:");
}

Future<void> initializeService() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //Firebase.initializeApp();
  // WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
  _firebaseBackgroundHandler();
}

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();

  print('FLUTTER BACKGROUND FETCH');

  return true;
}

Future<void> onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Notification",
        content: "Updated at ${DateTime.now()}",
      );
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
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
              builder: (context) => SignInPage(),
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
