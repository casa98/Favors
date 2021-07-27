import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:do_favors/screens/home/unassigned_favors_controller.dart';
import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/widgets/no_items.dart';
import 'package:do_favors/model/favor.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';

class UnassignedFavors extends StatefulWidget {
  @override
  _UnassignedFavorsState createState() => _UnassignedFavorsState();
}

class _UnassignedFavorsState extends State<UnassignedFavors> {

  late final UnassignedFavorsController _unassignedFavorsController;

  @override
  void didChangeDependencies() {
    _unassignedFavorsController = UnassignedFavorsController(
      context.read<UserProvider>(),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _unassignedFavorsController.fetchUnassignedFavors(),
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));

            List<Favor> favors = Util.fromDocumentToFavor(snapshot.data!.docs);
            if(favors.isEmpty)
              return NoItems(text: 'No Favors to do, yet');

            // Remove favors requested by currentUser
            favors.removeWhere((element)
                => element.user == _unassignedFavorsController.userprovider.currentUser.id);
            return SafeArea(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: favors.length,
                separatorBuilder: (context, index)
                    => Divider(height: 0.0, thickness: 0.4),
                itemBuilder: (context, index) {
                  final favor = favors[index];
                  return ListTile(
                    title: Text(
                      favor.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(favor.description,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      Util.readFavorTimestamp(favor.timestamp),
                    ),
                    onTap: (){
                      Navigator.pushNamed(
                        context,
                        Strings.favorDetailsRoute,
                        arguments: favor,
                      );
                    },
                  );
                }
              ),
            );
        }
      }
    );
  }
}
