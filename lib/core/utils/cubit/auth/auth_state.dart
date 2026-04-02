import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthShowPasswordUpdatedState extends AuthStates {}

//login
class AuthLoginLoadingState extends AuthStates {}

class AuthLoginSuccessState extends AuthStates {
  final User? user;

  AuthLoginSuccessState(this.user);
}

class AuthLoginErrorState extends AuthStates {
  final String error;

  AuthLoginErrorState(this.error);
}

//register
class AuthProfileImagePickedState extends AuthStates {}

class AuthRegisterLoadingState extends AuthStates {}

class AuthRegisterSuccessState extends AuthStates {
  final User? user;

  AuthRegisterSuccessState(this.user);
}

class AuthRegisterErrorState extends AuthStates {
  final String error;

  AuthRegisterErrorState(this.error);
}
