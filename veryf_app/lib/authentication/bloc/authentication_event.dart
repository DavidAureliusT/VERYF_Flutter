part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.status, this.driver);

  final AuthenticationStatus status;
  final Driver driver;

  @override
  List<Object> get props => [status, driver];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
