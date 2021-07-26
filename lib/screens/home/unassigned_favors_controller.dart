import 'dart:async';

import 'package:do_favors/model/favor.dart';
import 'package:do_favors/services/database.dart';

class UnassignedFavorsController {
  final _unassignedFavorsList = StreamController<List<Favor>>();
  Stream<List<Favor>> get unassignedFavorsList => _unassignedFavorsList.stream;

  fetchUnassignedFavors() async {
    final dbQuery = await DatabaseService().fetchUnassignedFavors();

    List<Favor> favors = dbQuery.docs.map((i) =>
        Favor.fromDocumentSnapShot(i.data())).toList();
    _unassignedFavorsList.add(favors);
  }
}
