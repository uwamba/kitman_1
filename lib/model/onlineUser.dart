class onlineUser {
  final String UID;
  final String last_seen;
  final String presence;

  const onlineUser({this.UID, this.last_seen, this.presence});

  factory onlineUser.fromJson(Map<String, dynamic> data) {
    return onlineUser(
        UID: data['UID'] as String,
        last_seen: data['last_seen'] as String,
        presence: data['presence'] as String);
  }
}
