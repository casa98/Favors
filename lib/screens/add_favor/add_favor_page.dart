import 'package:do_favors/model/favor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/widgets/custom_snackbar.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/widgets/bouncing_button.dart';
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
  late UserProvider _currentUser;

  @override
  void didChangeDependencies() {
    _screenWidth = MediaQuery.of(context).size.width;
    _currentUser = context.read<UserProvider>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                _textField(
                  hintText: Strings.hintTitle,
                  helperText: Strings.labelTitle,
                  labelTextError: Strings.labelTitleError,
                  textController: _titleController,
                ),
                SizedBox(height: 20.0),
                _textField(
                  hintText: Strings.hintDescription,
                  helperText: Strings.labelDescription,
                  labelTextError: Strings.labelDescriptionError,
                  textController: _descriptionController,
                ),
                SizedBox(height: 20.0),
                _textField(
                  hintText: Strings.hintLocation,
                  helperText: Strings.labelLocation,
                  labelTextError: Strings.labelLocationError,
                  textController: _locationController,
                  isLastField: true,
                ),
                SizedBox(height: 20.0),
                BouncingButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Decrease user score in Provider
                      final newScore = _currentUser.score! - 2;
                      _currentUser.updateScore(newScore);

                      Favor newFavor = Favor(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        location: _locationController.text,
                        user: _currentUser.id!,
                        username: _currentUser.name!,
                      );

                      // Save Favor in DB and decrease score there too
                      DatabaseService().saveFavor(
                        favor: newFavor,
                        newScore: newScore,
                      );

                      Navigator.of(context).pop();
                      CustomSnackbar.customScaffoldMessenger(
                        context: context,
                        text: 'Favor successfully requested',
                        iconData: Icons.thumb_up,
                      );
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 64.0, vertical: 14.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Text(
                      Strings.requestFavor,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
  }) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value != null && value.trim().isEmpty) {
          return labelTextError;
        } else {
          return null;
        }
      },
      controller: textController,
      textInputAction:
          isLastField ? TextInputAction.done : TextInputAction.next,
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
