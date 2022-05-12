class FormValidation {
  bool isEmail(String email) {
    bool _isEmail;
    if (email.isNotEmpty && email.contains("@") && email.contains(".")) {
      _isEmail = true;
    }
    return _isEmail;
  }

  bool isFirstName(String firstName) {
    bool _isFirstName;
    if (firstName.isNotEmpty &&
        firstName.contains("@") &&
        firstName.contains(".")) {
      _isFirstName = true;
    }
    return _isFirstName;
  }

  bool isNumber() {}
}
