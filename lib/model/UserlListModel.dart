class UserListModel {
  final String firstName, lastName, email, password, phone, role, created;
  const UserListModel(
      {this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.phone,
      this.role,
      this.created});

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      created: json['created'] as String,
    );
  }
}
