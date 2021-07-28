import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/services/database.dart';
import 'package:do_favors/widgets/custom_snackbar.dart';
import 'package:do_favors/screens/incomplete_favors/incomplete_favors_controller.dart';
import 'package:do_favors/model/favor.dart';
import 'package:do_favors/shared/util.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/widgets/no_items.dart';

class IncompleteFavors extends StatefulWidget {
  @override
  _IncompleteFavorsState createState() => _IncompleteFavorsState();
}

class _IncompleteFavorsState extends State<IncompleteFavors> {

  late final _incompleteFavorsController;

  @override
  void didChangeDependencies() {
    _incompleteFavorsController = IncompleteFavorsController(
      context.read<UserProvider>(),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.incompleteFavorsTitle),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _incompleteFavorsController.fetchIncompleteFavors(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if(snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));

              List<Favor> favors = Util.fromDocumentToFavor(snapshot.data!.docs);
              print('Incomplete Favors length: ${favors.length}');
              if(favors.isEmpty)
                return NoItems(text: 'You don\'t have pending favors to complete');

              return SafeArea(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
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
      ),
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
                  // Increase currentUser score
                  final currentUserScore =
                      _incompleteFavorsController.currentUser.score;
                  _incompleteFavorsController.currentUser.score =
                      currentUserScore + 2;
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
                  // Increase currentUser score
                  final currentUserScore = _incompleteFavorsController
                      .userProvider.currentUser.score;
                  _incompleteFavorsController
                      .userProvider.updateUserScore(currentUserScore + 2);
                },
                child: Text('Yes'),
              ),
            ],
    );
  }
}