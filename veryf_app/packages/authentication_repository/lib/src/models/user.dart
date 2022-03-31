import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;

  const User(
    this.id,
    this.username,
    this.email,
  );

  @override
  List<Object> get props => [id, username, email];

  static const empty = User('-', '-', '-');
}
