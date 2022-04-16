import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  final String id;
  final String driverName;
  final String email;
  final String password;

  const Driver(
      {required this.id,
      required this.driverName,
      required this.email,
      required this.password});

  static Driver fromJson(Map<String, dynamic> json) => Driver(
        id: json['ID'],
        driverName: json['DRIVERNAME'],
        email: json['EMAIL'],
        password: json['PASSWORD'],
      );

  static const empty =
      Driver(id: "-", driverName: "-", email: "-", password: "-");

  @override
  List<Object?> get props => [id, driverName, email, password];
}
