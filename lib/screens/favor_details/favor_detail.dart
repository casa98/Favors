import 'package:do_favors/model/favor.dart';
import 'package:do_favors/services/database.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:flutter/material.dart';

class FavorDetail extends StatefulWidget {
  final String _title;
  FavorDetail(this._title);

  @override
  _FavorDetailState createState() => _FavorDetailState();
}

class _FavorDetailState extends State<FavorDetail> {
  bool _buttonVisible = true;
  Favor _favor;

  void hideButton() {
    setState(() {
      _buttonVisible = !_buttonVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    Favor _favor = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue[50],
            height: 120.0,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CircleAvatar(
                    maxRadius: 45,
                    backgroundColor: Colors.blue[100],
                    /*
                    backgroundImage: NetworkImage(
                      '',
                    ),
                    */
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(REQUESTED_BY),
                    SizedBox(height: 8.0),
                    Text(
                      _favor.username,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DETAILS_TITLE,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(_favor.favorTitle),
                SizedBox(height: 16.0),
                Text(
                  DETAILS_DESCRIPTION,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(_favor.favorDescription),
                SizedBox(height: 16.0),
                Text(
                  DETAILS_DELIVERY_PLACE,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(_favor.favorLocation),
              ],
            ),
          ),
          if (_buttonVisible)
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () {
                        DatabaseService().markFavorAsAssigned(_favor.key);
                        hideButton();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.thumb_up),
                              SizedBox(width: 20.0),
                              Expanded(
                                child: Text('You\'re now making this favor'),
                              ),
                            ],
                          ),
                          duration: Duration(seconds: 2),
                        ));
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                        child: Text(DO_THIS_FAVOR),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
