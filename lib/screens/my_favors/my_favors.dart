import 'package:do_favors/model/favor.dart';
import 'package:do_favors/services/database.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:do_favors/shared/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      .where(FAVOR_USER, isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
            builder: (context, snapshot) {
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
                      child: Text(
                        'You haven\'t requested any favors yet',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    );
                  return ListView.separated(
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
                                      'Delete favor',
                                      'Sure you want to delete this favor?',
                                      true,
                                      currentFavor[FAVOR_KEY],
                                      null);
                                });
                            print(data);
                            if (data == DELETE) {
                              myFavorSnackbar(context,
                                  Icons.delete_forever_rounded, 'Favor deleted');
                            }
                          }
                          if (currentFavor[FAVOR_STATUS] == ASSIGNED) {
                            var data = await showDialog(
                                context: context,
                                builder: (context) {
                                  return myFavorsDialog(
                                      'Mark as completed',
                                      'Has your peer completed this favor?',
                                      false,
                                      currentFavor[FAVOR_KEY],
                                      currentFavor[FAVOR_ASSIGNED_USER]);
                                });
                            if (data == COMPLETE) {
                              myFavorSnackbar(
                                  context,
                                  Icons.sentiment_satisfied_alt,
                                  'Favor marked as completed');
                            }
                          }
                        },
                      );
                    },
                  );
                //
              }
            },
          ),
        ));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> myFavorSnackbar(
      BuildContext context, IconData icon, String text) {
    return Scaffold.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(icon),
            SizedBox(width: 20.0),
            Expanded(
              child: Text(text),
            ),
          ],
        ),
        duration: Duration(seconds: 2)));
  }

  AlertDialog myFavorsDialog(String title, String text, bool delete,
      String favorId, String assignedUser) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('NO'),
        ),
        FlatButton(
          onPressed: () {
            if (delete) {
              // Delete favor
              DatabaseService().deleteFavor(favorId);
              Navigator.of(context).pop(DELETE);
            } else {
              // Mark as completed
              DatabaseService().markFavorAsCompleted(favorId, assignedUser);
              Navigator.of(context).pop(COMPLETE);
            }
          },
          child: Text('YES'),
        ),
      ],
    );
  }
}
