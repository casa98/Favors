import 'dart:io';
import 'package:do_favors/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/model/favor.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/screens/my_favors/my_favors_controller.dart';
import 'package:do_favors/widgets/custom_snackbar.dart';
import 'package:do_favors/widgets/no_items.dart';
import 'package:do_favors/services/database.dart';
import 'package:do_favors/shared/util.dart';

const String COMPLETE = 'completed';
const String DELETE = 'deleted';

class MyFavors extends StatefulWidget {
  @override
  _MyFavorsState createState() => _MyFavorsState();
}

class _MyFavorsState extends State<MyFavors> {
  late final MyFavorsController _myFavorsController;

  @override
  void didChangeDependencies() {
    _myFavorsController = MyFavorsController(context.read<UserProvider>());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.myFavorsTitle),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _myFavorsController.fetchMyFavors(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));

              List<Favor> favors =
                  Util.fromDocumentToFavor(snapshot.data!.docs);
              if (favors.isEmpty)
                return NoItems(text: 'You haven\'t requested any favors yet');

              return SafeArea(
                child: ImplicitlyAnimatedList<Favor>(
                  insertDuration: Duration(milliseconds: 300),
                  removeDuration: Duration(milliseconds: 300),
                  physics: BouncingScrollPhysics(),
                  items: favors,
                  areItemsTheSame: (a, b) => a.key == b.key,
                  itemBuilder: (context, animation, favor, index) {
                    return SizeFadeTransition(
                      sizeFraction: 0.7,
                      curve: Curves.easeInOut,
                      animation: animation,
                      child: ListTile(
                        title: Text(
                          favor.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${Strings.favorStatus} ${_getFavorStatus(favor.status!)}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          Util.readFavorTimestamp(favor.timestamp!),
                        ),
                        onTap: () async {
                          // showDialog returns a value, it's sent via pop()
                          if (favor.status == "-1") {
                            // Favor Unassigned, can be deleted
                            var choice = await showDialog(
                              context: context,
                              builder: (context) {
                                return myFavorsDialog(
                                  title: 'Delete Favor',
                                  text: 'Sure you want to delete this favor?',
                                  delete: true,
                                  favorId: favor.key!,
                                );
                              },
                            );
                            if (choice == DELETE) {
                              CustomSnackbar.customScaffoldMessenger(
                                context: context,
                                text: 'Favor Deleted',
                                iconData: Icons.delete_forever_rounded,
                              );
                            }
                          } else if (favor.status == "1" ||
                              favor.status == "2") {
                            // Favor Assigned or missing to Confirm Completion
                            var choice = await showDialog(
                              context: context,
                              builder: (context) {
                                return myFavorsDialog(
                                  title: favor.status == Strings.favorAssigned
                                      ? 'Mark as Completed'
                                      : 'Confirm Completion',
                                  text:
                                      'Has ${favor.assignedUsername} completed this favor?',
                                  favorId: favor.key!,
                                  assignedUser: favor.assignedUser,
                                );
                              },
                            );
                            if (choice == COMPLETE) {
                              CustomSnackbar.customScaffoldMessenger(
                                context: context,
                                text: 'Favor marked as Completed',
                                iconData: Icons.done,
                              );

                              DatabaseService()
                                  .increaseUserScore(favor.assignedUser!);

                              ApiService().sendNotification(
                                to: favor.assignedUser!,
                                title: 'Your score Increased!',
                                body:
                                    '${favor.username} confirmed you completed their favor',
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            //
          }
        },
      ),
    );
  }

  String _getFavorStatus(String status) {
    switch (status) {
      case "-1":
        return Strings.favorUnassigned;
      case "1":
        return Strings.favorAssigned;
      case "2":
        return Strings.favorCompletedButUnconfirmed;
      case "0":
        return Strings.favorCompletedAndConfirmed;
      default:
        return status;
    }
  }

  myFavorsDialog({
    required String title,
    required String text,
    bool delete = false,
    required String favorId,
    String? assignedUser,
  }) {
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
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  if (delete) {
                    // Delete favor
                    DatabaseService().deleteFavor(favorId);
                    Navigator.of(context).pop(DELETE);
                  } else {
                    // Mark as completed
                    DatabaseService()
                        .markFavorAsCompletedConfirmed(favorId, assignedUser!);
                    Navigator.of(context).pop(COMPLETE);
                  }
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
                  if (delete) {
                    // Delete favor
                    DatabaseService().deleteFavor(favorId);
                    Navigator.of(context).pop(DELETE);
                  } else {
                    // Mark as completed
                    DatabaseService()
                        .markFavorAsCompletedConfirmed(favorId, assignedUser!);
                    Navigator.of(context).pop(COMPLETE);
                  }
                },
                child: Text('Yes'),
              ),
            ],
          );
  }
}
