import 'package:do_favors/services/auth.dart';
import 'package:do_favors/shared/loading.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String _email;
  String _password;
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
        : Scaffold(
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 30.0),
                        Text(
                          Strings.signIn,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16.0),
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
                        SizedBox(height: 20.0),
                        submitButton(),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(Strings.doNotHaveAnAccount),
                            GestureDetector(
                              onTap: () => widget.toggleView(),
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  Strings.signUp,
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
        if (value.isNotEmpty) {
          if (!EmailValidator.validate(value)) {
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
        if (value.isNotEmpty) {
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

  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          setState(() => loading = true);
          dynamic result = await _auth.signInWithEmailAndPassword(_email, _password);
          setState(() => loading = false);
          _error = result.toString();
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
        child: Text(
          Strings.login,
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
    );
  }
}
