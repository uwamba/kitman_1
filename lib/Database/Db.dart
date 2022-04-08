import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:knitman/model/UserlListModel.dart';
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
      receiverAddress;
  CollectionReference orders;
  List<OrderList> completeOrderList;
  List<UserListModel> allUserList;
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('orders');

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
  }

  Future<List<OrderList>> completedOrderList() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

    completeOrderList =
        parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

    print(completeOrderList);
    return completeOrderList;
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
      pointLocation,
      pointCoordinate,
      orderType,
      senderPhone,
      receiverPhone,
      senderAddress,
      receiverAddress) async {
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
    this.deliveryType = deliveryType;
    this.pointLocation = pointLocation;
    this.pointCoordinate = pointCoordinate;
    this.orderType = orderType;
    this.senderPhone = senderPhone;
    this.receiverPhone = receiverPhone;
    this.senderAddress = senderAddress;
    this.receiverAddress = receiverAddress;

    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    //String date=getTimeAndDateCell(true).text;
    //Call the user's CollectionReference to add a new user
    //orders.doc(orderNumber).set({
    orders
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
          'deliveryType':
              deliveryType, //delivery type schelduled or deliver now
          'pointLocation': pointLocation, // point addres location
          'pointCoordinate': pointCoordinate, //point address coordinate
          'orderType': "coorporate", // coorporate, customer
          'senderPhone': senderPhone, // sender phone number
          'receiverPhone': receiverPhone, // receiver phone number
          'senderAddress': senderAddress, // package sender address
          'receiverAddress': receiverAddress, // receiver address
        })
        .then((value) => print("User Added" + orderNumber))
        .catchError((error) => print("Failed to add user: $error"));
  }
}