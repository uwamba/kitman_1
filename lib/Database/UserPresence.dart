import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class UserPresence {
  String userId;
  String firstName;
  String lastName;
  String email;
  GeoPoint location;

  UserPresence(
      this.userId, this.email, this.firstName, this.lastName, this.location);
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
    print("Preshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
    Map<String, dynamic> presenceStatusFalse = {
      'UID': userId,
      'presence': false,
      'last_seen': DateTime.now().millisecondsSinceEpoch,
    };
    await ref.set(presenceStatusTrue);
    ref.onDisconnect().update(presenceStatusFalse);

    // ref.child("uid").onDisconnect().update(presenceStatusFalse);
  }

  void updateUserLocation() async {
    // userId = PrefData.getPhoneNumber();

    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("presence/" + userId);
    print("Presennnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
    Map<String, dynamic> presenceStatusTrue = {
      'latitude': location.latitude,
      'longitude': location.longitude,
    };

    // await ref.set('value':user);
    await ref.update(presenceStatusTrue);
  }
}
