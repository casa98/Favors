import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_favors/shared/constants.dart';

class Favor {
  String assignedUser;
  String assignedUsername;
  String description;
  String location;
  String title;
  String key;
  String status;
  int timestamp;
  String user;
  String username;

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
      this.username);

  Favor.fromDocumentSnapShot(DocumentSnapshot snapshot){
    assignedUser = snapshot.data()[FAVOR_ASSIGNED_USER];
    assignedUsername = snapshot.data()[FAVOR_ASSIGNED_USERNAME];
    description = snapshot.data()[FAVOR_DESCRIPTION];
    location = snapshot.data()[FAVOR_LOCATION];
    title = snapshot.data()[FAVOR_TITLE];
    key = snapshot.data()[FAVOR_KEY];
    status = snapshot.data()[FAVOR_STATUS].toString();
    timestamp = snapshot.data()[FAVOR_TIMESTAMP];
    user = snapshot.data()[FAVOR_USER];
    username = snapshot.data()[FAVOR_USERNAME];
  }
}
