import 'package:equatable/equatable.dart';
import 'package:latlng/latlng.dart';

class Report extends Equatable {
  final String nomor_nota;
  final String amount;
  final String payment_method;
  final String photo;
  final DateTime dateTime;
  final LatLng location;
  final String creator;

  Report(this.photo, this.dateTime, this.location, this.creator,
      this.nomor_nota, this.amount, this.payment_method);

  // static Report fromJson(Map<String, dynamic> json) {
  //   String _formatedDateString =
  //       "${json["date_text"].toString().replaceAll(r'-', "")} ${json["time_text"]}";
  //   final DateTime _date_time_report = DateTime.parse(_formatedDateString);

  //   String raw_location = json["posisi"];
  //   double lat = double.parse(raw_location.split(",")[0]);
  //   double lng = double.parse(raw_location.split(",")[1]);
  //   final LatLng _updated_location = LatLng(lat, lng);

  //   final report_invoice = Invoice(
  //     json["nomor_nota"],
  //     json["amount"],
  //     json["nama_driver"],
  //     json["payment_method"],
  //     json["is_data_diterima"] == "TRUE",
  //     json["foto"] != null,
  //   );

  //   return Report(
  //     report_invoice,
  //     json["photo"],
  //     _date_time_report,
  //     _updated_location,
  //     json["nama_driver"],
  //   );
  // }

  @override
  List<Object?> get props => [photo, dateTime, location, creator];
}

// class Report extends Equatable {
//   final String nomor_nota;
//   final String tipe_nota;
//   final String amount;
//   final String nama_driver;
//   final String? nama_helper;
//   final String nama_baca;
//   final String payment_method;
//   final bool is_dana_diterima;
//   final String? foto;
//   final DateTime? date_time_checked;
//   final DateTime? date_time_report;
//   final LatLng? updated_location;

//   const Report({
//     required this.nomor_nota,
//     required this.tipe_nota,
//     required this.amount,
//     required this.nama_driver,
//     this.nama_helper,
//     required this.nama_baca,
//     required this.payment_method,
//     required this.is_dana_diterima,
//     this.foto,
//     this.date_time_checked,
//     this.date_time_report,
//     this.updated_location,
//   });

//   static Report fromJson(Map<String, dynamic> json) {
//     String _formatedDateString =
//         "${json["date_text"].toString().replaceAll(r'-', "")} ${json["time_text"]}";
//     final DateTime _date_time_report = DateTime.parse(_formatedDateString);

//     _formatedDateString =
//         json["date_time_checked_text"].toString().replaceAll(r'-', "");
//     final DateTime _date_time_checked = DateTime.now();

//     String raw_location = json["posisi"];
//     double lat = double.parse(raw_location.split(",")[0]);
//     double lng = double.parse(raw_location.split(",")[1]);
//     final LatLng _updated_location = LatLng(lat, lng);

//     return Report(
//       nomor_nota: json["nomor_nota"],
//       tipe_nota: json["tipe_nota"],
//       amount: json["amount"],
//       nama_driver: json["nama_driver"],
//       nama_helper: json["nama_helper"],
//       nama_baca: json["nama_baca"],
//       payment_method: json["payment_method"],
//       is_dana_diterima: json["is_dana_diterima"] == "TRUE",
//       foto: json["foto"],
//       date_time_checked: _date_time_checked,
//       date_time_report: _date_time_report,
//       updated_location: _updated_location,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         nomor_nota,
//         tipe_nota,
//         amount,
//         nama_driver,
//         nama_helper,
//         nama_baca,
//         payment_method,
//         is_dana_diterima,
//         foto,
//         date_time_checked,
//         date_time_report,
//         updated_location,
//       ];
// }
