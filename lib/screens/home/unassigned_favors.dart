import 'package:flutter/material.dart';

import 'package:do_favors/screens/home/unassigned_favors_controller.dart';
import 'package:do_favors/model/favor.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';

class UnassignedFavors extends StatefulWidget {
  @override
  _UnassignedFavorsState createState() => _UnassignedFavorsState();
}

class _UnassignedFavorsState extends State<UnassignedFavors> {

  final _unassignedFavors = UnassignedFavorsController();

  @override
  void initState() {
    _unassignedFavors.fetchUnassignedFavors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UnassignedFavorsController().fetchUnassignedFavors();
    return StreamBuilder<List<Favor>>(
      stream: _unassignedFavors.unassignedFavorsList,
      builder: (context, snapshot){
        if(snapshot.hasError) throw('Snapshot Error: ${snapshot.error}');
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            final favors = snapshot.data ?? [];
            if(favors.isEmpty){
              return Center(
                child: Text(
                  'No Favors to do, yet!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              );
            }

            return ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: favors.length,
              separatorBuilder: (context, index) => Divider(height: 0.0, thickness: 0.4),
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
            );
        }
      }
    );
  }
}
