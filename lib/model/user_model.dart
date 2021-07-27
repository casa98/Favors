import 'package:do_favors/shared/constants.dart';

class UserModel {
  late String id;
  late String name;
  late String email;
  late int score;
  late String photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.score,
    required this.photoUrl,
  });

  UserModel.fromDocumentSnapShot(Map<String, dynamic> json){
    id = json[UID];
    name = json[USERNAME];
    email = json[EMAIL];
    score = json[SCORE];
    photoUrl = json[IMAGE];
  }
}
