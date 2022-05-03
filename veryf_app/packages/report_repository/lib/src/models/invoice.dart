import 'package:equatable/equatable.dart';

class Invoice extends Equatable {
  final String nomor_nota;
  final String amount;
  final String nama_driver;
  final String payment_method;
  final String is_data_diterima;

  final String foto;
  final String date;
  final String time;
  final String location;

  const Invoice(
    this.nomor_nota,
    this.amount,
    this.nama_driver,
    this.payment_method,
    this.is_data_diterima,
    this.foto,
    this.date,
    this.time,
    this.location,
  );

  static const empty = Invoice("-", "-", "-", "-", "-", "-", "-", "-", "-");

  static Invoice fromJson(Map<String, dynamic> json) => Invoice(
        json["nomor_nota"],
        json["amount"],
        json["nama_driver"],
        json["payment_method"],
        json["is_dana_diterima"],
        json["foto"],
        json["date_text"],
        json["time_text"],
        json["posisi"],
      );

  @override
  List<Object?> get props => [
        nomor_nota,
        amount,
        nama_driver,
        payment_method,
        is_data_diterima,
        foto,
        date,
        time,
        location,
      ];
}
