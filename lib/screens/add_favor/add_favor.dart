import 'package:do_favors/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/widgets/action_button.dart';
import 'package:do_favors/services/database.dart';

class AddFavor extends StatefulWidget {
  @override
  _AddFavorState createState() => _AddFavorState();
}

class _AddFavorState extends State<AddFavor> {
  final _formKey = GlobalKey<FormState>();

  late double _screenWidth;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void didChangeDependencies() {
    _screenWidth = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: _screenWidth * 0.05,
          vertical: 0.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 24.0,
                  bottom: 24.0,
                ),
                child: Text(
                  Strings.askForFavor,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              //titleFormField(),
              _textField(
                hintText: Strings.hintTitle,
                helperText: Strings.labelTitle,
                textController: _titleController,
              ),
              SizedBox(height: 20.0),
              //descriptionFormField(),
              _textField(
                hintText: Strings.hintDescription,
                helperText: Strings.labelDescription,
                textController: _descriptionController,
              ),
              SizedBox(height: 20.0),
              //deliveryPlaceFormField(),
              _textField(
                hintText: Strings.hintLocation,
                helperText: Strings.labelLocation,
                textController: _locationController,
                isLastField: true,
              ),
              SizedBox(height: 20.0),
              ActionButton(
                title: Strings.requestFavor,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //TODO: Add validators to fields before submitting
                    print("Fields' values:");
                    print(_titleController.text);
                    print(_descriptionController.text);
                    print(_locationController.text);
                    DatabaseService().saveFavor(
                      _titleController.text,
                      _descriptionController.text,
                      _locationController.text,
                    );
                    Navigator.of(context).pop();
                    CustomScaffold.customScaffoldMessenger(
                      context: context,
                      text: 'Favor successfully requested',
                    );
                  }
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _textField({
    required String hintText,
    required String helperText,
    required TextEditingController textController,
    bool isLastField = false,
  }){
    return TextFormField(
      keyboardType: TextInputType.text,
      validator: (value){},
      controller: textController,
      textInputAction: isLastField
        ? TextInputAction.done
        : TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        fillColor: Theme.of(context).backgroundColor,
        hintText: hintText,
        helperText: helperText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  /*
  TextFormField titleFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (value) => _title = value,
      validator: (value) {
        return value!.isEmpty ? ENTER_TITLE : null;
      },
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        fillColor: Theme.of(context).backgroundColor,
        hintText: TITLE_FAVOR,
        helperText: TITLE_LABEL,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField descriptionFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (value) => _description = value,
      validator: (value) {
        return value!.isEmpty ? ENTER_DESCRIPTION : null;
      },
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        fillColor: Theme.of(context).backgroundColor,
        hintText: DESCRIPTION_FAVOR,
        helperText: DESCRIPTION_LABEL,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      textInputAction: TextInputAction.next,
    );
  }

  TextFormField deliveryPlaceFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (value) => _location = value,
      validator: (value) {
        return value!.isEmpty ? ENTER_LOCATION : null;
      },
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        fillColor: Theme.of(context).backgroundColor,
        hintText: LOCATION_FAVOR,
        helperText: LOCATION_LABEL,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
  */
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
