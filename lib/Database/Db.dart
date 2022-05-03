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
      senderPhone,
      senderLocation,
      receiverPhone,
      receiverLocation,
      packageType,
      deliveryType,
      orderType,
      packageWeight,
      packageValue,
      servicePhone,
      price,
      paymentMethod;
  GeoPoint senderCoordinates, receiverCoordinates;
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
  }

  Future updateOrder(id, driver) async {
    QuerySnapshot querySnapshot;
    await collectionRef
        .where('orderNumber', isEqualTo: id)
        .get()
        .then((value) => value.docs.forEach((doc) {
              doc.reference.update({'status': 'assigned'});
              doc.reference.update({'driverNumber': driver});
            }));
    print("updated");
  }

  Future updateStatus(id, status) async {
    QuerySnapshot querySnapshot;
    await collectionRef
        .where('orderNumber', isEqualTo: id)
        .get()
        .then((value) => value.docs.forEach((doc) {
              doc.reference.update({'status': status});
            }));
    print(status + id);
  }

  Future<List<OrderList>> completedOrderList() async {
    QuerySnapshot querySnapshot =
        await collectionRef.where('status', isEqualTo: "completed").get();
    final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

    completeOrderList =
        parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

    print(completeOrderList);
    return completeOrderList;
  }

  Future<List<OrderList>> activeOrderList() async {
    QuerySnapshot querySnapshot =
        await collectionRef.where('status', isEqualTo: "new").get();

    final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

    completeOrderList =
        parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

    print(completeOrderList);
    collectionRef.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) async {
        QuerySnapshot querySnapshot =
            await collectionRef.where('status', isEqualTo: "new").get();

        final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

        completeOrderList =
            parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

        print(completeOrderList);
      });
    });

    return completeOrderList;
  }

  Future<List<OrderList>> adminActiveOrderList() async {
    QuerySnapshot querySnapshot = await collectionRef
        .where("status", whereIn: ["accepted", "picked", "delivered"]).get();

    final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

    completeOrderList =
        parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

    print(completeOrderList);
    collectionRef.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) async {
        QuerySnapshot querySnapshot =
            await collectionRef.where('status', isEqualTo: "new").get();

        final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

        completeOrderList =
            parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

        print(completeOrderList);
      });
    });

    return completeOrderList;
  }

  Future<List<OrderList>> customerActiveOrderList(sender) async {
    QuerySnapshot querySnapshot = await collectionRef
        .where("status",
            whereIn: ["accepted", "picked", "delivered", "assigned", "new"])
        .where("senderId", isEqualTo: sender)
        .get();

    final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

    completeOrderList =
        parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

    print(completeOrderList);
    collectionRef.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) async {
        QuerySnapshot querySnapshot = await collectionRef
            .where("status", isNotEqualTo: "completed")
            .get();

        final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

        completeOrderList =
            parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

        print(completeOrderList);
      });
    });

    return completeOrderList;
  }

  Future<List<OrderList>> unassignedList() async {
    QuerySnapshot querySnapshot =
        await collectionRef.where('status', isEqualTo: "new").get();

    final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

    completeOrderList =
        parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

    print(completeOrderList);
    collectionRef.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) async {
        QuerySnapshot querySnapshot =
            await collectionRef.where('status', isEqualTo: "new").get();

        final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

        completeOrderList =
            parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

        print(completeOrderList);
      });
    });
    return completeOrderList;
  }

  Future<List<OrderList>> assignedList() async {
    QuerySnapshot querySnapshot =
        await collectionRef.where('status', isEqualTo: "assigned").get();

    final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

    completeOrderList =
        parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

    print(completeOrderList);
    collectionRef.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) async {
        QuerySnapshot querySnapshot =
            await collectionRef.where('status', isEqualTo: "assigned").get();

        final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

        completeOrderList =
            parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

        print(completeOrderList);
      });
    });
    return completeOrderList;
  }

  Future<List<OrderList>> orderListWhere(String key, String value) async {
    QuerySnapshot querySnapshot =
        await collectionRef.where(key, isEqualTo: value).get();

    final parsed = querySnapshot.docs.map((doc) => doc.data()).toList();

    completeOrderList =
        parsed.map<OrderList>((json) => OrderList.fromJson(json)).toList();

    print(completeOrderList);
    collectionRef.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) async {
        QuerySnapshot querySnapshot = await collectionRef
            .where(key, isEqualTo: value)
            .where("status", isEqualTo: "assigned")
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

  Future<void> signUp(String userId, String email, String firstName,
      String lastName, String role, String date, String password) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    //var newFormat = DateFormat("yy-MM-dd");
    //String updatedDt = newFormat.format(dt);

    Map<String, dynamic> userData = {
      'UID': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'created': date,
      'phone': userId,
      'password': password
    };
    users.add(userData);
  }

  Future<void> addOrder(
    String status,
    String deliveryTime,
    String deliveryDate,
    String receivedTime,
    String receivedDate,
    String orderNumber,
    String senderId,
    String senderPhone,
    String senderLocation,
    String receiverPhone,
    String receiverLocation,
    String packageType,
    String deliveryType,
    String orderType,
    String packageWeight,
    String packageValue,
    String servicePhone,
    String price,
    String paymentMethod,
    GeoPoint senderCoordinates,
    GeoPoint receiverCoordinates,
  ) async {
    this.status = status;
    this.deliveryTime = deliveryTime;
    this.deliveryDate = deliveryDate;
    this.receivedTime = receivedTime;
    this.receivedDate = receivedDate;
    this.orderNumber = orderNumber;
    this.senderId = senderId;
    this.senderPhone = senderPhone;
    this.senderLocation = senderLocation;
    this.receiverPhone = receiverPhone;
    this.receiverLocation = receiverLocation;
    this.packageType = packageType;
    this.deliveryType = deliveryType;
    this.orderType = orderType;
    this.packageWeight = packageWeight;
    this.packageValue = packageValue;
    this.servicePhone = servicePhone;
    this.price = price;
    this.paymentMethod = paymentMethod;
    this.senderCoordinates = senderCoordinates;
    this.receiverCoordinates = receiverCoordinates;
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
          'senderPhone': senderPhone,
          'senderLocation': senderLocation,
          'receiverPhone': receiverPhone,
          'receiverLocation': receiverLocation,
          'packageType': packageType,
          'deliveryType': deliveryType,
          'orderType': orderType,
          'packageWeight': packageWeight,
          'packageValue': packageValue,
          'servicePhone': servicePhone,
          'price': price,
          'paymentMethod': paymentMethod,
          'driverNumber': "",
          'senderCoordinates': senderCoordinates,
          'receiverCoordinates': receiverCoordinates
        })
        .then((value) => print("Order Added"))
        .catchError((error) => print("Failed to add Order: $error"));
  }

  //final DatabaseReference databaseReference = FirebaseDatabase.instance
  //.ref("https://kitman-3a2d0-default-rtdb.firebaseio.com/");

}
