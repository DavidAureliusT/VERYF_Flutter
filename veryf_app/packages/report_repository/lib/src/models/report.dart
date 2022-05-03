import 'package:equatable/equatable.dart';
import 'package:latlng/latlng.dart';

class Report extends Equatable {
  final String nomor_nota;
  final String amount;
  final String payment_method;
  final String photo;
  final DateTime? dateTime;
  final LatLng? location;
  final String? creator;

  const Report(this.photo, this.dateTime, this.location, this.creator,
      this.nomor_nota, this.amount, this.payment_method);

  static const empty = Report("-", null, null, "-", "-", "-", "-");

  @override
  List<Object?> get props => [photo, dateTime, location, creator];
}
