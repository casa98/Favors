import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/screens/profile/profile_controller.dart';
import 'package:do_favors/shared/constants.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late File _image;
  late String asset;
  final picker = ImagePicker();
  late UserProvider _currentUser;
  late final ProfileController _profileController;

  @override
  void didChangeDependencies() {
    _currentUser = context.read<UserProvider>();
    _profileController = ProfileController(_currentUser);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Profile Score: ${_currentUser.score}");
    final ThemeData theme = Theme.of(context);
    asset = theme.brightness == Brightness.light
        ? 'assets/no-photo.png'
        : 'assets/no-photo-dark.png';

    String image = _currentUser.photoUrl ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(Strings.profileTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 24.0),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                clipBehavior: Clip.antiAlias,
                child: StreamBuilder<bool>(
                    stream: _profileController.showLoadingIndicator,
                    initialData: false,
                    builder: (context, AsyncSnapshot snapshot) {
                      return !snapshot.data
                          ? CachedNetworkImage(
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                              imageUrl: image,
                              placeholder: (context, url) => image != ''
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4.0,
                                      ),
                                    )
                                  : _profileImage(),
                              errorWidget: (_, __, ___) => _profileImage(),
                            )
                          : Center(
                              child: Text('Uploading...'),
                            );
                    }),
              ),
              SizedBox(height: 12.0),
              CupertinoButton(
                child: Text(
                  _currentUser.photoUrl == ''
                      ? 'Set Profile Photo'
                      : 'Change Photo',
                  style: TextStyle(color: Color(0xff5890c5)),
                ),
                onPressed: () => _chooseImageSource(),
              ),
              SizedBox(height: 12.0),
              Divider(
                height: 0.0,
                thickness: 0.8,
              ),
              ListTile(
                tileColor: Theme.of(context).backgroundColor,
                title: Text(_currentUser.name ?? ''),
                trailing: Icon(Icons.edit),
              ),
              Divider(height: 0.0, thickness: 0.8),
              ListTile(
                tileColor: Theme.of(context).backgroundColor,
                title: Text(_currentUser.email ?? ''),
                trailing: Text('verified'),
              ),
              Divider(height: 0.0, thickness: 0.8),
              ListTile(
                tileColor: Theme.of(context).backgroundColor,
                title: Text(
                  _currentUser.score != null
                      ? 'Score: ${_currentUser.score} points'
                      : '',
                ),
                trailing: Icon(Icons.payment),
              ),
              Divider(height: 0.0, thickness: 0.8),
              SizedBox(height: 12.0),
              CupertinoButton(
                child: Text(
                  Strings.signOut,
                  style: TextStyle(color: Colors.redAccent[200]),
                ),
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  _profileController.clearProvider();
                },
              ),
              SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }

  _chooseImageSource() {
    Platform.isIOS
        ? containerForSheet<String>(
            context: context,
            child: _iOSPhotoChooser(),
          )
        : showModalBottomSheet(
            context: context,
            builder: (context) => androidPhotoChooser(),
          );
  }

  Widget _profileImage() {
    return CupertinoButton(
      onPressed: () => _chooseImageSource(),
      child: Center(
        child: Icon(
          Icons.add_a_photo_rounded,
          size: 80,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Future _takePhoto(ImageSource source) async {
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      final pickedFile =
          await picker.pickImage(source: source, maxHeight: 512, maxWidth: 512);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("IMAGE PATH: " + _image.toString());
        _profileController.uploadPicture(_image);
      } else {
        print("NOT IMAGE SELECTED");
      }
    } else {
      openAppSettings();
    }
  }

  void containerForSheet<String>({
    required BuildContext context,
    required Widget child,
  }) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  Widget androidPhotoChooser() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(
            Icons.camera_alt,
            color: Theme.of(context).primaryColor,
          ),
          title: Text('Camera'),
          onTap: () {
            Navigator.pop(context);
            _takePhoto(ImageSource.camera);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.photo,
            color: Theme.of(context).primaryColor,
          ),
          title: Text('Gallery'),
          onTap: () {
            Navigator.pop(context);
            _takePhoto(ImageSource.gallery);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.cancel,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(CANCEL),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _iOSPhotoChooser() {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            _takePhoto(ImageSource.camera);
          },
          child: Text(TAKE_A_PHOTO),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            _takePhoto(ImageSource.gallery);
          },
          child: Text(CHOOSE_PHOTO),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(CANCEL),
      ),
    );
  }
}
