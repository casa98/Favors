import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatelessWidget {
  final String _title;
  Profile(this._title);

  @override
  Widget build(BuildContext context) {
    var firestoreRef = FirebaseFirestore.instance
        .collection(USER)
        .doc(FirebaseAuth.instance.currentUser.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: StreamBuilder(
        stream: firestoreRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              var userDocument = snapshot.data;
              bool hasImage = userDocument[IMAGE] == '' ? false : true;
              String image = '';
              if (hasImage)
                image = userDocument[IMAGE];
              else
                image =
                    'https://cdn.iconscout.com/icon/free/png-512/github-163-761603.png';
              return Column(
                children: [
                  SizedBox(height: 24.0),
                  CircleAvatar(
                    maxRadius: 80,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: NetworkImage(
                      image,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {},
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                      child: Text(CHANGE_PHOTO),
                    ),
                  ),
                  Divider(
                    height: 32.0,
                    thickness: 2.0,
                    indent: 32.0,
                    endIndent: 32.0,
                  ),
                  Text(
                    userDocument[USERNAME],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    userDocument[EMAIL],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Score:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        userDocument[SCORE].toString() + ' points',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: MaterialButton(
                          color: Colors.red,
                          onPressed: () async {
                            FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                            child: Text(
                              SIGN_OUT,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
