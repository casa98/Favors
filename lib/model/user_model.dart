import 'package:do_favors/shared/constants.dart';

class UserModel {
  String? id = '';
  String? name = '';
  String? email = '';
  int? score = 0;
  String? photoUrl = '';

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
