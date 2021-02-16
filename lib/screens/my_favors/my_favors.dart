import 'package:do_favors/model/favor.dart';
import 'package:do_favors/screens/my_favors/my_favors_controller.dart';
import 'package:do_favors/services/database.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:do_favors/shared/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    int unassigned = 0, assigned = 0, completed = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._title),
          centerTitle: true,
        ),
        body: Center(
          child: GetBuilder<MyFavorsController>(
            init: Get.put<MyFavorsController>(MyFavorsController()),
            builder: (value) {
              return FutureBuilder<List<Favor>>(
                future: value.getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());

                    default:
                      List<Favor> myFavorsInitial = snapshot.data;
                      List<Favor> myFavors = [];
                      myFavors.add(
                          Favor('', '', '', '', '', UNASSIGNED, '', 0, '', ''));
                      myFavorsInitial.forEach((element) {
                        if (element.status == "-1") {
                          unassigned++;
                          myFavors.add(element);
                        }
                      });
                      myFavors.add(
                          Favor('', '', '', '', '', ASSIGNED, '', 0, '', ''));
                      myFavorsInitial.forEach((element) {
                        if (element.status == "1") {
                          assigned++;
                          myFavors.add(element);
                        }
                      });
                      myFavors.add(
                          Favor('', '', '', '', '', COMPLETED, '', 0, '', ''));
                      myFavorsInitial.forEach((element) {
                        if (element.status == "0") {
                          completed++;
                          myFavors.add(element);
                        }
                      });

                      if (myFavors.length == 0)
                        return Padding(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: Text(
                              'You haven\'t requested any favors yet',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ));

                      return ListView.separated(
                        itemCount: myFavors.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 0.0),
                        itemBuilder: (context, index) {
                          var currentFavor = myFavors[index];
                          if (currentFavor.status == "-1")
                            currentFavor.status = UNASSIGNED;
                          else if (currentFavor.status == "1")
                            currentFavor.status = ASSIGNED;
                          else
                            currentFavor.status = COMPLETED;

                          if (currentFavor.key == UNASSIGNED)
                            return headerLabel("Unassigned", unassigned);
                          if (currentFavor.key == ASSIGNED)
                            return headerLabel("Assigned", assigned);
                          if (currentFavor.key == COMPLETED)
                            return headerLabel("Completed", completed);

                          return ListTile(
                            title: Text(
                              currentFavor.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Row(
                              children: [
                                Text(STATUS),
                                SizedBox(width: 10.0),
                                Text(
                                  currentFavor.status,
                                ),
                              ],
                            ),
                            trailing: Text(
                              Util().readFavorTimestamp(currentFavor.timestamp),
                            ),
                            onTap: () async {
                              // showDialog returns a value, it's sent via pop()
                              if (currentFavor.status == UNASSIGNED) {
                                var data = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return myFavorsDialog(
                                          'Delete favor',
                                          'Sure you want to delete this favor?',
                                          true,
                                          currentFavor.key,
                                          null);
                                    });
                                print(data);
                                if (data == DELETE) {
                                  myFavorSnackbar(
                                      context,
                                      Icons.delete_forever_rounded,
                                      'Favor deleted');
                                }
                              }
                              if (currentFavor.status == ASSIGNED) {
                                var data = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return myFavorsDialog(
                                          'Mark as completed',
                                          'Has your peer completed this favor?',
                                          false,
                                          currentFavor.key,
                                          currentFavor.assignedUser);
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
                  }
                },
              );
              //
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

  Widget headerLabel(String label, int quantity) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      padding: EdgeInsets.all(12.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: Color(0xff5890c5),
            ),
          ),
          Text(
            "  ($quantity)",
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: Color(0xff5890c5),
            ),
          ),
        ],
      ),
    );
  }
}
