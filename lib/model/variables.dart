class Variables {
  final int price;
  final String momoCode;
  final String momoNumber;
  final String bankAccount;

  const Variables(
      {this.price, this.momoCode, this.momoNumber, this.bankAccount});

  factory Variables.fromJson(Map<String, dynamic> json) {
    return Variables(
      price: json['price_per_km'] as int,
      momoCode: json['momo_pay_code'] as String,
      momoNumber: json['momo_number'] as String,
      bankAccount: json['bank_account'] as String,
    );
  }
}
