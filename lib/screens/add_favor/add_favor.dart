import 'package:do_favors/services/database.dart';
import 'package:do_favors/shared/constants.dart';
import 'package:flutter/material.dart';

class AddFavor extends StatefulWidget {
  @override
  _AddFavorState createState() => _AddFavorState();
}

class _AddFavorState extends State<AddFavor> {
  final _formKey = GlobalKey<FormState>();

  String _title;
  String _description;
  String _location;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 28.0, 0.0, 24.0),
                child: Text(
                  ASK_FOR_A_FAVOR,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              titleFormField(),
              SizedBox(height: 20.0),
              descriptionFormField(),
              SizedBox(height: 20.0),
              deliveryPlaceFormField(),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Theme.of(context).primaryColor;
                    },
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    DatabaseService()
                        .saveFavor(_title, _description, _location);
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                  child: Text(
                      REQUEST_FAVOR,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField titleFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (value) => _title = value,
      validator: (value) {
        return value.isEmpty ? ENTER_TITLE : null;
      },
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        hintText: TITLE_FAVOR,
        helperText: TITLE_LABEL,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLength: 50,
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField descriptionFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (value) => _description = value,
      validator: (value) {
        return value.isEmpty ? ENTER_DESCRIPTION : null;
      },
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        hintText: DESCRIPTION_FAVOR,
        helperText: DESCRIPTION_LABEL,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLength: 300,
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField deliveryPlaceFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (value) => _location = value,
      validator: (value) {
        return value.isEmpty ? ENTER_LOCATION : null;
      },
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        hintText: LOCATION_FAVOR,
        helperText: LOCATION_LABEL,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLength: 50,
    );
  }
}
