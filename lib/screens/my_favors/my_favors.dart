import 'dart:io';

import 'package:do_favors/widgets/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:do_favors/services/database.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:do_favors/shared/util.dart';

const String COMPLETE = 'completed';
const String DELETE = 'deleted';

class MyFavors extends StatefulWidget {
  final String _title;
  MyFavors(this._title);

  @override
  _MyFavorsState createState() => _MyFavorsState();
}

class _MyFavorsState extends State<MyFavors> {
  var firestoreRef = FirebaseFirestore.instance
      .collection(FAVORS)
      .where(FAVOR_USER, isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy(FAVOR_TIMESTAMP, descending: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
          stream: firestoreRef.snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                List item = [];
                snapshot.data.docs.forEach((element) {
                  item.add(element.data());
                });
                if (item.length == 0)
                  return Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Center(
                      child: Text(
                        'You haven\'t requested any favors yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                return SafeArea(
                  child: ListView.separated(
                    itemCount: item.length,
                    separatorBuilder: (context, index) => Divider(height: 0.0),
                    itemBuilder: (context, index) {
                      var currentFavor = item[index];
                      if (currentFavor[FAVOR_STATUS] == -1)
                        currentFavor[FAVOR_STATUS] = UNASSIGNED;
                      else if (currentFavor[FAVOR_STATUS] == 1)
                        currentFavor[FAVOR_STATUS] = ASSIGNED;
                      else
                        currentFavor[FAVOR_STATUS] = COMPLETED;

                      return ListTile(
                        title: Text(
                          currentFavor[FAVOR_TITLE],
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Row(
                          children: [
                            Text(STATUS),
                            SizedBox(width: 10.0),
                            Text(
                              currentFavor[FAVOR_STATUS],
                            ),
                          ],
                        ),
                        trailing: Text(
                          Util.readFavorTimestamp(currentFavor[FAVOR_TIMESTAMP]),
                        ),
                        onTap: () async {
                          // showDialog returns a value, it's sent via pop()
                          if (currentFavor[FAVOR_STATUS] == UNASSIGNED) {
                            var data = await showDialog(
                                context: context,
                                builder: (context) {
                                  return myFavorsDialog(
                                      title: 'Delete favor',
                                      text: 'Sure you want to delete this favor?',
                                      delete: true,
                                      favorId: currentFavor[FAVOR_KEY],
                                  );
                                });
                            print(data);
                            if (data == DELETE) {
                              CustomSnackbar.customScaffoldMessenger(
                                context: context,
                                text: 'Favor Deleted',
                                iconData: Icons.delete_forever_rounded,
                              );
                            }
                          }
                          if (currentFavor[FAVOR_STATUS] == ASSIGNED) {
                            var data = await showDialog(
                                context: context,
                                builder: (context) {
                                  return myFavorsDialog(
                                      title: 'Mark as completed',
                                      text: 'Has your peer completed this favor?',
                                      favorId: currentFavor[FAVOR_KEY],
                                      assignedUser: currentFavor[FAVOR_ASSIGNED_USER],
                                  );
                                });
                            if (data == COMPLETE) {
                              CustomSnackbar.customScaffoldMessenger(
                                context: context,
                                text: 'Favor marked as completed',
                                iconData: Icons.done,
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                );
              //
            }
          },
        ),
      ),
    );
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
                if (delete) {
                  // Delete favor
                  DatabaseService().deleteFavor(favorId);
                  Navigator.of(context).pop(DELETE);
                } else {
                  // Mark as completed
                  DatabaseService().markFavorAsCompleted(favorId, assignedUser!);
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
                    DatabaseService().markFavorAsCompleted(favorId, assignedUser!);
                    Navigator.of(context).pop(COMPLETE);
                  }
                },
                child: Text('Yes'),
              ),
            ],
          );
  }
}
