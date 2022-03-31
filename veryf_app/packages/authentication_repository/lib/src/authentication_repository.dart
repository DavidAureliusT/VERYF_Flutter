import 'dart:async';

import './models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:user_dataprovider/user_dataprovider.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthenticationSession extends Equatable {
  final AuthenticationStatus status;
  final User user;

  const AuthenticationSession({
    required this.status,
    required this.user,
  });

  AuthenticationSession copyWith({
    AuthenticationStatus? status,
    User? user,
  }) {
    return AuthenticationSession(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [status];
}

class AuthenticationRepository {
  final _authStreamController = StreamController<AuthenticationSession>();

  final UserDataProvider _userDataProvider = UserDataProvider();

  Stream<AuthenticationSession> get session async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationSession(
        status: AuthenticationStatus.unauthenticated, user: User.empty);
    yield* _authStreamController.stream;
  }

  Future<User?> getUserDataFromProvider({
    required String email,
    required String password,
  }) async {
    await _userDataProvider.init();
    final driverData = await _userDataProvider.getAllDriver()?.then((drivers) =>
        drivers.where(
            (driver) => driver.email == email && driver.password == password));
    if (driverData != null) {
      // Convert Driver into User
      final driverToUser = User(
        driverData.first.id,
        driverData.first.driverName,
        driverData.first.email,
      );
      return driverToUser;
    }
    return null;
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    final userData =
        await getUserDataFromProvider(email: email, password: password);
    if (userData != null) {
      await Future.delayed(
        const Duration(milliseconds: 300),
        () => _authStreamController.add(AuthenticationSession(
          status: AuthenticationStatus.authenticated,
          user: userData,
        )),
      );
    } else {
      await Future.delayed(
        const Duration(milliseconds: 300),
        () => _authStreamController.add(AuthenticationSession(
            status: AuthenticationStatus.unknown, user: User.empty)),
      );
    }
  }

  void logOut() {
    _authStreamController.add(AuthenticationSession(
        status: AuthenticationStatus.unauthenticated, user: User.empty));
  }

  void dispose() => _authStreamController.close();
}
