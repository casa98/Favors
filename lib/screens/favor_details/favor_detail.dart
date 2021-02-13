import 'package:do_favors/model/favor.dart';
import 'package:do_favors/services/database.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:flutter/material.dart';

class FavorDetail extends StatefulWidget {
  final String _title;
  final FavorDetailsObject _favor;
  FavorDetail(this._title, this._favor);

  @override
  _FavorDetailState createState() => _FavorDetailState();
}

class _FavorDetailState extends State<FavorDetail> {
  bool _buttonVisible = true;

  void hideButton() {
    setState(() {
      _buttonVisible = !_buttonVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final FavorDetailsObject args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(REQUESTED_BY),
                SizedBox(height: 8.0),
                Text(
                  widget._favor.username,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Divider(height: 32.0,),
                Text(
                  DETAILS_TITLE,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(widget._favor.favorTitle),
                Divider(height: 32.0,),
                Text(
                  DETAILS_DESCRIPTION,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(widget._favor.favorDescription),
                Divider(height: 32.0,),
                Text(
                  DETAILS_DELIVERY_PLACE,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(widget._favor.favorLocation),
              ],
            ),
          ),
          _buttonVisible ? Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Builder(
                    builder: (context) => ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            return Theme.of(context).primaryColor;
                          },
                        ),
                      ),
                      onPressed: () {
                        DatabaseService()
                            .markFavorAsAssigned(widget._favor.key);
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
                        padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                        child: Text(
                            DO_THIS_FAVOR,
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
        ],
      ),
    );
  }
}
