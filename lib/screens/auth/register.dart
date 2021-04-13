import 'package:do_favors/services/auth.dart';
import 'package:do_favors/shared/loading.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String _name;
  String _email;
  String _password;
  String _confirmPassword;
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
                color: Theme.of(context).backgroundColor,
                padding: EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 30.0),
                        Text(
                          'Sign Up',
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
                        buildUsernameFormField(),
                        SizedBox(height: 20.0),
                        buildEmailFormField(),
                        SizedBox(height: 20.0),
                        buildPasswordFormField(),
                        SizedBox(height: 20.0),
                        buildConfirmPasswordFormField(),
                        SizedBox(height: 20.0),
                        submitButton(),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(Strings.alreadyHaveAnAccount),
                            GestureDetector(
                              onTap: () => widget.toggleView(),
                              child: Container(
                                color: Theme.of(context).backgroundColor,
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  Strings.signIn,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
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

  TextFormField buildUsernameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onChanged: (value) => _name = value,
      validator: (value) {
        if (value.isNotEmpty) {
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
        if (value.isNotEmpty) {
          // TODO Validate email
          if (false) {
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

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onChanged: (value) => _confirmPassword = value,
      validator: (value) {
        if (value.isNotEmpty) {
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

  ElevatedButton submitButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Theme.of(context).primaryColor;
          },
        ),
      ),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          if (_password == _confirmPassword) {
            setState(() => loading = true);
            dynamic result = await _auth.createUserWithEmailAndPassword(
                _name, _email, _password);
            setState(() => loading = false);
            _error = result.toString();
          }
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
        child: Text(
          Strings.register,
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
    );
  }
}
