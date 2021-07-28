import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:do_favors/screens/auth/registration_controller.dart';
import 'package:do_favors/shared/dialogs_mixin.dart';
import 'package:do_favors/shared/loading_indicator_mixin.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';
import 'package:do_favors/widgets/auth_labels.dart';
import 'package:do_favors/widgets/auth_submit_button.dart';

class RegistrationPage extends StatefulWidget {
  final Function toggleView;
  RegistrationPage({required this.toggleView});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with LoadingIndicatorMixin, DialogsMixin {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  late RegistrationController _registrationController;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _listenController(BuildContext context) {
    _registrationController.showLoadingIndicator.listen((showLoadingIndicator) {
      if (showLoadingIndicator) {
        showLoadingSpinner(context: context);
      } else {
        hideLoadingSpinner(context: context);
      }
    });

    _registrationController.displayMessage.listen((message) {
      authExceptionDialog(context, message);
    });
  }

  @override
  void didChangeDependencies() {
    _registrationController = RegistrationController();
    _listenController(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Removes Focus by tap on empty space
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Strings.signUp,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30.0),
                      buildUsernameFormField(),
                      SizedBox(height: 20.0),
                      buildEmailFormField(),
                      SizedBox(height: 20.0),
                      buildPasswordFormField(),
                      SizedBox(height: 20.0),
                      buildConfirmPasswordFormField(),
                      SizedBox(height: 25.0),
                      _submitButton(),
                      SizedBox(height: 16.0),
                      AuthLabels(
                        label: Strings.alreadyHaveAnAccount,
                        labelAction: Strings.signIn,
                        onPressed: () => widget.toggleView(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildUsernameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      onChanged: (value) => _name = value,
      validator: (value) {
        if (value!.isNotEmpty) {
          if (value.length < 5) {
            return Strings.enterLongerName;
          }
        } else {
          return Strings.enterName;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: Strings.name,
        hintText: Strings.enterYourName,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (value) => _email = value,
      validator: (value) {
        if (value!.isNotEmpty) {
          if (!Util.isValidEmail(_email)) {
            return Strings.enterValidEmail;
          }
        } else {
          return Strings.enterAnEmail;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: Strings.email,
        hintText: Strings.enterYourEmail,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      textInputAction: TextInputAction.next,
      onChanged: (value) => _password = value,
      validator: (value) {
        if (value!.isNotEmpty) {
          if (value.length < 6) {
            return Strings.enterLongerPassword;
          }
        } else {
          return Strings.enterPassword;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: Strings.password,
        hintText: Strings.enterYourPassword,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onChanged: (value) => _confirmPassword = value,
      validator: (value) {
        if (value!.isNotEmpty) {
          if (value.length < 6) {
            return Strings.enterLongerPassword;
          }
          if (value != _password) {
            return Strings.passwordsDoNotMatch;
          }
        } else {
          return Strings.repeatPassword2;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: Strings.repeatPassword,
        hintText: Strings.confirmYourPassword,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget _submitButton() {
    return AuthSubmitButton(
      title: Strings.register,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (_password == _confirmPassword) {
            _registrationController.register(
              name: _name,
              email: _email,
              password: _password,
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _registrationController.clear();
    super.dispose();
  }
}
