import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_favors/shared/constants.dart';

class Favor {
  late String assignedUser;
  late String assignedUsername;
  late String description;
  late String location;
  late String title;
  late String key;
  late String status;
  late int timestamp;
  late String user;
  late String username;

  Favor(
    this.assignedUser,
    this.assignedUsername,
    this.description,
    this.location,
    this.title,
    this.key,
    this.status,
    this.timestamp,
    this.user,
    this.username,
  );

  Favor.fromDocumentSnapShot(DocumentSnapshot snapshot) {
    assignedUser = snapshot[FAVOR_ASSIGNED_USER] ?? '';
    assignedUsername = snapshot[FAVOR_ASSIGNED_USERNAME];
    description = snapshot[FAVOR_DESCRIPTION];
    location = snapshot[FAVOR_LOCATION];
    title = snapshot[FAVOR_TITLE];
    key = snapshot[FAVOR_KEY];
    status = snapshot[FAVOR_STATUS].toString();
    timestamp = snapshot[FAVOR_TIMESTAMP];
    user = snapshot[FAVOR_USER];
    username = snapshot[FAVOR_USERNAME];
  }
}
