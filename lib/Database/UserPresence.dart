import 'package:firebase_database/firebase_database.dart';

class UserPresence {
  String userId;
  String firstName;
  String lastName;
  String email;

  UserPresence(this.userId,this.firstName,this.lastName,this.email);
  void updateUserPresence() async {
    // userId = PrefData.getPhoneNumber();
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("presence/" + userId);

    Map<String, dynamic> presenceStatusTrue = {
      'UID': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'presence': true,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };
    Map<String, dynamic> presenceStatusFalse = {
      'UID': userId,
      'presence': false,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };
    await ref.set(presenceStatusTrue);
    ref.onDisconnect().set(presenceStatusFalse);

    // ref.child("uid").onDisconnect().update(presenceStatusFalse);
  }
}
