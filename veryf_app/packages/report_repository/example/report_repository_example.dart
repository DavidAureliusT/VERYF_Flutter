import 'package:report_repository/report_repository.dart';

Future main() async {
  final ReportRepository reportRepo = ReportRepository();
  await Future.delayed(
      Duration(seconds: 5),
      () => reportRepo
          .getInvoices(driverName: "CELI")
          // .then((reports) => reports?.forEach((report) {
          //       print("CELI -> report");
          //       // print("CELI -> ${report?.nomor_nota} - ${report?.dateTime}");
          //     }
          //     ))
          // .then((reports) => print(reports?.length.toString())));
          .then((invoices) => print(invoices?.length.toString())));
  // await reportRepo
  //     .getInvoices(driverName: "CELI")
  //     .then((invoices) => invoices?.forEach((invoice) {
  //           print(invoice.nomor_nota);
  //           print(invoice.foto);
  //           print(invoice.date);
  //           print(invoice.location);
  //         }));
  reportRepo
      .getReports(driverName: "CELI")
      .then((reports) => reports?.forEach((report) {
            print(report.nomor_nota);
            print(report.amount);
            print(report.creator);
          }));
}
