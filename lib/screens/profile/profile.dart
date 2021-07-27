import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:do_favors/model/user_model.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/widgets/action_button.dart';
import 'package:do_favors/screens/profile/profile_bloc.dart';
import 'package:do_favors/shared/constants.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late File _image;
  late String asset;
  final picker = ImagePicker();
  late UserProvider _userProvider;
  late UserModel _currentUser;
  late ProfileBloc _profileBloc;

  @override
  void didChangeDependencies() {
    _userProvider = context.watch<UserProvider>();
    _currentUser = _userProvider.currentUser;
    _profileBloc = ProfileBloc(userProvider: _userProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    asset = theme.brightness == Brightness.light
        ? 'assets/no-photo.png'
        : 'assets/no-photo-dark.png';

    String image = _currentUser.photoUrl;
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.profileTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 24.0),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                clipBehavior: Clip.antiAlias,
                child: StreamBuilder<bool>(
                    stream: _profileBloc.showLoadingIndicator,
                    initialData: false,
                    builder: (context, AsyncSnapshot snapshot) {
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
              ActionButton(
                title: Strings.changePhoto,
                onPressed: () {
                  containerForSheet<String>(
                    context: context,
                    child: _galleryOrCamera(),
                  );
                },
              ),
              Divider(
                height: 32.0,
                thickness: 2.0,
                indent: 32.0,
                endIndent: 32.0,
              ),
              Text(
                _currentUser.name,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                _currentUser.email,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Score: ${_currentUser.score} points',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 30.0),
              CupertinoButton(
                color: Colors.redAccent,
                pressedOpacity: 0.8,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: Text(
                  Strings.signOut,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  final currentUser = context.read<UserProvider>();
                  currentUser.clearUser();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileImage(){
    return Container(
      child: Center(
        child: Image.asset(
          asset,
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
      final pickedFile = await picker.pickImage(source: source, maxHeight: 512, maxWidth: 512);
      if(pickedFile != null){
        _image = File(pickedFile.path);
        print("IMAGE PATH: " + _image.toString());
        _profileBloc.uploadPicture(_image);
      }else{
        print("NOT IMAGE SELECTED");
      }
    }
  }

  void containerForSheet<T>({required BuildContext context, required Widget child}) {
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
