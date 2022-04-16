import 'dart:async';

import './models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:driver_dataprovider/driver_dataprovider.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthenticationSession extends Equatable {
  final AuthenticationStatus status;
  final Driver driver;

  const AuthenticationSession({
    required this.status,
    required this.driver,
  });

  AuthenticationSession copyWith({
    AuthenticationStatus? status,
    Driver? driver,
  }) {
    return AuthenticationSession(
      status: status ?? this.status,
      driver: driver ?? this.driver,
    );
  }

  @override
  List<Object> get props => [status, driver];
}

class AuthenticationRepository {
  final _authStreamController = StreamController<AuthenticationSession>();

  final DriverDataProvider _driverDataProvider = DriverDataProvider();

  Stream<AuthenticationSession> get session async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationSession(
        status: AuthenticationStatus.unauthenticated, driver: Driver.empty);
    yield* _authStreamController.stream;
  }

  Future<Driver?> getCurrentDriver({
    required String email,
    required String password,
  }) async {
    final driverData = await _driverDataProvider.getAllDriver()?.then((datas) =>
        datas.map(Driver.fromJson).toList().where(
            (driver) => driver.email == email && driver.password == password));
    if (driverData != null) {
      return driverData.first;
    }
    return null;
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    final driverData = await getCurrentDriver(email: email, password: password);
    if (driverData != null) {
      await Future.delayed(
        const Duration(milliseconds: 300),
        () => _authStreamController.add(AuthenticationSession(
          status: AuthenticationStatus.authenticated,
          driver: driverData,
        )),
      );
    } else {
      await Future.delayed(
        const Duration(milliseconds: 300),
        () => _authStreamController.add(AuthenticationSession(
            status: AuthenticationStatus.unknown, driver: Driver.empty)),
      );
    }
  }

  void logOut() {
    _authStreamController.add(AuthenticationSession(
        status: AuthenticationStatus.unauthenticated, driver: Driver.empty));
  }

  void dispose() => _authStreamController.close();
}
