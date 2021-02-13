import 'package:do_favors/screens/add_favor/add_favor.dart';
import 'package:do_favors/screens/home/home_bloc.dart';
import 'package:do_favors/screens/home/unassigned_favors.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:do_favors/screens/drawer/drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String _title;
  HomePage(this._title);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = HomeBloc();
    _homeBloc.canUserRequestFavors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: Center(
        child: UnassignedFavors(),
      ),
      floatingActionButton: StreamBuilder(
        stream: _homeBloc.showFloatingButton,
        initialData: false,
        builder: (context, snapshot) {
          return snapshot.data ? FloatingActionButton(
              onPressed: () => _addFavorModalBottomSheet(context),
              tooltip: ASK_FOR_A_FAVOR,
              child: Icon(Icons.add),
            )
          : Text('');
        },
      ),
    );
  }
}

void _addFavorModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext bd) {
        return AddFavor();
      });
}
