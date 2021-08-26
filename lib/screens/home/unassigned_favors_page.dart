import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

import 'package:do_favors/theme/app_state_notifier.dart';
import 'package:do_favors/screens/home/unassigned_favors_controller.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/widgets/no_items.dart';
import 'package:do_favors/model/favor.dart';
import 'package:do_favors/widgets/loading_indicator.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';

class UnassignedFavors extends StatefulWidget {
  @override
  _UnassignedFavorsState createState() => _UnassignedFavorsState();
}

class _UnassignedFavorsState extends State<UnassignedFavors> {
  late final UnassignedFavorsController _unassignedFavorsController;
  late final UserProvider _userProvider;
  late final AppThemeNotifier _apptheme;

  @override
  void didChangeDependencies() {
    _userProvider = context.read<UserProvider>();
    _unassignedFavorsController = UnassignedFavorsController(_userProvider);
    _apptheme = context.read<AppThemeNotifier>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _unassignedFavorsController.fetchUnassignedFavors(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingIndicator();
            default:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));

              List<Favor> favors =
                  Util.fromDocumentToFavor(snapshot.data!.docs);
              // Remove favors requested by currentUser
              favors.removeWhere((element) => element.user == _userProvider.id);

              if (favors.isEmpty) return NoItems(text: 'No favors to do, yet');

              return SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  unconfirmedFavors(),
                  Expanded(
                    child: ImplicitlyAnimatedList<Favor>(
                      insertDuration: Duration(milliseconds: 300),
                      removeDuration: Duration(milliseconds: 300),
                      physics: BouncingScrollPhysics(),
                      items: favors,
                      areItemsTheSame: (a, b) => a.key == b.key,
                      itemBuilder: (context, animation, favor, index) {
                        return SizeFadeTransition(
                          sizeFraction: 0.7,
                          curve: Curves.easeInOut,
                          animation: animation,
                          child: ListTile(
                            title: Text(
                              favor.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              favor.description,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              Util.readFavorTimestamp(favor.timestamp!),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Strings.favorDetailsRoute,
                                arguments: favor,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ));
          }
        });
  }

  // Unconfirmed favors are Favors completed but completion still not confirmed by favor requester
  Widget unconfirmedFavors() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _unassignedFavorsController.fetchUnconfirmedFavors(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SizedBox();
          default:
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));

            List<Favor> favors = Util.fromDocumentToFavor(snapshot.data!.docs);
            // Keep Unconfirmed favors only (the ones whose score is 0)
            favors.removeWhere((element) => element.status != "2");

            if (favors.isEmpty) return SizedBox();
            return Column(
              children: [
                ListTile(
                  tileColor: Brightness.dark == Theme.of(context).brightness
                      ? Theme.of(context).backgroundColor
                      : Colors.grey[200],
                  title: Text(
                      '${favors.length} of your favors ${favors.length == 1 ? 'was' : 'were'} completed.'),
                  subtitle: Text('Please tap to confirm these actions.'),
                  onTap: () =>
                      Navigator.pushNamed(context, Strings.myFavorsRoute),
                ),
                if (Theme.of(context).brightness == Brightness.light)
                  Divider(
                    thickness: 1.0,
                    height: 0.0,
                  ),
              ],
            );
        }
      },
    );
  }
}
