import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knitman/Database/Db.dart';
import 'package:knitman/Database/UserPresence.dart';
import 'package:knitman/NearDrivers.dart';
import 'package:knitman/OrderDetails.dart';
import 'package:knitman/Registration.dart';
import 'package:knitman/UsersList.dart';
import 'package:knitman/model/onlineUser.dart';
import 'package:knitman/model/orderList.dart';
import 'package:location/location.dart';
import 'package:timelines/timelines.dart';

import 'AboutUsPage.dart';
import 'ChatScreen.dart';
import 'CompleteOrderDetail.dart';
import 'DriverMap.dart';
import 'EditProfilePage.dart';
import 'NotificationPage.dart';
import 'OrderMap.dart';
import 'ResetPasswordPage.dart';
import 'SchedulePage.dart';
import 'TermsConditionPage.dart';
import 'TrackOrderPage.dart';
import 'customWidget/MotionTabBarView.dart';
import 'customWidget/MotionTabController.dart';
import 'customWidget/motiontabbar.dart';
import 'generated/l10n.dart';
import 'main.dart';
import 'model/ActiveOrderModel.dart';
import 'model/ChatModel.dart';
import 'model/CompletedOrderModel.dart';
import 'model/Message.dart';
import 'model/NewOrderTypeModel.dart';
import 'model/ProfileModel.dart';
import 'model/TimeLineModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/PrefData.dart';
import 'util/SizeConfig.dart';

class TabWidgetadmin extends StatefulWidget {
  final bool isDataShow;
  TabWidgetadmin(this.isDataShow);

  @override
  _TabWidget createState() {
    return _TabWidget();
  }
}

class _TabWidget extends State<TabWidgetadmin> with TickerProviderStateMixin {
  MotionTabBar motionTabBar;
  MotionTabController _tabController;
  int _selectedIndex = 0;
  List<OrderList> activeOrderListModel;
  List<ChatModel> chatUserList = DataFile.getChatUserList();
  List<TimeLineModel> timeLineModel = [];
  int tabPosition = 0;

  List<String> s = ["New Orders", "Active Orders", "Driver", "Profile"];
  List<NewOrderTypeModel> orderTypeList = DataFile.getOrderTypeList();
  List<CompletedOrderModel> completeOrderList = DataFile.getCompleteOrder();
  List<ActiveOrderModel> activeOrderList = DataFile.getActiveOrderList();
  String phone;
  bool isAppbarVisible = true;
  String presence;
  int themMode;
  bool isFirstTime = false;
  Location location = new Location();
  getThemeMode() async {
    isFirstTime = await PrefData.getIsFirstTime();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor:
            (themMode == 1) ? ConstantData.bgColor : ConstantData.bgColor));
    themMode = await PrefData.getThemeMode();
    ConstantData.setThemePosition();
    setState(() {});
  }

  void setLocation() async {
    phone = await PrefData.getPhoneNumber();
    String email = await PrefData.getEmail();
    String lastName = await PrefData.getLastName();
    String firstName = await PrefData.getFirstName();
    GeoPoint location = await getLocation();
    UserPresence(phone, email, lastName, firstName, location)
        .updateUserLocation();
  }

  void setUserData() async {
    phone = await PrefData.getPhoneNumber();
    String email = await PrefData.getEmail();
    String lastName = await PrefData.getLastName();
    String firstName = await PrefData.getFirstName();
    GeoPoint location = await getLocation();
    UserPresence(phone, email, lastName, firstName, location)
        .updateUserPresence();
  }

  locationService() {
    // Request permission to use location
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            print("location changed");
            setLocation();
          }
        });
      }
    });
  }

  Future<GeoPoint> getLocation() async {
    GeoPoint _currentLocation;
    try {
      var userLocation = await location.getLocation();
      _currentLocation = GeoPoint(
        userLocation.latitude,
        userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }

  @override
  void initState() {
    // TODO: implement initState

    setUserData();
    locationService();
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('orders');
    Db db = new Db();
    collectionRef.snapshots().listen((querySnapshot) {
      setState(() {
        querySnapshot?.docChanges?.forEach(
          (docChange) => {
            // If you need to do something for each document change, do it here.
          },
        );
        // Anything you might do every time you get a fresh snapshot can be done here.
        db.activeOrderList();
        print("changeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      });
    });
    getThemeMode();
    _tabController = new MotionTabController(
        initialIndex: _selectedIndex, length: s.length, vsync: this);
    super.initState();
  }

  List<TimeLineModel> processes;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ConstantData.setThemePosition();
    setUserData();
    locationService();
    motionTabBar = new MotionTabBar(
      labels: ["New Orders", "Active Orders", "Driver", "Profile"],
      initialSelectedTab: s[_selectedIndex],
      tabIconColor: ConstantData.mainTextColor,
      tabSelectedColor: ConstantData.primaryColor,
      selectedIndex: _selectedIndex,
      onTabItemSelected: (int value) {
        print(value);
        setState(() {
          _tabController.index = value;
          _selectedIndex = value;
        });
      },
      icons: [
        "bottom_icon_1.png",
        "bottom_icon_2.png",
        "bottom_icon_3.png",
        "bottom_icon_4.png",
        //"Icons.category",
        // "Icons.add_box_outlined",
        // "Icons.message_outlined",
        // "Icons.account_box",
      ],
      textStyle: TextStyle(
          color: ConstantData.mainTextColor,
          fontWeight: FontWeight.w500,
          fontSize: ConstantWidget.getWidthPercentSize(context, 3.5),
          fontFamily: ConstantData.fontFamily),
    );

    return WillPopScope(
        child: Scaffold(
          // backgroundColor: Colors.red,
          backgroundColor: ConstantData.bgColor,
          bottomNavigationBar: motionTabBar,
          body: Container(
            // child: SafeArea(
            child: MotionTabBarView(
              controller: _tabController,
              children: <Widget>[
                Container(
                  child: orderPage(),
                ),
                Container(
                  child: orderPage2(),
                ),
                Container(
                  child: getChatPage(),
                ),
                Container(
                  child: getProfilePage(),
                ),
              ],
            ),
          ),
          // ),
        ),
        onWillPop: _requestPop);
  }

  getChatPage() {
    double leftMargin = MediaQuery.of(context).size.width * 0.04;
    double height = ConstantWidget.getScreenPercentSize(context, 15);
    double imageSize = ConstantWidget.getPercentSize(height, 60);
    final usersQuery = FirebaseDatabase.instance.ref('presence');
    Db db = new Db();
    return Container(
      color: ConstantData.bgColor,
      padding: EdgeInsets.only(
        top: (leftMargin),
        bottom: MediaQuery.of(context).size.width * 0.01,
      ),
      // margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.01),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: leftMargin, bottom: leftMargin),
              child: ConstantWidget.getTextWidget(
                  S.of(context).drivers,
                  ConstantData.mainTextColor,
                  TextAlign.start,
                  FontWeight.w800,
                  ConstantWidget.getScreenPercentSize(context, 2.5)),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                shrinkWrap: true,
                query: usersQuery,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  List<onlineUser> ls;
                  final parsed =
                      snapshot.children.map((doc) => doc.value).toList();

                  List lis = parsed.toList();

                  return chatCellUser(lis, index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  DateTime convertToTime(int time) {
    //DateFormat formatter = DateFormat('yyyyMMddHHmmssms');
    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  Widget chatCell(ChatModel chatModel, int index) {
    double allMargin = ConstantWidget.getScreenPercentSize(context, 1);
    double height = ConstantWidget.getScreenPercentSize(context, 13);

    double imageSize = ConstantWidget.getPercentSize(height, 60);

    return InkWell(
      child: Container(
        height: height,
        color: ConstantData.cellColor,
        margin: EdgeInsets.symmetric(
            horizontal: (allMargin / 1.6), vertical: (allMargin / 3.5)),
        padding: EdgeInsets.symmetric(
            horizontal: allMargin, vertical: ((allMargin))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: (allMargin * 3)),
                  height: imageSize,
                  width: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: ExactAssetImage(
                          ConstantData.assetsPath + chatModel.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Visibility(
                  child: Positioned.fill(
                      child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: (allMargin * 2), right: (allMargin / 3)),
                      child: Container(
                        height: ConstantWidget.getPercentSize(height, 18),
                        width: ConstantWidget.getPercentSize(height, 18),
                        padding: EdgeInsets.all((allMargin / 2)),
                        decoration: BoxDecoration(
                            color: ConstantData.cellColor,
                            shape: BoxShape.circle),
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: (chatModel.active == 1)
                                  ? Colors.green
                                  : Colors.red,
                              shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  )),
                  visible: (chatModel.active == 1),
                )
              ],
            ),
            SizedBox(
              width: (allMargin * 3),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ConstantWidget.getCustomText(
                              chatModel.name,
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.start,
                              FontWeight.bold,
                              ConstantWidget.getPercentSize(height, 16)),
                          new Spacer(),
                          ConstantWidget.getCustomText(
                              chatModel.time,
                              ConstantData.textColor,
                              1,
                              TextAlign.start,
                              FontWeight.w700,
                              ConstantWidget.getPercentSize(height, 14)),
                        ],
                      ),
                      SizedBox(
                        height: ConstantWidget.getPercentSize(height, 6),
                      ),
                      ConstantWidget.getCustomText(
                          chatModel.desc,
                          ConstantData.textColor,
                          2,
                          TextAlign.start,
                          FontWeight.w400,
                          ConstantWidget.getPercentSize(height, 14)),
                    ],
                  )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                user: chats[0].sender,
                chatModel: chatModel,
              ),
            ));
      },
    );
  }

  Widget chatCellUser(List users, int index) {
    double allMargin = ConstantWidget.getScreenPercentSize(context, 1);
    double height = ConstantWidget.getScreenPercentSize(context, 13);

    double imageSize = ConstantWidget.getPercentSize(height, 60);
    return InkWell(
      child: Container(
        height: height,
        color: ConstantData.cellColor,
        margin: EdgeInsets.symmetric(
            horizontal: (allMargin / 1.6), vertical: (allMargin / 3.5)),
        padding: EdgeInsets.symmetric(
            horizontal: allMargin, vertical: ((allMargin))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: (allMargin * 3)),
                  height: imageSize,
                  width: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    image: DecorationImage(
                      image:
                          ExactAssetImage(ConstantData.assetsPath + "hugh.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Visibility(
                  child: Positioned.fill(
                      child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: (allMargin * 2), right: (allMargin / 3)),
                      child: Container(
                        height: ConstantWidget.getPercentSize(height, 18),
                        width: ConstantWidget.getPercentSize(height, 18),
                        padding: EdgeInsets.all((allMargin / 2)),
                        decoration: BoxDecoration(
                            color: ConstantData.cellColor,
                            shape: BoxShape.circle),
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: (true) ? Colors.green : Colors.red,
                              shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  )),
                  visible: (users[7]),
                )
              ],
            ),
            SizedBox(
              width: (allMargin * 3),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ConstantWidget.getCustomText(
                              users[0].toString(),
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.start,
                              FontWeight.bold,
                              ConstantWidget.getPercentSize(height, 13)),
                        ],
                      ),
                      SizedBox(
                        height: ConstantWidget.getPercentSize(height, 6),
                      ),
                      Row(
                        children: [
                          ConstantWidget.getCustomText(
                              users[3].toString() + "  " + users[1].toString(),
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.start,
                              FontWeight.bold,
                              ConstantWidget.getPercentSize(height, 13)),
                        ],
                      ),
                      SizedBox(
                        height: ConstantWidget.getPercentSize(height, 6),
                      ),
                      ConstantWidget.getCustomText(
                          convertToTime(users[4]).toString(),
                          ConstantData.textColor,
                          2,
                          TextAlign.start,
                          FontWeight.w400,
                          ConstantWidget.getPercentSize(height, 13)),
                      SizedBox(
                        height: ConstantWidget.getPercentSize(height, 6),
                      ),
                      Row(
                        children: [
                          ConstantWidget.getCustomText(
                              users[2].toString(),
                              ConstantData.mainTextColor,
                              1,
                              TextAlign.start,
                              FontWeight.bold,
                              ConstantWidget.getPercentSize(height, 13)),
                        ],
                      )
                    ],
                  )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DriverMap(),
            ));
      },
    );
  }

  orderPage() {
    double appbarHeight = ConstantWidget.getScreenPercentSize(context, 8);
    return Container(
      color: ConstantData.primaryColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: appbarHeight,
              color: ConstantData.primaryColor,
              padding: EdgeInsets.only(right: ConstantData.font15Px),
              child: Stack(
                children: [
                  Center(
                    child: ConstantWidget.getTextWidget(
                        S.of(context).orders,
                        Colors.white,
                        TextAlign.center,
                        FontWeight.w600,
                        ConstantData.font22Px),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(left: (ConstantData.font15Px)),
                        child: Icon(
                          Icons.notifications,
                          size: ConstantWidget.getPercentSize(appbarHeight, 50),
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NearDrivers(),
                            ));
                      },
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          ConstantData.assetsPath + "delivery.png",
                          height:
                              ConstantWidget.getPercentSize(appbarHeight, 50),
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: ConstantData.font15Px,
                        ),
                        InkWell(
                          child: ConstantWidget.getTextWidget(
                              S.of(context).tracknorder,
                              Colors.white,
                              TextAlign.center,
                              FontWeight.w400,
                              ConstantData.font18Px),
                          onTap: () {
                            //Navigator.push(
                            //  context,
                            //  MaterialPageRoute(
                            //    builder: (context) => TrackOrderPage(),
                            //  ));
                          },
                        ),
                        SizedBox(
                          width: ConstantData.font15Px,
                        ),
                        // Icon(
                        //   Icons.info_outlined,
                        //   size: ConstantWidget.getPercentSize(appbarHeight, 50),
                        //   color: Colors.white,
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: appbarHeight,
                color: ConstantData.cellColor,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        getTabWidget(S.of(context).unassigned, 0),
                        getTabWidget(S.of(context).assigned, 1),
                      ],
                    )
                  ],
                )),
            Expanded(
                child: Container(
              color: ConstantData.bgColor,
              child: (tabPosition == 0)
                  ? tabUnassignedWidget()
                  : tabAssignedWidget(),
            ))
          ],
        ),
      ),
    );
  }

  orderPage2() {
    double appbarHeight = ConstantWidget.getScreenPercentSize(context, 8);
    return Container(
      color: ConstantData.primaryColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: appbarHeight,
              color: ConstantData.primaryColor,
              padding: EdgeInsets.only(right: ConstantData.font15Px),
              child: Stack(
                children: [
                  Center(
                    child: ConstantWidget.getTextWidget(
                        S.of(context).orders,
                        Colors.white,
                        TextAlign.center,
                        FontWeight.w600,
                        ConstantData.font22Px),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(left: (ConstantData.font15Px)),
                        child: Icon(
                          Icons.notifications,
                          size: ConstantWidget.getPercentSize(appbarHeight, 50),
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        //  Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //    builder: (context) => NearDrivers(),
                        //  ));
                      },
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          ConstantData.assetsPath + "delivery.png",
                          height:
                              ConstantWidget.getPercentSize(appbarHeight, 50),
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: ConstantData.font15Px,
                        ),
                        InkWell(
                          child: ConstantWidget.getTextWidget(
                              S.of(context).tracknorder,
                              Colors.white,
                              TextAlign.center,
                              FontWeight.w400,
                              ConstantData.font18Px),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrackOrderPage(),
                                ));
                          },
                        ),
                        SizedBox(
                          width: ConstantData.font15Px,
                        ),
                        // Icon(
                        //   Icons.info_outlined,
                        //   size: ConstantWidget.getPercentSize(appbarHeight, 50),
                        //   color: Colors.white,
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: appbarHeight,
                color: ConstantData.cellColor,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        getTabWidget(S.of(context).active, 0),
                        getTabWidget(S.of(context).completed, 1),
                      ],
                    )
                  ],
                )),
            Expanded(
                child: Container(
              color: ConstantData.bgColor,
              child:
                  (tabPosition == 0) ? tabActiveWidget() : tabCompletedWidget(),
            ))
          ],
        ),
      ),
    );
  }

  getDecoration() {
    return BoxDecoration(
        color: ConstantData.cellColor,
        borderRadius: BorderRadius.circular(
            ConstantWidget.getScreenPercentSize(context, 2)),
        boxShadow: [
          BoxShadow(
              color: ConstantData.shadowColor.withOpacity(0.2),
              blurRadius: 2,
              offset: Offset(0, 2),
              spreadRadius: 1)
        ]);
  }

  onItemChanged(String value) {
    Db db = new Db();
    List<OrderList> newDataList = List.from(db.completeOrderList);
    setState(() {
      newDataList = newDataList
          .where((element) => element.orderNumber.contains(value))
          .toList();
    });
  }

  tabCompletedWidget() {
    Db db = new Db();
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = ConstantWidget.getScreenPercentSize(context, 5);

    double fontSize = ConstantWidget.getScreenPercentSize(context, 1.8);
    double defMargin = ConstantWidget.getScreenPercentSize(context, 2);
    return Container(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  bottom: (defMargin / 2),
                  right: defMargin,
                  left: defMargin,
                  top: defMargin),
              child: Container(
                  decoration: getDecoration(),
                  child: Padding(
                      padding: EdgeInsets.only(left: (defMargin / 2)),
                      child: TextFormField(
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: ConstantData.fontFamily,
                              color: ConstantData.mainTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: fontSize),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search..",
                            hintStyle: TextStyle(
                                fontFamily: ConstantData.fontFamily,
                                color: ConstantData.mainTextColor,
                                fontWeight: FontWeight.w400,
                                fontSize: fontSize),
                          ))))),
          Expanded(
            child: FutureBuilder<List<OrderList>>(
              builder: (context, orderSnap) {
                if (!orderSnap.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: orderSnap.data.length,
                    itemBuilder: (context, index) {
                      //OrderList listModel = orderSnap.data[index];
                      return InkWell(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: (margin / 2), horizontal: margin),
                          padding: EdgeInsets.all((margin / 1.5)),
                          decoration: getDecoration(),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: ConstantWidget.getCustomText(
                                            orderSnap.data[index].receivedTime,
                                            Colors.grey,
                                            2,
                                            TextAlign.start,
                                            FontWeight.w500,
                                            ConstantData.font15Px)),
                                    Container(
                                      color: ConstantData.primaryColor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: (margin / 2)),
                                      child: ConstantWidget.getCustomText(
                                          orderSnap.data[index].status,
                                          Colors.white,
                                          1,
                                          TextAlign.start,
                                          FontWeight.w500,
                                          ConstantData.font18Px),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: (margin / 2),
                                ),
                                ConstantWidget.getCustomText(
                                    orderSnap.data[index].deliveryDate,
                                    ConstantData.mainTextColor,
                                    1,
                                    TextAlign.start,
                                    FontWeight.bold,
                                    ConstantData.font22Px),
                                SizedBox(
                                  height: (margin / 2),
                                ),
                                ConstantWidget.getCustomText(
                                    "Courier: " +
                                        orderSnap.data[index].driverNumber
                                            .toString(),
                                    Colors.grey,
                                    2,
                                    TextAlign.start,
                                    FontWeight.w500,
                                    ConstantData.font18Px),
                                SizedBox(
                                  height: (margin / 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompleteOrderDetail(
                                    DataFile.getActiveOrderList()[0]),
                              ));
                        },
                      );
                    },
                  );
                }
              },
              future: db.completedOrderList(),
            ),
          )
        ],
      ),
    );
  }

  tabActiveWidget() {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double allMargin = ConstantWidget.getScreenPercentSize(context, 1);
    double height = ConstantWidget.getScreenPercentSize(context, 13);

    double imageSize = ConstantWidget.getPercentSize(height, 60);
    Db db = new Db();
    PrefData.setIsFirstTime(false);

    if (!widget.isDataShow) {
      return Container(
        width: double.infinity,
        margin:
            EdgeInsets.symmetric(horizontal: margin, vertical: (margin / 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidget.getTextWidget(
                S.of(context).noActiveOrdersAtTheMoment,
                Colors.grey,
                TextAlign.start,
                FontWeight.w400,
                ConstantData.font18Px),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: getActivityButton(
                      S.of(context).sendPackage,
                      S
                          .of(context)
                          .deliverOrReceiveItemsSuchAsGiftsdocumentskeys,
                      "package.png",
                      ConstantData.accentColor),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchedulePage(false),
                        ));
                  },
                ),
                /*InkWell(
                  child: getActivityButton(
                      S.of(context).buyFromStorage,
                      S.of(context).haveYourOrderBoughtAndDeliveredFromAnyStore,
                      "shopping-cart.png",
                      ConstantData.mainTextColor),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchedulePage(false),
                        ));
                  },
                ), */
                InkWell(
                  child: getActivityButton(
                      S.of(context).iAmRecipient,
                      S.of(context).trackAnIncomingDeliverITheApp,
                      "location_1.png",
                      ConstantData.mainTextColor),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackOrderPage(),
                        ));
                  },
                )
              ],
            ))
          ],
        ),
      );
    } else {
      return Container(
        color: ConstantData.bgColor,
        width: double.infinity,
        child: FutureBuilder<List<OrderList>>(
          builder: (context, orderSnap) {
            if (!orderSnap.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: orderSnap.data.length,
                itemBuilder: (context, index) {
                  //OrderList listModel = orderSnap.data[index];
                  timeLineModel.clear();
                  TimeLineModel model = new TimeLineModel();
                  model.text = "From: " + orderSnap.data[index].senderLocation;
                  model.contact = orderSnap.data[index].senderPhone;
                  model.isComplete = true;
                  timeLineModel.add(model);

                  TimeLineModel model2 = new TimeLineModel();
                  model2.text = "To: " + orderSnap.data[index].receiverLocation;
                  model2.contact = orderSnap.data[index].receiverPhone;
                  model2.isComplete = true;
                  timeLineModel.add(model2);

                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.all(margin),
                      color: ConstantData.cellColor,
                      margin: EdgeInsets.only(
                          bottom:
                              ConstantWidget.getScreenPercentSize(context, 1)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ConstantWidget.getTextWidget(
                                  orderSnap.data[index].orderNumber,
                                  ConstantData.mainTextColor,
                                  TextAlign.start,
                                  FontWeight.w400,
                                  ConstantData.font22Px),
                              new Spacer(),
                              ConstantWidget.getTextWidget(
                                  orderSnap.data[index].deliveryDate,
                                  Colors.grey,
                                  TextAlign.start,
                                  FontWeight.w400,
                                  ConstantData.font15Px),
                            ],
                          ),
                          SizedBox(
                            height: (margin / 1.5),
                          ),
                          Row(children: [
                            ConstantWidget.getTextWidget(
                                "Price: " + orderSnap.data[index].price,
                                ConstantData.mainTextColor,
                                TextAlign.start,
                                FontWeight.w400,
                                ConstantData.font18Px),
                          ]),
                          SizedBox(
                            height: (margin / 1.5),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ConstantWidget.getTextWidget(
                                    orderSnap.data[index].packageWeight,
                                    Colors.green,
                                    TextAlign.start,
                                    FontWeight.w400,
                                    ConstantData.font18Px),
                              ),
                              InkWell(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: (allMargin * 3)),
                                  height: imageSize * 0.80,
                                  width: imageSize * 0.80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: ExactAssetImage(
                                          ConstantData.assetsPath +
                                              "track_order.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  String driverId = await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new OrderMap(
                                                  orderSnap
                                                      .data[index].orderNumber,
                                                  orderSnap.data[index]
                                                      .driverNumber)));
                                  print(
                                      "driverrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr" +
                                          driverId);
                                  db.updateOrder(
                                      orderSnap.data[index].orderNumber,
                                      driverId);
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: (margin / 1.5),
                          ),
                          _DeliveryProcesses(
                            processes: timeLineModel,
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      activeOrderListModel = await db.activeOrderList();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActiveOrderDetail(
                                activeOrderListModel.elementAt(index)),
                          ));
                    },
                  );
                },
              );
            }
          },
          future: db.adminActiveOrderList(),
        ),
      );
    }
  }

  tabUnassignedWidget() {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double allMargin = ConstantWidget.getScreenPercentSize(context, 1);
    double height = ConstantWidget.getScreenPercentSize(context, 13);

    double imageSize = ConstantWidget.getPercentSize(height, 60);
    Db db = new Db();
    PrefData.setIsFirstTime(false);

    if (!widget.isDataShow) {
      return Container(
        width: double.infinity,
        margin:
            EdgeInsets.symmetric(horizontal: margin, vertical: (margin / 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidget.getTextWidget(
                S.of(context).noActiveOrdersAtTheMoment,
                Colors.grey,
                TextAlign.start,
                FontWeight.w400,
                ConstantData.font18Px),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: getActivityButton(
                      S.of(context).sendPackage,
                      S
                          .of(context)
                          .deliverOrReceiveItemsSuchAsGiftsdocumentskeys,
                      "package.png",
                      ConstantData.accentColor),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchedulePage(false),
                        ));
                  },
                ),
                /*InkWell(
                  child: getActivityButton(
                      S.of(context).buyFromStorage,
                      S.of(context).haveYourOrderBoughtAndDeliveredFromAnyStore,
                      "shopping-cart.png",
                      ConstantData.mainTextColor),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchedulePage(false),
                        ));
                  },
                ), */
                InkWell(
                  child: getActivityButton(
                      S.of(context).iAmRecipient,
                      S.of(context).trackAnIncomingDeliverITheApp,
                      "location_1.png",
                      ConstantData.mainTextColor),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackOrderPage(),
                        ));
                  },
                )
              ],
            ))
          ],
        ),
      );
    } else {
      return Container(
        color: ConstantData.bgColor,
        width: double.infinity,
        child: FutureBuilder<List<OrderList>>(
          builder: (context, orderSnap) {
            if (!orderSnap.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: orderSnap.data.length,
                itemBuilder: (context, index) {
                  //OrderList listModel = orderSnap.data[index];
                  timeLineModel.clear();
                  TimeLineModel model = new TimeLineModel();
                  model.text = "From: " + orderSnap.data[index].senderLocation;
                  model.contact = orderSnap.data[index].senderPhone;
                  model.isComplete = true;
                  timeLineModel.add(model);

                  TimeLineModel model2 = new TimeLineModel();
                  model2.text = "To: " + orderSnap.data[index].receiverLocation;
                  model2.contact = orderSnap.data[index].receiverPhone;
                  model2.isComplete = true;
                  timeLineModel.add(model2);

                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.all(margin),
                      color: ConstantData.cellColor,
                      margin: EdgeInsets.only(
                          bottom:
                              ConstantWidget.getScreenPercentSize(context, 1)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ConstantWidget.getTextWidget(
                                  orderSnap.data[index].orderNumber,
                                  ConstantData.mainTextColor,
                                  TextAlign.start,
                                  FontWeight.w400,
                                  ConstantData.font22Px),
                              new Spacer(),
                              ConstantWidget.getTextWidget(
                                  orderSnap.data[index].deliveryDate,
                                  Colors.grey,
                                  TextAlign.start,
                                  FontWeight.w400,
                                  ConstantData.font15Px),
                            ],
                          ),
                          SizedBox(
                            height: (margin / 1.5),
                          ),
                          Row(children: [
                            ConstantWidget.getTextWidget(
                                "Price: " + orderSnap.data[index].price,
                                ConstantData.mainTextColor,
                                TextAlign.start,
                                FontWeight.w400,
                                ConstantData.font18Px),
                          ]),
                          SizedBox(
                            height: (margin / 1.5),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ConstantWidget.getTextWidget(
                                    orderSnap.data[index].packageWeight,
                                    Colors.green,
                                    TextAlign.start,
                                    FontWeight.w400,
                                    ConstantData.font18Px),
                              ),
                              InkWell(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: (allMargin * 3)),
                                  height: imageSize * 0.60,
                                  width: imageSize * 0.60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: ExactAssetImage(
                                          ConstantData.assetsPath +
                                              "assign.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  String driverId = await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new NearDrivers()));
                                  print(
                                      "driverrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr" +
                                          driverId);
                                  db.updateOrder(
                                      orderSnap.data[index].orderNumber,
                                      driverId);
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: (margin / 1.5),
                          ),
                          _DeliveryProcesses(
                            processes: timeLineModel,
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      activeOrderListModel = await db.activeOrderList();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActiveOrderDetail(
                                activeOrderListModel.elementAt(index)),
                          ));
                    },
                  );
                },
              );
            }
          },
          future: db.unassignedList(),
        ),
      );
    }
  }

  tabAssignedWidget() {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
    double allMargin = ConstantWidget.getScreenPercentSize(context, 1);
    double height = ConstantWidget.getScreenPercentSize(context, 13);

    double imageSize = ConstantWidget.getPercentSize(height, 60);
    Db db = new Db();
    PrefData.setIsFirstTime(false);

    if (!widget.isDataShow) {
      return Container(
        width: double.infinity,
        margin:
            EdgeInsets.symmetric(horizontal: margin, vertical: (margin / 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidget.getTextWidget(
                S.of(context).noActiveOrdersAtTheMoment,
                Colors.grey,
                TextAlign.start,
                FontWeight.w400,
                ConstantData.font18Px),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: getActivityButton(
                      S.of(context).sendPackage,
                      S
                          .of(context)
                          .deliverOrReceiveItemsSuchAsGiftsdocumentskeys,
                      "package.png",
                      ConstantData.accentColor),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchedulePage(false),
                        ));
                  },
                ),
                /*InkWell(
                  child: getActivityButton(
                      S.of(context).buyFromStorage,
                      S.of(context).haveYourOrderBoughtAndDeliveredFromAnyStore,
                      "shopping-cart.png",
                      ConstantData.mainTextColor),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchedulePage(false),
                        ));
                  },
                ), */
                InkWell(
                  child: getActivityButton(
                      S.of(context).iAmRecipient,
                      S.of(context).trackAnIncomingDeliverITheApp,
                      "location_1.png",
                      ConstantData.mainTextColor),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackOrderPage(),
                        ));
                  },
                )
              ],
            ))
          ],
        ),
      );
    } else {
      return Container(
        color: ConstantData.bgColor,
        width: double.infinity,
        child: FutureBuilder<List<OrderList>>(
          builder: (context, orderSnap) {
            if (!orderSnap.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: orderSnap.data.length,
                itemBuilder: (context, index) {
                  //OrderList listModel = orderSnap.data[index];
                  timeLineModel.clear();
                  TimeLineModel model = new TimeLineModel();
                  model.text = "From: " + orderSnap.data[index].senderLocation;
                  model.contact = orderSnap.data[index].senderPhone;
                  model.isComplete = true;
                  timeLineModel.add(model);

                  TimeLineModel model2 = new TimeLineModel();
                  model2.text = "To: " + orderSnap.data[index].receiverLocation;
                  model2.contact = orderSnap.data[index].receiverPhone;
                  model2.isComplete = true;
                  timeLineModel.add(model2);

                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.all(margin),
                      color: ConstantData.cellColor,
                      margin: EdgeInsets.only(
                          bottom:
                              ConstantWidget.getScreenPercentSize(context, 1)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ConstantWidget.getTextWidget(
                                  orderSnap.data[index].orderNumber,
                                  ConstantData.mainTextColor,
                                  TextAlign.start,
                                  FontWeight.w400,
                                  ConstantData.font22Px),
                              new Spacer(),
                              ConstantWidget.getTextWidget(
                                  orderSnap.data[index].deliveryDate,
                                  Colors.grey,
                                  TextAlign.start,
                                  FontWeight.w400,
                                  ConstantData.font15Px),
                            ],
                          ),
                          SizedBox(
                            height: (margin / 1.5),
                          ),
                          Row(children: [
                            ConstantWidget.getTextWidget(
                                "Price: " + orderSnap.data[index].price,
                                ConstantData.mainTextColor,
                                TextAlign.start,
                                FontWeight.w400,
                                ConstantData.font18Px),
                          ]),
                          SizedBox(
                            height: (margin / 1.5),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ConstantWidget.getTextWidget(
                                    orderSnap.data[index].packageWeight,
                                    Colors.green,
                                    TextAlign.start,
                                    FontWeight.w400,
                                    ConstantData.font18Px),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: (margin / 1.5),
                          ),
                          _DeliveryProcesses(
                            processes: timeLineModel,
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      activeOrderListModel = await db.activeOrderList();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActiveOrderDetail(
                                activeOrderListModel.elementAt(index)),
                          ));
                    },
                  );
                },
              );
            }
          },
          future: db.assignedList(),
        ),
      );
    }
  }

  getActivityButton(String s, String desc, var icon, var color) {
    double cellHeight = ConstantWidget.getScreenPercentSize(context, 15);
    double radius = ConstantWidget.getPercentSize(cellHeight, 10);
    double iconSize = ConstantWidget.getPercentSize(cellHeight, 30);

    return Container(
      height: cellHeight,
      margin: EdgeInsets.only(
          bottom: ConstantWidget.getPercentSize(cellHeight, 20)),
      padding: EdgeInsets.all(ConstantWidget.getPercentSize(cellHeight, 15)),
      decoration: BoxDecoration(
          color: ConstantData.cellColor,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
                color: ConstantData.shadowColor.withOpacity(0.2),
                blurRadius: 5,
                offset: Offset(0, 5),
                spreadRadius: 1)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ConstantData.assetsPath + icon,
            color: color,
            height: iconSize,
          ),
          SizedBox(
            width: ConstantWidget.getPercentSize(cellHeight, 15),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstantWidget.getTextWidget(
                    s,
                    ConstantData.mainTextColor,
                    TextAlign.start,
                    FontWeight.w600,
                    ConstantWidget.getPercentSize(cellHeight, 15)),
                SizedBox(
                  height: ConstantWidget.getPercentSize(cellHeight, 5),
                ),
                ConstantWidget.getTextWidget(
                    desc,
                    Colors.grey,
                    TextAlign.start,
                    FontWeight.w600,
                    ConstantWidget.getPercentSize(cellHeight, 12))
              ],
            ),
          ))
        ],
      ),
    );
  }

  getTabWidget(String s, int pos) {
    bool isSelect = (pos == tabPosition);
    return Expanded(
      child: InkWell(
        child: Stack(
          children: [
            Center(
              child: ConstantWidget.getTextWidget(
                  s.toUpperCase(),
                  (isSelect) ? ConstantData.mainTextColor : Colors.grey,
                  TextAlign.center,
                  FontWeight.w600,
                  ConstantWidget.getScreenPercentSize(context, 2.2)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: (isSelect) ? ConstantData.primaryColor : Colors.grey,
                height: ConstantWidget.getScreenPercentSize(context, 0.3),
              ),
            )
          ],
        ),
        onTap: () {
          setState(() {
            tabPosition = pos;
          });
        },
      ),
      flex: 1,
    );
  }

  newOrderPage() {
    // return Container(
    //   child: Column(
    //     children: [
    //       Container(
    //         height: appbarHeight,
    //         color: ConstantData.primaryColor,
    //         margin: EdgeInsets.only(bottom: margin),
    //         padding: EdgeInsets.only(right: ConstantData.font15Px),
    //         child: Center(
    //           child: ConstantWidget.getTextWidget(
    //               S.of(context).newOrderType,
    //               Colors.white,
    //               TextAlign.center,
    //               FontWeight.w600,
    //               ConstantData.font22Px),
    //         ),
    //       ),
    //       ListView.builder(
    //         itemCount: orderTypeList.length,
    //         shrinkWrap: true,
    //         itemBuilder: (context, index) {
    //           return InkWell(
    //             child: Container(
    //               height: height,
    //               color: ConstantData.cellColor,
    //               margin: EdgeInsets.only(bottom: margin),
    //               padding: EdgeInsets.symmetric(horizontal: margin),
    //               child: Row(
    //                 children: [
    //                   Container(
    //                     height: cellHeight,
    //                     width: cellHeight,
    //                     margin: EdgeInsets.only(right: margin),
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(
    //                           ConstantWidget.getPercentSize(cellHeight, 20)),
    //                       border: Border.all(
    //                           color: Colors.grey,
    //                           width: ConstantWidget.getWidthPercentSize(
    //                               context, 0.08)),
    //                     ),
    //                     padding: EdgeInsets.all(
    //                         ConstantWidget.getPercentSize(cellHeight, 20)),
    //                     child: Image.asset(
    //                       ConstantData.assetsPath + orderTypeList[index].image,
    //                       color: ConstantData.primaryColor,
    //                     ),
    //                   ),
    //                   ConstantWidget.getTextWidget(
    //                       orderTypeList[index].title,
    //                       ConstantData.mainTextColor,
    //                       TextAlign.center,
    //                       FontWeight.w600,
    //                       ConstantWidget.getPercentSize(height, 20)),
    //                 ],
    //               ),
    //             ),
    //             onTap: () {
    //               Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                     builder: (context) =>
    //                         WeightPage(orderTypeList[index].title),
    //                   ));
    //             },
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );

    return SchedulePage(true);
  }

  infoPage() {
    return Container();
  }

  //
  Future<bool> _requestPop() {
    if (_selectedIndex != 0) {
      _tabController.index = 0;
      _selectedIndex = 0;
      setState(() {});
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      });
    }

    return new Future.value(false);
  }

  getProfilePage() {
    ProfileModel profileModel = DataFile.getProfileModel();

    double leftMargin = MediaQuery.of(context).size.width * 0.04;
    double imageSize = SizeConfig.safeBlockVertical * 15;
    double deftMargin = ConstantWidget.getScreenPercentSize(context, 2);

    return Container(
      color: ConstantData.bgColor,
      margin: EdgeInsets.only(
          left: leftMargin,
          right: leftMargin,
          top: leftMargin,
          bottom: MediaQuery.of(context).size.width * 0.01),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: (deftMargin * 1.5)),
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: (deftMargin * 2),
                  ),
                  Row(
                    children: [
                      Container(
                        height: imageSize,
                        width: imageSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: ExactAssetImage(profileModel.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: deftMargin),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstantWidget.getCustomTextWithoutAlign(
                                  profileModel.name,
                                  ConstantData.mainTextColor,
                                  FontWeight.bold,
                                  ConstantData.font22Px),
                              Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: ConstantWidget.getCustomTextWithoutAlign(
                                    profileModel.email,
                                    ConstantData.textColor,
                                    FontWeight.w500,
                                    ConstantData.font15Px),
                              )
                            ],
                          ),
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            child: _getCell(S.of(context).editProfiles, Icons.edit),
            onTap: () {
              sendAction(EditProfilePage());
            },
          ),

          // InkWell(
          //   child: _getCell(S.of(context).mySavedCards, Icons.credit_card),
          //   onTap: () {
          //     // sendAction(MySavedCardsPage());
          //   },
          // ),

          InkWell(
            child: _getCell(S.of(context).notification, Icons.notifications),
            onTap: () {
              sendAction(NotificationPage());
            },
          ),

          InkWell(
            child: _getCell(
                S.of(context).resetPassword, Icons.lock_outline_rounded),
            onTap: () {
              sendAction(ResetPasswordPage());
            },
          ),

          InkWell(
            child: _getCell(S.of(context).userRegistration, Icons.person_add),
            onTap: () {
              sendAction(Registration());
            },
          ),
          InkWell(
            child: _getCell(S.of(context).users, Icons.person),
            onTap: () {
              sendAction(UsersList());
            },
          ),
          InkWell(
            child: _getModeCell(
                S.of(context).darkMode,
                (themMode == 0)
                    ? Icons.toggle_off_outlined
                    : Icons.toggle_on_outlined),
            onTap: () {
              if (themMode == 1) {
                PrefData.setThemeMode(0);
              } else {
                PrefData.setThemeMode(1);
              }
              getThemeMode();
            },
          ),

          // InkWell(
          //   child: _getCell(S.of(context).review, Icons.rate_review),
          //   onTap: () {
          //     // sendAction(WriteReviewPage());
          //   },
          // ),

          InkWell(
            child: _getCell(
                S.of(context).termsConditions, Icons.privacy_tip_outlined),
            onTap: () {
              sendAction(TermsConditionPage(true));
            },
          ),
          InkWell(
            child: _getCell(S.of(context).aboutUs, Icons.info_outlined),
            onTap: () {
              sendAction(AboutUsPage());
            },
          ),
          InkWell(
            child: _getCell(S.of(context).logout, Icons.logout),
            onTap: () {
              PrefData.setIsSignIn(false);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          ),
        ],
      ),
    );
  }

  void sendAction(StatefulWidget className) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => className));
  }

  Widget _getCell(String s, var icon) {
    double deftMargin = ConstantWidget.getScreenPercentSize(context, 2);
    double size = ConstantWidget.getScreenPercentSize(context, 6);
    double iconSize = ConstantWidget.getPercentSize(size, 50);

    return Container(
      margin: EdgeInsets.only(
          bottom: ConstantWidget.getScreenPercentSize(context, 0.2)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                    right: ConstantWidget.getScreenPercentSize(context, 1)),
                height: size,
                width: size,
                decoration: new BoxDecoration(
                    color: ConstantData.cellColor,
                    boxShadow: [
                      BoxShadow(
                          color: ConstantData.shadowColor.withOpacity(0.2),
                          blurRadius: 2,
                          offset: Offset(0, 2),
                          spreadRadius: 1)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(
                        ConstantWidget.getPercentSize(size, 15)))),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: ConstantData.textColor,
                ),
              ),
              Text(
                s,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ConstantData.font18Px,
                  fontFamily: ConstantData.fontFamily,
                  color: ConstantData.textColor,
                ),
              ),
              new Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(
                    Icons.navigate_next,
                    color: ConstantData.textColor,
                    size: ConstantWidget.getScreenPercentSize(context, 3),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: deftMargin, bottom: deftMargin),
            height: ConstantWidget.getScreenPercentSize(context, 0.02),
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _getModeCell(String s, var icon) {
    double deftMargin = ConstantWidget.getScreenPercentSize(context, 2);
    double size = ConstantWidget.getScreenPercentSize(context, 6);
    double iconSize = ConstantWidget.getPercentSize(size, 50);

    return Container(
      margin: EdgeInsets.only(
          bottom: ConstantWidget.getScreenPercentSize(context, 0.2)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                    right: ConstantWidget.getScreenPercentSize(context, 1)),
                height: size,
                width: size,
                decoration: new BoxDecoration(
                    color: ConstantData.cellColor,
                    boxShadow: [
                      BoxShadow(
                          color: ConstantData.shadowColor.withOpacity(0.2),
                          blurRadius: 2,
                          offset: Offset(0, 2),
                          spreadRadius: 1)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(
                        ConstantWidget.getPercentSize(size, 15)))),
                child: Icon(
                  Icons.brightness_6_outlined,
                  size: iconSize,
                  color: ConstantData.mainTextColor,
                ),
              ),
              Text(
                s,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ConstantData.font18Px,
                  fontFamily: ConstantData.fontFamily,
                  color: ConstantData.textColor,
                ),
              ),
              new Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(
                    icon,
                    color: (themMode == 1)
                        ? ConstantData.accentColor
                        : ConstantData.textColor,
                    size: ConstantWidget.getScreenPercentSize(context, 5),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: deftMargin, bottom: deftMargin),
            height: ConstantWidget.getScreenPercentSize(context, 0.02),
            color: ConstantData.mainTextColor,
          ),
        ],
      ),
    );
  }
}

// https://pub.dev/packages/place_picker
class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({Key key, @required this.processes})
      : assert(processes != null),
        super(key: key);

  final List<TimeLineModel> processes;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: EdgeInsets.zero,
        // padding: EdgeInsets.all(
        //   ConstantWidget.getScreenPercentSize(context, 3),
        // ),
        // padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Colors.grey.shade300,
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: ConstantWidget.getScreenPercentSize(context, 1.8),
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 1.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              // if (processes[index].isCompleted) return null;

              // return Container(height: 300,color: Colors.redAccent,);
              return Padding(
                padding: EdgeInsets.only(
                    left: ConstantWidget.getScreenPercentSize(context, 1.5),
                    bottom: (index != (processes.length - 1))
                        ? ConstantWidget.getScreenPercentSize(context, 3)
                        : 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    processes[index].text,
                    textAlign: TextAlign.start,
                    style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize:
                            ConstantWidget.getScreenPercentSize(context, 1.8),
                        // fontSize: ConstantData.font18Px,
                        fontFamily: ConstantData.fontFamily,
                        color: ConstantData.mainTextColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (processes[index].isComplete) {
                // return DotIndicator(
                //   color: Color(0xff66c97f),
                //   child: Icon(
                //     Icons.check,
                //     color: Colors.white,
                //     size: 12.0,
                //   ),
                // );

                return OutlinedDotIndicator(
                  borderWidth: 1.5,
                  color: ConstantData.accentColor,
                );
              } else {
                return OutlinedDotIndicator(
                  borderWidth: 1.5,
                  color: Colors.grey,
                );
              }
            },
            connectorBuilder: (_, index, __) {
              if (processes[index].isComplete) {
                return SolidLineConnector(
                  color: processes[index].isComplete
                      ? ConstantData.accentColor
                      : null,
                );
              } else {
                return null;
              }
            },
          ),
        ),
      ),
    );
  }
}
