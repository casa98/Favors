import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_favors/shared/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  final String _title;
  Statistics(this._title);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final User currentUser = FirebaseAuth.instance.currentUser;

  var firestoreRef = FirebaseFirestore.instance
      .collection(USER)
      .orderBy(SCORE, descending: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._title),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: firestoreRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                List item = [];
                snapshot.data.docs.forEach((element) {
                  item.add(element.data());
                });
                //
                return ListView.separated(
                  itemCount: item.length,
                  separatorBuilder: (context, index) => Divider(height: 0.0),
                  itemBuilder: (context, index) {
                    var userItem = item[index];
                    var score = userItem[SCORE].toString() + ' points';
                    return ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: userItem[IMAGE] != ''
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: userItem[IMAGE],
                              )
                            : CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.primaries[
                                    Random().nextInt(Colors.accents.length)],
                                child: Text(
                                  Util.lettersForHeader(userItem[USERNAME]),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                      ),
                      title: Text(
                        userItem[USERNAME],
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(userItem[EMAIL]),
                      trailing: Text(score),
                      onTap: () {},
                    );
                  },
                );
              //
            }
          },
        ));
  }
}
