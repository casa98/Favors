import 'dart:async';

import 'package:do_favors/model/favor.dart';
import 'package:do_favors/services/database.dart';

class IncompleteFavorsController {
  final _incompleteFavorsList = StreamController<List<Favor>>();
  Stream<List<Favor>> get incompleteFavorsList => _incompleteFavorsList.stream;

  fetchIncompleteFavors() async {
    final dbQuery = await DatabaseService().fetchIncompleteFavors();

    List<Favor> favors = dbQuery.docs.map((i) =>
        Favor.fromDocumentSnapShot(i.data())).toList();
    _incompleteFavorsList.add(favors);
  }
}