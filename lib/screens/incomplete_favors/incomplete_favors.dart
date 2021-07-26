import 'dart:io';

import 'package:do_favors/services/database.dart';
import 'package:do_favors/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:do_favors/screens/incomplete_favors/incomplete_favors_controller.dart';
import 'package:do_favors/model/favor.dart';
import 'package:do_favors/shared/util.dart';

class IncompleteFavors extends StatefulWidget {
  final String _title;
  IncompleteFavors(this._title);

  @override
  _IncompleteFavorsState createState() => _IncompleteFavorsState();
}

class _IncompleteFavorsState extends State<IncompleteFavors> {

  final _incompleteFavors = IncompleteFavorsController();

  @override
  void initState() {
    _incompleteFavors.fetchIncompleteFavors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder<List<Favor>>(
          stream: _incompleteFavors.incompleteFavorsList,
          builder: (context, snapshot){
            if(snapshot.hasError) throw('Snapshot Error: ${snapshot.error}');
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                final favors = snapshot.data ?? [];
                if(favors.isEmpty){
                  return Center(
                    child: Text(
                      'You don\'t have pending favors to complete',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  );
                }
                return SafeArea(
                  child: ListView.separated(
                    itemCount: favors.length,
                    separatorBuilder: (context, index) => Divider(height: 0.0),
                    itemBuilder: (context, index) {
                      var favor = favors[index];
                      return ListTile(
                        title: Text(
                          favor.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(favor.description,
                            overflow: TextOverflow.ellipsis),
                        trailing: Text(
                          Util.readFavorTimestamp(favor.timestamp),
                        ),
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (_){
                              return incompleteFavorDialog(
                                title: 'Mark as completed',
                                text: 'Have you completed this favor?',
                                favorId: favor.key,
                                assignedUser: favor.assignedUser!,
                              );
                            }
                          );
                        },
                      );
                    },
                  ),
                );
            }
          },
      )),
    );
  }

  incompleteFavorDialog({
    required String title,
    required String text,
    required String favorId,
    required String assignedUser,
  }){
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            content: Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () {
                  // Mark as completed
                  DatabaseService().markFavorAsCompleted(favorId, assignedUser);
                  Navigator.of(context).pop();
                  CustomSnackbar.customScaffoldMessenger(
                    context: context,
                    text: 'Favor marked as completed',
                    iconData: Icons.done,
                  );
                },
              ),
            ],
          )
        : AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Mark as completed
                  DatabaseService().markFavorAsCompleted(favorId, assignedUser);
                  Navigator.of(context).pop();
                  CustomSnackbar.customScaffoldMessenger(
                    context: context,
                    text: 'Favor marked as completed',
                    iconData: Icons.done,
                  );
                },
                child: Text('Yes'),
              ),
            ],
    );
  }
}
