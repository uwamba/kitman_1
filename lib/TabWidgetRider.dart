import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:knitman/Database/Db.dart';
import 'package:knitman/Database/UserPresence.dart';
import 'package:knitman/model/orderList.dart';
import 'package:location/location.dart';
import 'package:timelines/timelines.dart';

import 'NotificationPage.dart';
import 'OrderDetail.dart';
import 'OrderDetails.dart';
import 'OrderDetailsDriver.dart';
import 'OrderMap.dart';
import 'SchedulePage.dart';
import 'TrackOrderPage.dart';
import 'customWidget/MotionTabBarView.dart';
import 'customWidget/MotionTabController.dart';
import 'customWidget/motiontabbar.dart';
import 'generated/l10n.dart';
import 'main.dart';
import 'model/ActiveOrderModel.dart';
import 'model/ChatModel.dart';
import 'model/CompletedOrderModel.dart';
import 'model/NewOrderTypeModel.dart';
import 'model/ProfileModel.dart';
import 'model/TimeLineModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/PrefData.dart';
import 'util/SizeConfig.dart';

class TabWidgetRider extends StatefulWidget {
  final bool isDataShow;
  TabWidgetRider(this.isDataShow);

  @override
  _TabWidget createState() {
    return _TabWidget();
  }
}

class _TabWidget extends State<TabWidgetRider> with TickerProviderStateMixin {
  MotionTabBar motionTabBar;
  MotionTabController _tabController;
  int _selectedIndex = 0;
  List<ChatModel> chatUserList = DataFile.getChatUserList();
  List<TimeLineModel> timeLineModel = [];

  int tabPosition = 0;
  List<String> s = ["Orders", "New Order", "Profile"];
  List<NewOrderTypeModel> orderTypeList = DataFile.getOrderTypeList();
  List<CompletedOrderModel> completeOrderList = DataFile.getCompleteOrder();
  List<ActiveOrderModel> activeOrderList = DataFile.getActiveOrderList();
  List<TimeLineModel> addressList;
  List<OrderList> activeOrderListModel;
  bool isAppbarVisible = true;

  int themMode;
  bool isFirstTime = false;
  String phone;

  UserLocation _currentLocation;
  Location location = new Location();
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();

  Stream<UserLocation> get locationStream => _locationController.stream;

  getThemeMode() async {
    isFirstTime = await PrefData.getIsFirstTime();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor:
            (themMode == 1) ? ConstantData.bgColor : ConstantData.bgColor));
    themMode = await PrefData.getThemeMode();
    ConstantData.setThemePosition();
    setState(() {});
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

  void setUserData() async {
    phone = await PrefData.getPhoneNumber();
    String email = await PrefData.getEmail();
    String lastName = await PrefData.getLastName();
    String firstName = await PrefData.getFirstName();
    GeoPoint location = await getLocation();
    UserPresence(phone, email, lastName, firstName, location)
        .updateUserPresence();
  }

  void setPresence() async {
    phone = await PrefData.getPhoneNumber();
    String email = await PrefData.getEmail();
    String lastName = await PrefData.getLastName();
    String firstName = await PrefData.getFirstName();
    GeoPoint location = await getLocation();
    UserPresence(phone, email, lastName, firstName, location)
        .updateUserLocation();
  }

  locationService() {
    // Request permission to use location
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            print("location changed");
            setPresence();
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setUserData();
    locationService();
    getThemeMode();

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
    _tabController = new MotionTabController(
        initialIndex: _selectedIndex, length: s.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ConstantData.setThemePosition();

    motionTabBar = new MotionTabBar(
      labels: ["Orders", "New Order", "Profile"],
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
        // "bottom_icon_3.png",
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
                  child: newOrderPage(),
                ),
                // Container(
                //   child: getChatPage(),
                // ),
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
                  S.of(context).online,
                  ConstantData.mainTextColor,
                  TextAlign.start,
                  FontWeight.w800,
                  ConstantWidget.getScreenPercentSize(context, 2.5)),
            ),
            Container(
                height: height,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: chatUserList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                          child: Container(
                            margin: EdgeInsets.only(left: leftMargin),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: imageSize,
                                      width: imageSize,
                                      padding: EdgeInsets.all(
                                          ConstantWidget.getPercentSize(
                                              imageSize, 3)),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent,
                                          border: Border.all(
                                              color: ConstantData.accentColor,
                                              width:
                                                  ConstantWidget.getPercentSize(
                                                      imageSize, 3))),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent,
                                          image: DecorationImage(
                                            image: ExactAssetImage(
                                                ConstantData.assetsPath +
                                                    chatUserList[index].image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      child: Positioned.fill(
                                          child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              // bottom: (0), right: (0)),
                                              bottom: (leftMargin / 6),
                                              right: (leftMargin / 5)),
                                          child: Container(
                                            height:
                                                ConstantWidget.getPercentSize(
                                                    imageSize, 22),
                                            width:
                                                ConstantWidget.getPercentSize(
                                                    imageSize, 22),
                                            padding: EdgeInsets.all(
                                                ConstantWidget.getPercentSize(
                                                    imageSize, 4)),
                                            decoration: BoxDecoration(
                                                color: ConstantData.bgColor,
                                                shape: BoxShape.circle),
                                            child: Container(
                                              height: double.infinity,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: (chatUserList[index]
                                                              .active ==
                                                          1)
                                                      ? Colors.green
                                                      : Colors.red,
                                                  shape: BoxShape.circle),
                                            ),
                                          ),
                                        ),
                                      )),
                                      visible:
                                          (chatUserList[index].active == 1),
                                    )
                                  ],
                                ),
                                SizedBox(
                                    height: ConstantWidget.getPercentSize(
                                        height, 3)),
                                ConstantWidget.getCustomText(
                                    chatUserList[index].name,
                                    ConstantData.textColor,
                                    1,
                                    TextAlign.start,
                                    FontWeight.w300,
                                    ConstantWidget.getPercentSize(height, 12)),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => ChatScreen(
                          //         user: chats[0].sender,
                          //         chatModel: chatUserList[index],
                          //       ),
                          //     ));
                        },
                      );
                    })),
            Padding(
              padding: EdgeInsets.only(left: leftMargin, bottom: leftMargin),
              child: ConstantWidget.getTextWidget(
                  S.of(context).chat,
                  ConstantData.mainTextColor,
                  TextAlign.start,
                  FontWeight.w800,
                  ConstantWidget.getScreenPercentSize(context, 2.5)),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: chatUserList.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return chatCell(chatUserList[index], index);
              },
            ))
          ],
        ),
      ),
    );
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
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ChatScreen(
        //         user: chats[0].sender,
        //         chatModel: chatModel,
        //       ),
        //     ));
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
                              builder: (context) => NotificationPage(),
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
                            // Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //   builder: (context) => TrackOrderPage(),
                            // ));
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
                                            orderSnap.data[index].packageValue,
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
                                    orderSnap.data[index].packageWeight,
                                    Colors.grey,
                                    2,
                                    TextAlign.start,
                                    FontWeight.w500,
                                    ConstantData.font18Px),
                                SizedBox(
                                  height: (margin / 2),
                                ),
                                Row(
                                  children: [
                                    ConstantWidget.getCustomText(
                                        orderSnap.data[index].packageType,
                                        ConstantData.mainTextColor,
                                        1,
                                        TextAlign.start,
                                        FontWeight.w500,
                                        ConstantData.font18Px),
                                    RatingBar.builder(
                                      itemSize: 15,
                                      initialRating: 5,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      tapOnlyMode: true,
                                      updateOnDrag: true,
                                      unratedColor: Colors.grey,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 10,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: (margin / 2),
                                ),
                                InkWell(
                                  child: Container(
                                    height: height,
                                    width: ConstantWidget.getWidthPercentSize(
                                        context, 20),
                                    decoration: BoxDecoration(
                                        color: ConstantData.accentColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ConstantWidget.getPercentSize(
                                                    height, 30)))),
                                    child: Center(
                                      child: ConstantWidget.getCustomText(
                                          S.of(context).rate,
                                          Colors.white,
                                          1,
                                          TextAlign.center,
                                          FontWeight.w500,
                                          ConstantWidget.getPercentSize(
                                              height, 40)),
                                    ),
                                  ),
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => RatingPage(),
                                    //   ));
                                  },
                                ),
                                SizedBox(
                                  height: (margin / 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () async {
                          activeOrderListModel = await db.activeOrderList();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ActiveOrderDetail(orderSnap.data[index]),
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

  oldtabActiveWidget() {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);

    if (!widget.isDataShow) {
      PrefData.setIsFirstTime(false);
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
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: activeOrderList.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Container(
                padding: EdgeInsets.all(margin),
                color: ConstantData.cellColor,
                margin: EdgeInsets.only(
                    bottom: ConstantWidget.getScreenPercentSize(context, 1)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ConstantWidget.getTextWidget(
                            activeOrderList[index].price,
                            ConstantData.mainTextColor,
                            TextAlign.start,
                            FontWeight.w400,
                            ConstantData.font22Px),
                        new Spacer(),
                        ConstantWidget.getTextWidget(
                            activeOrderList[index].orderNumber,
                            Colors.grey,
                            TextAlign.start,
                            FontWeight.w400,
                            ConstantData.font15Px),
                      ],
                    ),
                    SizedBox(
                      height: (margin / 1.5),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ConstantWidget.getTextWidget(
                              activeOrderList[index].orderText,
                              Colors.green,
                              TextAlign.start,
                              FontWeight.w400,
                              ConstantData.font18Px),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.notifications,
                            size: (margin * 1.5),
                            color: ConstantData.primaryColor,
                          ),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //  MaterialPageRoute(
                            //   builder: (context) => NotificationPage(),
                            // ));
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: (margin / 1.5),
                    ),
                    _DeliveryProcesses(
                        processes: activeOrderList[index].modelList),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetail(activeOrderList[index]),
                    ));
              },
            );
          },
        ),
      );
    }
  }

  tabActiveWidget() {
    double margin = ConstantWidget.getScreenPercentSize(context, 2);
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
      double appbarHeight = ConstantWidget.getScreenPercentSize(context, 8);
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
                  model.text = orderSnap.data[index].senderLocation;
                  model.contact = orderSnap.data[index].senderPhone;
                  model.isComplete = true;
                  timeLineModel.add(model);
                  TimeLineModel model2 = new TimeLineModel();
                  model2.text = orderSnap.data[index].receiverLocation;
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
                          Row(
                            children: [
                              Expanded(
                                child: ConstantWidget.getTextWidget(
                                    orderSnap.data[index].status,
                                    Colors.green,
                                    TextAlign.start,
                                    FontWeight.w400,
                                    ConstantData.font18Px),
                              ),
                              InkWell(
                                  child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      ConstantData.assetsPath + "delivery.png",
                                      height: ConstantWidget.getPercentSize(
                                          appbarHeight, 50),
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
                                          if (orderSnap.data[index].status ==
                                              "new") {
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderLocation(
                                                          orderSnap.data[index]
                                                              .orderNumber,
                                                          orderSnap.data[index]
                                                              .driverNumber,
                                                          orderSnap.data[index]
                                                              .senderCoordinates,
                                                          orderSnap.data[index]
                                                              .receiverCoordinates),
                                                ));
                                          }
                                        }),
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
                              ))
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
                      activeOrderListModel =
                          await db.orderListWhere("driverNumber", phone);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsDriver(
                                activeOrderListModel.elementAt(index)),
                          ));
                    },
                  );
                },
              );
            }
          },
          future: db.orderListWhere("driverNumber", phone),
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

  String email, names, phoneNumber;
  Future<String> getData() async {
    email = await PrefData.getEmail();
    names = await PrefData.getFirstName() + " " + await PrefData.getLastName();
    phoneNumber = await PrefData.getPhoneNumber();
    return names;
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
                        child: FutureBuilder<String>(
                          builder: (ctx, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Container(
                                margin: EdgeInsets.only(left: deftMargin),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstantWidget.getCustomTextWithoutAlign(
                                        names,
                                        ConstantData.mainTextColor,
                                        FontWeight.bold,
                                        ConstantData.font22Px),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: ConstantWidget
                                          .getCustomTextWithoutAlign(
                                              email,
                                              ConstantData.textColor,
                                              FontWeight.w500,
                                              ConstantData.font15Px),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: ConstantWidget
                                          .getCustomTextWithoutAlign(
                                              phoneNumber,
                                              ConstantData.textColor,
                                              FontWeight.w500,
                                              ConstantData.font15Px),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          future: getData(),
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
              //sendAction(EditProfilePage());
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
              // sendAction(NotificationPage());
            },
          ),

          InkWell(
            child: _getCell(
                S.of(context).resetPassword, Icons.lock_outline_rounded),
            onTap: () {
              // sendAction(ResetPasswordPage());
            },
          ),

          InkWell(
            child: _getCell(S.of(context).giftCard, Icons.card_giftcard),
            onTap: () {
              //sendAction(MyVouchers(false));
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
              // sendAction(TermsConditionPage(true));
            },
          ),
          InkWell(
            child: _getCell(S.of(context).aboutUs, Icons.info_outlined),
            onTap: () {
              //sendAction(AboutUsPage());
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
            itemCount: 2,
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

class UserLocation {
  final double latitude;
  final double longitude;

  UserLocation({this.latitude, this.longitude});
}
