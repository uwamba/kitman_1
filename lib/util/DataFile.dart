import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../model/ActiveOrderModel.dart';
import '../model/AddressModel.dart';
import '../model/ChatModel.dart';
import '../model/CompletedOrderModel.dart';
import '../model/IntroModel.dart';
import '../model/NewOrderTypeModel.dart';
import '../model/NotificationModel.dart';
import '../model/PaymentCardModel.dart';
import '../model/PaymentSelectModel.dart';
import '../model/ProfileModel.dart';
import '../model/SendModel.dart';
import '../model/TimeLineModel.dart';
import '../model/VouchersModel.dart';
import '../model/WeightModel.dart';

class DataFile {
  static List<PaymentCardModel> getPaymentCardList() {
    List<PaymentCardModel> subCatList = [];

    PaymentCardModel mainModel = new PaymentCardModel();
    mainModel.id = 1;
    mainModel.name = "Credit Card";
    mainModel.image = "assets/images/visa.png";
    mainModel.desc = "XXXX XXXX XXXX 1234";
    subCatList.add(mainModel);

    mainModel = new PaymentCardModel();
    mainModel.id = 2;
    mainModel.name = "Bank Account";
    mainModel.desc = "Ending in 9457";
    mainModel.image = "assets/images/bank-building.png";
    subCatList.add(mainModel);

    mainModel = new PaymentCardModel();
    mainModel.id = 3;
    mainModel.name = "PayPal";
    mainModel.desc = "paypal@gmail.com";
    mainModel.image = "assets/images/paypal.png";
    subCatList.add(mainModel);

    return subCatList;
  }

  static List<NotificationModel> getNotificationList() {
    List<NotificationModel> subCatList = [];

    NotificationModel mainModel = new NotificationModel();
    mainModel.time = "08:30 PM";
    mainModel.title = "Order Confirmed";
    mainModel.desc =
        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.";
    subCatList.add(mainModel);

    mainModel = new NotificationModel();
    mainModel.time = "08:30 PM";
    mainModel.title = "Payment Success";
    mainModel.desc =
        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.";
    subCatList.add(mainModel);

    mainModel = new NotificationModel();
    mainModel.time = "08:30 PM";
    mainModel.title = "Offer & Discount";
    mainModel.desc =
        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.";
    subCatList.add(mainModel);
    mainModel = new NotificationModel();
    mainModel.time = "08:30 PM";
    mainModel.title = "You got a promo code";
    mainModel.desc =
        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.";
    subCatList.add(mainModel);
    mainModel = new NotificationModel();
    mainModel.time = "08:30 PM";
    mainModel.title = "Order Delivered";
    mainModel.desc =
        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.";
    subCatList.add(mainModel);

    return subCatList;
  }

  static List<ActiveOrderModel> getActiveOrderList() {
    List<ActiveOrderModel> subCatList = [];
    List<TimeLineModel> timeLineModel = [];
    TimeLineModel model = new TimeLineModel();
    model.text =
        "Thane, Kolshet Industrial Area, Thane West, Thane, Maharashtra 400607";
    model.contact = "+1(368)68 000 068";
    model.comment = "dfgdfg";
    model.isComplete = true;
    timeLineModel.add(model);
    model = new TimeLineModel();
    model.text = "Puranik Villas, Kalher, Bhiwandi, Maharashtra 421302";
    model.isComplete = true;
    model.contact = "+1(368)68 000 068";
    model.comment = "dfgdfg";
    timeLineModel.add(model);

    ActiveOrderModel mainModel = new ActiveOrderModel();
    mainModel.orderText = "Courier has been assigned";
    mainModel.price = "₹256";
    mainModel.orderNumber = "14526";
    mainModel.modelList = timeLineModel;
    subCatList.add(mainModel);

    mainModel = new ActiveOrderModel();
    mainModel.orderText = "Courier has been assigned";
    mainModel.price = "₹256";
    mainModel.orderNumber = "14526";
    mainModel.modelList = timeLineModel;
    subCatList.add(mainModel);

    mainModel = new ActiveOrderModel();
    mainModel.orderText = "Courier has been assigned";
    mainModel.price = "₹256";
    mainModel.orderNumber = "14526";
    mainModel.modelList = timeLineModel;
    subCatList.add(mainModel);

    mainModel = new ActiveOrderModel();
    mainModel.orderText = "Courier has been assigned";
    mainModel.price = "₹256";
    mainModel.orderNumber = "14526";
    mainModel.modelList = timeLineModel;
    subCatList.add(mainModel);
    mainModel = new ActiveOrderModel();
    mainModel.orderText = "Courier has been assigned";
    mainModel.price = "₹256";
    mainModel.orderNumber = "14526";
    mainModel.modelList = timeLineModel;
    subCatList.add(mainModel);

    return subCatList;
  }

  static List<ChatModel> getChatUserList() {
    List<ChatModel> introList = [];
    introList.add(ChatModel("John", "hugh.png", 1, "Hi", "02:00", "15-4-2021"));
    introList.add(
        ChatModel("Soedirman", "hugh.png", 0, "Hello", "14:25", "12-3-2021"));
    introList
        .add(ChatModel("Aisyah", "hugh.png", 0, "Hy", "03:21", "02-3-2021"));
    introList.add(
        ChatModel("Jock Boerden", "hugh.png", 1, "Hi", "18:36", "02-3-2021"));
    introList
        .add(ChatModel("Sophia", "hugh.png", 0, "Hello", "22:45", "25-2-2021"));
    introList.add(ChatModel("Ava", "hugh.png", 1, "Hi", "06:00", "16-2-2021"));
    introList
        .add(ChatModel("James", "hugh.png", 0, "Hi", "02:15", "15-2-2021"));

    return introList;
  }

  static List<VouchersModel> getVouchersList() {
    List<VouchersModel> subCatList = [];

    VouchersModel mainModel = new VouchersModel();
    mainModel.id = 1;
    mainModel.name = "Black Fries Day";
    mainModel.desc = "All black fries 50% off*";
    mainModel.code = "BKD65R";
    mainModel.date = "25";
    mainModel.month = "Mar";
    mainModel.image = "logo_1.png";
    subCatList.add(mainModel);

    mainModel = new VouchersModel();
    mainModel.id = 2;
    mainModel.name = "Weekend specials";
    mainModel.desc = "All black sale 35% off*";
    mainModel.code = "FEB32#JJ";
    mainModel.date = "28";
    mainModel.month = "Feb";
    mainModel.image = "logo_2.png";
    subCatList.add(mainModel);

    mainModel = new VouchersModel();
    mainModel.id = 3;
    mainModel.name = "Specials Sale.!";
    mainModel.desc = "All black sale 35% off*";
    mainModel.code = "BMK56E";
    mainModel.date = "26";
    mainModel.month = "Feb";
    mainModel.image = "logo_3.jpg";
    subCatList.add(mainModel);

    return subCatList;
  }

  static List<CompletedOrderModel> getCompleteOrder() {
    List<CompletedOrderModel> subCatList = [];

    CompletedOrderModel mainModel = new CompletedOrderModel();
    mainModel.completedText = "Completed 14 December 3:14 PM";
    mainModel.price = "₹256";
    mainModel.address =
        "VRL,Bus Terminal Seshadri Rd,Gandhi Nagar,Bengluru,Karnataka 560009,India";
    mainModel.orderNumber = "14526";
    mainModel.rate = 5;
    subCatList.add(mainModel);

    mainModel = new CompletedOrderModel();
    mainModel.completedText = "Completed 14 December 3:14 PM";
    mainModel.price = "₹145";
    mainModel.address =
        "VRL,Bus Terminal Seshadri Rd,Gandhi Nagar,Bengluru,Karnataka 560009,India";
    mainModel.orderNumber = "14528";
    mainModel.rate = 5;
    subCatList.add(mainModel);

    mainModel = new CompletedOrderModel();
    mainModel.completedText = "Completed 14 December 3:14 PM";
    mainModel.price = "₹653";
    mainModel.address =
        "VRL,Bus Terminal Seshadri Rd,Gandhi Nagar,Bengluru,Karnataka 560009,India";
    mainModel.orderNumber = "14530";
    mainModel.rate = 5;
    subCatList.add(mainModel);

    mainModel = new CompletedOrderModel();
    mainModel.completedText = "Completed 14 December 3:14 PM";
    mainModel.price = "₹120";
    mainModel.address =
        "VRL,Bus Terminal Seshadri Rd,Gandhi Nagar,Bengluru,Karnataka 560009,India";
    mainModel.orderNumber = "14535";
    mainModel.rate = 5;
    subCatList.add(mainModel);

    return subCatList;
  }

  static List<AddressModel> getAddressList() {
    List<AddressModel> subCatList = [];

    AddressModel mainModel = new AddressModel();
    mainModel.id = 1;
    mainModel.name = "Chloe B Bird";
    mainModel.phoneNumber = "+1(368)68 000 068";
    mainModel.location = "87  Great North Road,ALTON";
    mainModel.type = "Home";
    subCatList.add(mainModel);

    mainModel = new AddressModel();
    mainModel.id = 2;
    mainModel.name = "Rich P. Jeffery";
    mainModel.phoneNumber = "+1(368)68 000 068";
    mainModel.location = "4310 Clover Drive Colorado Springs, CO 80903";
    mainModel.type = "Company";
    subCatList.add(mainModel);

    return subCatList;
  }

  static List<PaymentSelectModel> getPaymentSelect() {
    List<PaymentSelectModel> introList = [];
    introList.add(PaymentSelectModel("Cash", Icons.attach_money, 1));
    introList
        .add(PaymentSelectModel("Pay via Card", Icons.credit_card_outlined, 0));

    return introList;
  }

  static String dateFormat = "EEE ,MMM dd,yyyy";

  static List<String> getTimeList() {
    List<String> list = [];

    list.add("08:00 - 09:00");
    list.add("09:00 - 11:00");
    list.add("12:00 - 14:00");
    list.add("14:00 - 16:00");
    list.add("16:00 - 18:00");
    return list;
  }

  static List<String> getDateList() {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => index)
        .map((value) => DateFormat(dateFormat)
            .format(firstDayOfWeek.add(Duration(days: value))))
        .toList();
  }

  static List<SendModel> getSendModelList() {
    List<SendModel> list = [];

    SendModel mainModel = new SendModel();
    mainModel.title = "Document";
    mainModel.image = "file.png";
    list.add(mainModel);

    mainModel = new SendModel();
    mainModel.title = "Food or Meals";
    mainModel.image = "dinner.png";
    list.add(mainModel);

    mainModel = new SendModel();
    mainModel.title = "Cloths";
    mainModel.image = "jumper.png";
    list.add(mainModel);

    mainModel = new SendModel();
    mainModel.title = "Groceries";
    mainModel.image = "groceries.png";
    list.add(mainModel);

    mainModel = new SendModel();
    mainModel.title = "Flowers";
    mainModel.image = "flower.png";
    list.add(mainModel);
    mainModel = new SendModel();
    mainModel.title = "Cake";
    mainModel.image = "cake.png";
    list.add(mainModel);

    return list;
  }

  static List<NewOrderTypeModel> getOrderTypeList() {
    List<NewOrderTypeModel> list = [];

    NewOrderTypeModel mainModel = new NewOrderTypeModel();
    mainModel.title = "Book a courier";
    mainModel.image = "box.png";
    list.add(mainModel);

    mainModel = new NewOrderTypeModel();
    mainModel.title = "Hyperlocal";
    mainModel.image = "location.png";
    list.add(mainModel);

    return list;
  }

  static List<WeightModel> getWeightModel() {
    List<WeightModel> list = [];

    WeightModel mainModel = new WeightModel();
    mainModel.title = "Up to 5 kg";
    mainModel.image = "weight.png";
    list.add(mainModel);

    mainModel = new WeightModel();
    mainModel.title = "Up to 10 kg";
    mainModel.image = "weight.png";
    list.add(mainModel);

    mainModel = new WeightModel();
    mainModel.title = "Up to 15 kg";
    mainModel.image = "weight.png";
    list.add(mainModel);

    mainModel = new WeightModel();
    mainModel.title = "Up to 20 kg";
    mainModel.image = "weight.png";
    list.add(mainModel);

    mainModel = new WeightModel();
    mainModel.title = "Up to 25 kg";
    mainModel.image = "weight.png";
    list.add(mainModel);

    return list;
  }

  static ProfileModel getProfileModel() {
    ProfileModel mainModel = new ProfileModel();
    mainModel.email = "chloe_bird@gamil.com";
    mainModel.name = "Chloe B Bird";
    mainModel.image = "assets/images/hugh.png";
    return mainModel;
  }

  static List<IntroModel> getIntroModel(BuildContext context) {
    List<IntroModel> introList = [];

    IntroModel mainModel = new IntroModel();
    mainModel.id = 1;
    mainModel.name = "Fastest delivery service";

    //mainModel.image = "png1.png";
    // mainModel.image = "intro_2_2.jpg";
    mainModel.image = "intro_1.jpg";
    mainModel.desc =
        "We deliver documents,flowers,food,apparel goods, and  more-precisely on your schedule.";
    introList.add(mainModel);

    mainModel = new IntroModel();
    mainModel.id = 2;
    mainModel.name = "It's affordable:pricing starts from ₹40";
    // mainModel.image = "intro_1_1.jpg";
    mainModel.image = "png2.png";
    // mainModel.image = "intro_2.jpg";
    mainModel.desc =
        "Set addresses,pick time,and the app will calculate the delivery price.";
    introList.add(mainModel);

    mainModel = new IntroModel();
    mainModel.id = 3;
    mainModel.name = "It's Reliable";

    // mainModel.image = "intro_3_3.jpg";
    mainModel.image = "png3.png";
    // mainModel.image = "intro_3.jpg";
    mainModel.desc =
        "We'll quickly find a courier,notify at each delivery stage,and assist you in chat.";
    introList.add(mainModel);

    return introList;
  }
}
