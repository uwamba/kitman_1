import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:knitman/model/UserlListModel.dart';
import 'package:knitman/model/onlineUser.dart';
import 'package:knitman/model/orderList.dart';

class Db {
  String status,
      deliveryTime,
      deliveryDate,
      receivedTime,
      receivedDate,
      orderNumber,
      senderId,
      senderEmail,
      receiverId,
      receiverEmail,
      pickingLocation,
      pickingCoordinate,
      packageType,
      deliveryType,
      packageHeight,
      pointLocation,
      pointCoordinate,
      orderType,
      senderPhone,
      receiverPhone,
      senderAddress,
      receiverAddress,
      packageWeight,
      packageValue,
      servicePhone,
      price;
  CollectionReference orders;
  List<OrderList> completeOrderList;
  List<UserListModel> allUserList;
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('orders');
  List<onlineUser> listuser;
  bool avail;
  CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('users');
  Db() {
    orders = FirebaseFirestore.instance.collection('orders');
    status = "";
    deliveryTime = "";
    deliveryDate = "";
    receivedTime = "";
    receivedDate = "";
    orderNumber = "";
    senderId = "";
    senderEmail = "";
    receiverId = "";
    receiverEmail = "";
    pickingLocation = "";
    pickingCoordinate = "";
    packageType = "";
    deliveryType = "";
    packageHeight = "";
    pointLocation = "";
    pointCoordinate = "";
    orderType = "";
    senderPhone = "";
    receiverPhone = "";
    senderAddress = "";
    receiverAddress = "";
    servicePhone = "";

  }

  Future<List<OrderList>> completedOrderList() async {
    QuerySnapshot querySnapshot =
        await collectionRef.where('status', isEqualTo: "Completed").get();
    final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

    completeOrderList =
        parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

    print(completeOrderList);
    return completeOrderList;
  }

  Future<List<OrderList>> updateOrder(String orderId) async {
    CollectionReference orders;
    Map<String, dynamic> presenceStatusTrue = {
      'UID': "userId",
      'presence': true,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };

    QuerySnapshot querySnapshot =
        await collectionRef.where('orderId', isEqualTo: orderId).get();
    //db.collection("cities").doc("LA").set({
    //name: "Los Angeles",
    // state: "CA",
    // country: "USA"
    //})
  }

  Future<List<OrderList>> activeOrderList() async {
    QuerySnapshot querySnapshot =
        await collectionRef.where('status', isNotEqualTo: "Completed").get();

    final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

    completeOrderList =
        parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

    print(completeOrderList);
    collectionRef.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) async {
        QuerySnapshot querySnapshot = await collectionRef
            .where('status', isNotEqualTo: "Completed")
            .get();

        final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

        completeOrderList =
            parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

        print(completeOrderList);
      });
    });

    return completeOrderList;
  }

  Future<List> userOnline() async {
    List lis;
    List<onlineUser> lst;
    final usersQuery = FirebaseDatabase.instance.ref('presence');
    usersQuery.once().then((event) {
      final dataSnapshot = event.snapshot;

      DataSnapshot snap = event.snapshot.value;
      //final parsed = snap.children.map((doc) => doc.value).toList();

      Map<dynamic, dynamic> values = snap.value;
      values.forEach((key, values) {
        lst.add(values);
      });

      //lis = parsed.toList();
    });
    print(lis);
    return lis;
  }

  Future<List<UserListModel>> usersList() async {
    QuerySnapshot querySnapshot = await _userCollectionRef.get();

    final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

    allUserList = parsed
        .map<UserListModel>((json) => UserListModel.fromJson(json))
        .toList();

    print(allUserList);
    return allUserList;
  }

  Future<void> addOrder(
    String status,
    deliveryTime,
    deliveryDate,
    receivedTime,
    receivedDate,
    orderNumber,
    senderId,
    senderEmail,
    receiverId,
    receiverEmail,
    pickingLocation,
    pickingCoordinate,
    packageType,
    deliveryType,
    packageWeight,
    pointLocation,
    pointCoordinate,
    orderType,
    senderPhone,
    receiverPhone,
    senderAddress,
    receiverAddress,
      servicePhone,
    price,
    packageValue,

  ) async {
    this.status = status;
    this.deliveryTime = deliveryTime;
    this.deliveryDate = deliveryDate;
    this.receivedTime = receivedTime;
    this.receivedDate = receivedDate;
    this.orderNumber = orderNumber;
    this.senderId = senderId;
    this.senderEmail = senderEmail;
    this.receiverId = receiverId;
    this.receiverEmail = receiverEmail;
    this.pickingLocation = pickingLocation;
    this.pickingCoordinate = pickingCoordinate;
    this.packageType = packageType;
    this.packageWeight = packageWeight;
    this.deliveryType = deliveryType;
    this.pointLocation = pointLocation;
    this.pointCoordinate = pointCoordinate;
    this.orderType = orderType;
    this.senderPhone = senderPhone;
    this.receiverPhone = receiverPhone;
    this.senderAddress = senderAddress;
    this.receiverAddress = receiverAddress;
    this.servicePhone = servicePhone;
    this.price = price;
    this.packageValue = packageValue;
    //DatabaseReference orders =
    //FirebaseDatabase.instance.reference().child("orders");
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    // String date=getTimeAndDateCell(true).text;
    //Call the user's CollectionReference to add a new user
    //orders.doc(orderNumber).set({
    orders
        //.push()
        .add({
          'status': "new", // new,assigned,picked,intransit,arrived,completed
          'deliveryTime': deliveryTime,
          'orderNumber': orderNumber, //point time
          'deliveryDate': deliveryDate, //point date
          'receivedTime': deliveryTime, // delievry time
          'receivedDate': deliveryDate, // deleivert date
          'senderId': senderId, // sender user id
          'senderEmail': senderEmail, // sender user email
          'receiverId': receiverId, // receiver user id
          'receiverEmail': receiverEmail, //receiver email address
          'pickingLocation': pickingLocation, // picking location
          'pickingCoordinate': pickingCoordinate, //picking coordinate
          'packageType': packageType, // pachage type document,key,cake..
          'deliveryType': deliveryType,
          'packageWeight':
              packageWeight, //delivery type schelduled or deliver now
          'pointLocation': pointLocation, // point addres location
          'pointCoordinate': pointCoordinate, //point address coordinate
          'orderType': "coorporate", // coorporate, customer
          'senderPhone': senderPhone, // sender phone number
          'receiverPhone': receiverPhone, // receiver phone number
          'senderAddress': senderAddress, // package sender address
          'receiverAddress': receiverAddress, // receiver address
          'servicePhone': servicePhone, // receiver address
          'price': price, // receiver address
          'packageValue': packageValue, // receiver address
        })
        .then((value) => print("Order Added"))
        .catchError((error) => print("Failed to add Order: $error"));
  }

  //final DatabaseReference databaseReference = FirebaseDatabase.instance
  //.ref("https://kitman-3a2d0-default-rtdb.firebaseio.com/");

}
