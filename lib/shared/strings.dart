import 'package:cloud_firestore/cloud_firestore.dart';

class Strings {

  // Authentication
  static const userNotFound         = "No user registered with this email";
  static const wrongPassword        = "Incorrect password";
  static const emailAlreadyInUse    = "Email address already in use";
  static const unknownError         ="Unable to reach the server. Are you connected to internet?";
  static const operationNotAllowed  ="Server error, please try again later";
  static const anotherError         ="Something went wrong, please try again later";

  static const alreadyHaveAnAccount ="Already have an account?";
  static const doNotHaveAnAccount   ="Don’t have an account?";
  static const signIn               ="Sign In";
  static const signUp               ="Sign Up";
  static const login                ="LOGIN";
  static const register             ="REGISTER";
  static const enterLongerName      ="Please enter at least 5 characters";
  static const enterName            ="Please enter a name";
  static const enterYourName        ="Enter your name";
  static const name                 ="Name";
  static const enterValidEmail      ="Please enter a valid email";
  static const enterAnEmail         ="Please enter an email";
  static const email                ="Email";
  static const enterYourEmail       ="Enter your email";
  static const enterLongerPassword  ="Please enter at least 6 characters";
  static const enterPassword        ="Please enter a password";
  static const password             ="Password";
  static const enterYourPassword    ="Enter your password";
  static const repeatPassword       ="Repeat password";
  static const repeatPassword2      ="Please repeat your password";
  static const passwordsDoNotMatch  ="Passwords don\'t match";
  static const confirmYourPassword  ="Confirm your password";
}