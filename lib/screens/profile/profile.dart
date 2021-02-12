import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_favors/screens/profile/profile_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../app_state_notifier.dart';

class Profile extends StatefulWidget {
  final String _title;

  Profile(this._title);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;
  final picker = ImagePicker();
  ProfileBloc _profileBloc = ProfileBloc();

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
              String image = userDocument[IMAGE];
              return Column(
                children: [
                  SizedBox(height: 24.0),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: StreamBuilder<bool>(
                        stream: _profileBloc.showLoadingIndicator,
                        initialData: false,
                      builder: (context, snapshot) {
                        return !snapshot.data ? CachedNetworkImage(
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                          imageUrl: image,
                          placeholder: (context, url) => image != ''
                              ? _circularProgressIndicator()
                              : _profileImage(),
                          errorWidget: (context, url, error) =>
                              _profileImage(),
                        ) : Center(child: Text('Uploading...'),);
                      }
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      containerForSheet<String>(
                        context: context,
                        child: _galleryOrCamera(),
                      );
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
                  SizedBox(width: 10.0),
                  Switch(
                    value: Provider.of<AppStateNotifier>(context).isDarkMode,
                    onChanged: (boolVal) {
                      Provider.of<AppStateNotifier>(context, listen: false).updateTheme(boolVal);
                    },
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

  Widget _profileImage(){
    return Container(
      child: Center(
        child: Image.asset(
          'assets/no-photo.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }

  Widget _circularProgressIndicator(){
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 4.0,
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
        _profileBloc.uploadPicture(_image);
      }else{
        print("NOT IMAGE SELECTED");
      }
    }
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  Widget _galleryOrCamera(){
    return CupertinoActionSheet(
      title: Text(CHOOSE_OPTION),
      actions: [
        CupertinoActionSheetAction(
          onPressed: (){
            Navigator.pop(context);
            _takePhoto(ImageSource.camera);
          },
          child: Text(TAKE_A_PHOTO),
        ),
        CupertinoActionSheetAction(
          onPressed: (){
            Navigator.pop(context);
            _takePhoto(ImageSource.gallery);
          },
          child: Text(CHOOSE_PHOTO),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: (){
          Navigator.pop(context);
        },
        child: Text(CANCEL),
      ),
    );
  }
}
