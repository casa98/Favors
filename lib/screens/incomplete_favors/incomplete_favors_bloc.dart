import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_favors/model/favor.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class IncompleteFavorsBloc {

  Stream<bool> get showLoadingIndicator =>
      _showLoadingIndicatorSubject.stream;

  Stream<bool> get incompleteFavors =>
      _showLoadingIndicatorSubject.stream;

  final _showLoadingIndicatorSubject = PublishSubject<bool>();
  final _incompleteFavorsSubject = PublishSubject<List<FavorDetailsObject>>();

  var firestoreRef = FirebaseFirestore.instance
      .collection(FAVORS)
      .where(FAVOR_STATUS, isEqualTo: 1)
      .where(FAVOR_ASSIGNED_USER,
      isEqualTo: FirebaseAuth.instance.currentUser.uid)
      .orderBy(FAVOR_TIMESTAMP, descending: true);

  loadIncompleteFavors() {
    _showLoadingIndicatorSubject.sink.add(true);
    // TOOD Execute query defined above
  }

  dispose(){
    _showLoadingIndicatorSubject.close();
    _incompleteFavorsSubject.close();
  }
}