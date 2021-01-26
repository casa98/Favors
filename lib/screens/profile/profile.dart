import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Profile extends StatefulWidget {
  final String _title;

  Profile(this._title);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var firestoreRef = FirebaseFirestore.instance
        .collection(USER)
        .doc(FirebaseAuth.instance.currentUser.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
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
                    onPressed: () {
                      // TODO Show Dialog to choose Camera or Gallery
                      _takePhoto(ImageSource.gallery);
                    },
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

  Future _takePhoto(ImageSource source) async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if(permissionStatus.isGranted){
      final pickedFile = await picker.getImage(source: source, maxHeight: 512, maxWidth: 512);
      if(pickedFile != null){
        _image = File(pickedFile.path);
        print("IMAGE PATH: " + _image.toString());
        //TODO Upload image to Firestore or another place
      }else{
        print("NOT IMAGE SELECTED");
      }
    }
  }
}
