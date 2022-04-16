import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static String defaultString = "workout_";
  static String signIn = defaultString + "signIn";
  static String isIntro = defaultString + "isIntro";
  static String isFirstTime = defaultString + "isFirstTime";
  static String mode = defaultString + "mode";

  static setPhoneNumber(String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("phone", phone);
  }

  static getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("phone");
  }

  static setEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
  }

  static getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  static setUserId(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", uid);
  }

  static getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

  static setFirstName(String first) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("firstName", first);
  }

  static getFirstName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("firstName");
  }

  static setLastName(String last) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lastName", last);
  }

  static getLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("lastName");
  }

  static setIsSignIn(bool isFav) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(signIn, isFav);
  }

  static getIsSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(signIn) ?? false;
  }

  static setIsIntro(bool isFav) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isIntro, isFav);
  }

  static getIsIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isIntro) ?? true;
  }

  static setIsFirstTime(bool isFav) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isFirstTime, isFav);
  }

  static getIsFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isFirstTime) ?? true;
  }

  static setThemeMode(int isFav) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(mode, isFav);
  }

  static getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(mode) ?? 0;
  }
}
