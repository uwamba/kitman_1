class orderList {
  final String number;
  final String order_type;
  final String package_size;

  const orderList({
    this.number,
    this.order_type,
    this.package_size,
  });

  factory orderList.fromJson(Map<String, dynamic> json) {
    return orderList(
      number: json['number'] as String,
      order_type: json['order_type'] as String,
      package_size: json['package_size'] as String,
    );
  }
}
