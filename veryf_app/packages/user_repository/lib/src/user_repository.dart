import 'dart:async';

import 'package:user_dataprovider/user_dataprovider.dart';
import 'package:uuid/uuid.dart';

import 'models/models.dart';

class UserRepository {
  User? _user;

  UserDataProvider _userDataProvider = UserDataProvider();

  Future<User?> getUser(
      {required String username, required String email}) async {
    if (_user != null) return _user;
    await _userDataProvider.init();
    final driverData = await _userDataProvider.getAllDriver()?.then((drivers) =>
        drivers.where((driver) =>
            driver.email == email && driver.driverName == username));

    return driverData!.isNotEmpty
        ? User(const Uuid().v4(), driverData.first.driverName,
            driverData.first.email)
        : null;
  }
}
