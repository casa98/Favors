import 'package:do_favors/model/favor.dart';
import 'package:do_favors/screens/incomplete_favors/incomplete_favors_bloc.dart';
import 'package:do_favors/shared/util.dart';
import 'package:flutter/material.dart';

class IncompleteFavors extends StatefulWidget {
  final String _title;
  IncompleteFavors(this._title);

  @override
  _IncompleteFavorsState createState() => _IncompleteFavorsState();
}

class _IncompleteFavorsState extends State<IncompleteFavors> {
  IncompleteFavorsBloc _incompleteFavorsBloc;

  @override
  void initState() {
    _incompleteFavorsBloc = IncompleteFavorsBloc();
    _incompleteFavorsBloc.loadIncompleteFavors();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Center(
          child: StreamBuilder<List<Favor>>(
        stream: _incompleteFavorsBloc.incompleteFavors,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              List<Favor> item = snapshot.data;
              if (item.length == 0)
                return Text('You don\'t have pending favors to complete');
              return ListView.separated(
                itemCount: item.length,
                separatorBuilder: (context, index) => Divider(height: 0.0),
                itemBuilder: (context, index) {
                  var currentFavor = item[index];
                  return ListTile(
                    title: Text(
                      currentFavor.favorTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(currentFavor.favorDescription,
                        overflow: TextOverflow.ellipsis),
                    trailing: Text(
                      Util().readFavorTimestamp(currentFavor.timestamp),
                    ),
                    onTap: () {},
                  );
                },
              );
            //
          }
        },
      )),
    );
  }
}
