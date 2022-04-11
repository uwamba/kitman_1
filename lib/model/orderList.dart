class OrderList {
  final String status,
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
      packageWeight,
      deliveryType,
      pointLocation,
      pointCoordinate,
      orderType,
      senderPhone,
      receiverPhone,
      senderAddress,
      receiverAddress,
      price,
      packageValue;

  const OrderList(
      {this.status,
      this.deliveryTime,
      this.deliveryDate,
      this.receivedTime,
      this.receivedDate,
      this.orderNumber,
      this.senderId,
      this.senderEmail,
      this.receiverId,
      this.receiverEmail,
      this.pickingLocation,
      this.pickingCoordinate,
      this.packageType,
      this.packageWeight,
      this.deliveryType,
      this.pointLocation,
      this.pointCoordinate,
      this.orderType,
      this.senderPhone,
      this.receiverPhone,
      this.senderAddress,
      this.receiverAddress,
      this.price,
      this.packageValue});

  factory OrderList.fromJson(Map<String, dynamic> json) {
    return OrderList(
      packageWeight: json['packageWeight'] as String,
      status: json['status'] as String,
      deliveryTime: json['deliveryTime'] as String,
      deliveryDate: json['deliveryDate'] as String,
      receivedTime: json['receivedTime'] as String,
      receivedDate: json['receivedDate'] as String,
      orderNumber: json['orderNumber'] as String,
      senderId: json['senderId'] as String,
      senderEmail: json['senderEmail'] as String,
      receiverId: json['receiverId'] as String,
      receiverEmail: json['receiverEmail'] as String,
      pickingLocation: json['pickingLocation'] as String,
      pickingCoordinate: json['pickingCoordinate'] as String,
      packageType: json['packageType'] as String,
      deliveryType: json['deliveryType'] as String,
      pointLocation: json['pointLocation'] as String,
      pointCoordinate: json['pointCoordinate'] as String,
      orderType: json['orderType'] as String,
      senderPhone: json['receiverAddress'] as String,
      receiverPhone: json['receiverPhone'] as String,
      senderAddress: json['senderAddress'] as String,
      receiverAddress: json['receiverAddress'] as String,
      packageValue: json['packageValue'] as String,
      price: json['price'] as String,
    );
  }
}
