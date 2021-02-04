class Favor {
  String assignedUser;
  String assignedUsername;
  String favorDescription;
  String favorLocation;
  String favorTitle;
  String key;
  int status;
  int timestamp;
  String user;
  String username;

  Favor(
      this.assignedUser,
      this.assignedUsername,
      this.favorDescription,
      this.favorLocation,
      this.favorTitle,
      this.key,
      this.status,
      this.timestamp,
      this.user,
      this.username);

  Favor.fromJson(Map<String, Object> json){
    assignedUser = json['assignedUser'];
    assignedUsername = json['assignedUsername'];
    favorDescription = json['favorDescription'];
    favorLocation = json['favorLocation'];
    favorTitle = json['favorTitle'];
    key = json['key'];
    status = json['status'];
    timestamp = json['timestamp'];
    user = json['user'];
    username = json['username'];
  }
}
