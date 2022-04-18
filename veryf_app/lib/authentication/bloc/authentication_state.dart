part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.driver = Driver.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(Driver driver)
      : this._(status: AuthenticationStatus.authenticated, driver: driver);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final Driver driver;

  @override
  List<Object> get props => [status, driver];
}
