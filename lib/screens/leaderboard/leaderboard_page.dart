import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:do_favors/screens/leaderboard/leaderboard_controller.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/model/user_model.dart';
import 'package:do_favors/widgets/loading_indicator.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late final _leaderboardController;

  @override
  void didChangeDependencies() {
    _leaderboardController = LeaderboardController(
      context.read<UserProvider>(),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.leaderboardTitle),
          centerTitle: true,
        ),
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _leaderboardController.getUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return LoadingIndicator();
              default:
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                final users = Util.fromDocumentToUser(snapshot.data!.docs);

                return SafeArea(
                  child: ImplicitlyAnimatedList<UserModel>(
                    insertDuration: Duration(milliseconds: 300),
                    removeDuration: Duration(milliseconds: 300),
                    physics: BouncingScrollPhysics(),
                    items: users,
                    areItemsTheSame: (a, b) => a.id == b.id,
                    itemBuilder: (context, animation, favor, index) {
                      var user = users[index];
                      var score = '${user.score.toString()} points';
                      return SizeFadeTransition(
                        sizeFraction: 0.7,
                        curve: Curves.easeInOut,
                        animation: animation,
                        child: ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: user.photoUrl != ''
                                ? CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: user.photoUrl ?? '',
                                  )
                                : CircleAvatar(
                                    radius: 26,
                                    backgroundColor: Colors.primaries[Random()
                                        .nextInt(Colors.accents.length)],
                                    child: Text(
                                      Util.lettersForHeader(
                                          user.name ?? 'Name'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                          ),
                          title: Text(
                            user.name ?? 'Name',
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(user.email ?? 'Email'),
                          trailing: Text(score),
                        ),
                      );
                    },
                  ),
                );
              //
            }
          },
        ));
  }
}
