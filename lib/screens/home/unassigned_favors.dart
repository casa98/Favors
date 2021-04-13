import 'package:do_favors/model/favor.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UnassignedFavors extends StatefulWidget {
  @override
  _UnassignedFavorsState createState() => _UnassignedFavorsState();
}

class _UnassignedFavorsState extends State<UnassignedFavors> {
  var firestoreRef = FirebaseFirestore.instance
      .collection(FAVORS)
      .where(FAVOR_STATUS, isEqualTo: -1)
      .orderBy(FAVOR_TIMESTAMP, descending: true);
  final User currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            List item = [];
            snapshot.data.docs.forEach((element) {
              if (element.data()[FAVOR_USER].toString() != currentUser.uid)
                item.add(element.data());
            });
            if (item.length == 0)
              return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Text(
                  'No favors to do, yet',
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
                return ListTile(
                  title: Text(
                    currentFavor[FAVOR_TITLE],
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(currentFavor[FAVOR_DESCRIPTION],
                      overflow: TextOverflow.ellipsis),
                  trailing: Text(
                    Util().readFavorTimestamp(currentFavor[FAVOR_TIMESTAMP]),
                  ),
                  onTap: () {
                    Favor tappedFavor = Favor(
                      '',
                      '',
                      currentFavor[FAVOR_DESCRIPTION],
                      currentFavor[FAVOR_LOCATION],
                      currentFavor[FAVOR_TITLE],
                      currentFavor[FAVOR_KEY],
                      '',
                      0,
                      '',
                      currentFavor[FAVOR_USERNAME]
                    );
                    Navigator.pushNamed(
                      context,
                      Strings.favorDetailsRoute,
                      arguments: tappedFavor,
                    );
                  },
                );
              },
            );
        }
      },
    );
  }
}
