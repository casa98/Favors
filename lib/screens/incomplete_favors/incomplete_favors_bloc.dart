import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_favors/model/favor.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class IncompleteFavorsBloc {

  Stream<bool> get showLoadingIndicator =>
      _showLoadingIndicatorSubject.stream;

  Stream<List<Favor>> get incompleteFavors =>
      _incompleteFavorsSubject.stream;

  final _showLoadingIndicatorSubject = PublishSubject<bool>();
  final _incompleteFavorsSubject = PublishSubject<List<Favor>>();

  var _firestoreRef = FirebaseFirestore.instance
      .collection(FAVORS)
      .where(FAVOR_STATUS, isEqualTo: 1)
      .where(FAVOR_ASSIGNED_USER,
      isEqualTo: FirebaseAuth.instance.currentUser.uid)
      .orderBy(FAVOR_TIMESTAMP, descending: true);

  loadIncompleteFavors() {
    _showLoadingIndicatorSubject.sink.add(true);
    _firestoreRef.get().then((result) {
      _showLoadingIndicatorSubject.sink.add(false);
      if(result.docs.isNotEmpty) {
        List<Favor> favorsList = [];
        result.docs.forEach((element) {
          favorsList.add(Favor.fromJson(element.data()));
        });
        print("FAVORS::::::::::::::::" + favorsList.length.toString());
        _incompleteFavorsSubject.sink.add(favorsList);
      }
    });
  }

  dispose(){
    _showLoadingIndicatorSubject.close();
    _incompleteFavorsSubject.close();
  }
}