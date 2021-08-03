import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:do_favors/theme/app_state_notifier.dart';
import 'package:do_favors/shared/dialogs_mixin.dart';
import 'package:do_favors/shared/loading_indicator_mixin.dart';
import 'package:do_favors/screens/auth/login_controller.dart';
import 'package:do_favors/widgets/auth_labels.dart';
import 'package:do_favors/widgets/auth_submit_button.dart';
import 'package:do_favors/shared/strings.dart';
import 'package:do_favors/shared/util.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;
  LoginPage({required this.toggleView});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with LoadingIndicatorMixin, DialogsMixin {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  late MediaQueryData _mediaQuery;
  late LoginController _loginController;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _listenController(BuildContext context) {
    _loginController.showLoadingIndicator.listen((showLoadingIndicator) {
      if (showLoadingIndicator) {
        showLoadingSpinner(context: context);
      } else {
        hideLoadingSpinner(context: context);
      }
    });

    _loginController.displayMessage.listen((message) {
      authExceptionDialog(context, message);
    });
  }

  @override
  void didChangeDependencies() {
    _mediaQuery = MediaQuery.of(context);
    _loginController = LoginController();
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
            Strings.signIn,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          brightness: context.read<AppThemeNotifier>().isDarkMode
              ? Brightness.dark
              : Brightness.light,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _mediaQuery.orientation.index == 0
                      ? MediaQuery.of(context).size.width * 0.05
                      : MediaQuery.of(context).size.width * 0.2,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30.0),
                      buildEmailFormField(),
                      SizedBox(height: 25.0),
                      buildPasswordFormField(),
                      SizedBox(height: 25.0),
                      _submitButton(),
                      SizedBox(height: 18.0),
                      AuthLabels(
                        label: '',
                        labelAction: Strings.forgotYourPassword,
                        onPressed: () {},
                      ),
                      AuthLabels(
                        label: Strings.doNotHaveAnAccount,
                        labelAction: Strings.signUp,
                        onPressed: () => widget.toggleView(),
                      ),
                      SizedBox(height: 16.0),
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

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
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
      autocorrect: false,
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
          _loginController.login(email: _email, password: _password);
        }
      },
    );
  }

  @override
  void dispose() {
    _loginController.clear();
    super.dispose();
  }
}
