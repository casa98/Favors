import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'package:do_favors/shared/constants.dart';

class HomeBloc {

  Stream<bool> get showFloatingButton =>
      _showFloatingButtonSubject.stream;

  final _showFloatingButtonSubject = PublishSubject<bool>();

  void canUserRequestFavors() {
    FirebaseFirestore.instance
        .collection(USER)
        .doc(FirebaseAuth.instance.currentUser!.uid).get().then((result) {
          if(result[SCORE] >= 2){
            _showFloatingButtonSubject.sink.add(true);
          }else{
            _showFloatingButtonSubject.sink.add(false);
          }
    });
  }

  dispose(){
    _showFloatingButtonSubject.close();
  }
}