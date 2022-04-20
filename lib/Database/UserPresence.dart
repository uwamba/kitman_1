import 'package:firebase_database/firebase_database.dart';

class UserPresence {
  String userId;
  String email;

  UserPresence(this.userId, this.email);
  void updateUserPresence() async {
    // userId = PrefData.getPhoneNumber();
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("presence/" + userId);

    Map<String, dynamic> presenceStatusTrue = {
      'UID': userId,
      'presence': true,
      'email': email,
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
