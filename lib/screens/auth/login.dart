import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:do_favors/widgets/auth_labels.dart';
import 'package:do_favors/widgets/auth_submit_button.dart';
import 'package:do_favors/services/auth.dart';
import 'package:do_favors/shared/loading.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({required this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String _email = "";
  String _password = "";
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
                  Strings.signIn,
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
                          buildEmailFormField(),
                          SizedBox(height: 25.0),
                          buildPasswordFormField(),
                          SizedBox(height: 25.0),
                          _submitButton(),
                          SizedBox(height: 16.0),
                          AuthLabels(
                            label: Strings.doNotHaveAnAccount,
                            labelAction: Strings.signUp,
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

  Widget _submitButton() {
    return AuthSubmitButton(
      title: Strings.logIn,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          log(_email);
          log(_password);
          setState(() => loading = true);
          final result = await _auth.signInWithEmailAndPassword(_email, _password);
          setState(() => loading = false);
          if(result != null){
            log("UID: ${result.uid}");
          }
        }
      },
    );
  }
}
