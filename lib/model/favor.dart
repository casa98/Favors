import 'package:do_favors/shared/constants.dart';

class Favor {
  late String? assignedUser;
  late String? assignedUsername;
  late String description;
  late String location;
  late String title;
  late String? key;
  late String? status;
  late int? timestamp;
  late String user;
  late String username;

  Favor({
    this.assignedUser,
    this.assignedUsername,
    required this.description,
    required this.location,
    required this.title,
    this.key,
    this.status,
    this.timestamp,
    required this.user,
    required this.username,
  });

  Favor.fromDocumentSnapShot(Map<String, dynamic> doc) {
    assignedUser = doc[FAVOR_ASSIGNED_USER];
    assignedUsername = doc[FAVOR_ASSIGNED_USERNAME];
    description = doc[FAVOR_DESCRIPTION];
    location = doc[FAVOR_LOCATION];
    title = doc[FAVOR_TITLE];
    key = doc[FAVOR_KEY];
    status = doc[FAVOR_STATUS].toString();
    timestamp = doc[FAVOR_TIMESTAMP];
    user = doc[FAVOR_USER];
    username = doc[FAVOR_USERNAME];
  }
}
