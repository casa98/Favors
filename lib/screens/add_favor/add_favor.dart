import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/widgets/custom_scaffold.dart';
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
  late UserProvider _userProvider;

  @override
  void didChangeDependencies() {
    _screenWidth = MediaQuery.of(context).size.width;
    _userProvider = context.watch<UserProvider>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
                  labelTextError: Strings.labelTitleError,
                  textController: _titleController,
                ),
                SizedBox(height: 20.0),
                //descriptionFormField(),
                _textField(
                  hintText: Strings.hintDescription,
                  helperText: Strings.labelDescription,
                  labelTextError: Strings.labelDescriptionError,
                  textController: _descriptionController,
                ),
                SizedBox(height: 20.0),
                //deliveryPlaceFormField(),
                _textField(
                  hintText: Strings.hintLocation,
                  helperText: Strings.labelLocation,
                  labelTextError: Strings.labelLocationError,
                  textController: _locationController,
                  isLastField: true,
                ),
                SizedBox(height: 20.0),
                ActionButton(
                  title: Strings.requestFavor,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Decrease user score
                      _userProvider
                          .updateUserScore(_userProvider.currentUser.score-2);
                      // Save Favor in DB
                      DatabaseService().saveFavor(
                        _titleController.text,
                        _descriptionController.text,
                        _locationController.text,
                      );
                      //TODO: Decrease score in DB
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
      ),
    );
  }

  TextFormField _textField({
    required String hintText,
    required String helperText,
    required String labelTextError,
    required TextEditingController textController,
    bool isLastField = false,
  }){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      validator: (value){
        if(value != null && value.trim().isEmpty){
          return labelTextError;
        }else{
          return null;
        }
      },
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
        fillColor: Theme.of(context).dialogBackgroundColor,
        hintText: hintText,
        helperText: helperText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
