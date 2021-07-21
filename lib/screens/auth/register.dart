import 'dart:developer';

import 'package:do_favors/widgets/auth_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:do_favors/services/auth.dart';
import 'package:do_favors/shared/loading.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';
import 'package:do_favors/widgets/auth_labels.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String _name = "";
  String _email ="";
  String _password = "";
  String _confirmPassword ="";
  String _error = "";
  AuthService _auth = AuthService();

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : GestureDetector(
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
                          Text(
                            _error,
                            style: TextStyle(
                              color: Colors.red[600],
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 16.0),
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
        );
  }

  TextFormField buildUsernameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
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
          if(value != _password){
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
            log(_email);
            log(_password);
            setState(() => loading = true);
            final result = await _auth
                .createUserWithEmailAndPassword(_name, _email, _password);
            setState(() => loading = false);
            if(result != null){
              log("UID: ${result.uid}");
            }
          }
        }
      },
    );
  }
}
