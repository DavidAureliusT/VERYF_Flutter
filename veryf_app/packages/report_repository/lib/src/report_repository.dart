import 'dart:async';

import 'package:invoice_dataprovider/invoice_dataprovider.dart';
import 'package:latlng/latlng.dart';
import 'package:report_repository/src/models/invoice.dart';
import 'package:report_repository/src/models/model.dart';

class ReportRepository {
  List<Invoice> _invoices = [];
  List<Report> _reports = [];

  final InvoiceDataProvider _invoiceDataProvider = InvoiceDataProvider();

  final _invoicesStreamController = StreamController<List<Invoice>>();
  final _reportsStreamController = StreamController<List<Report>>();

  Stream<List<Invoice>> get invoices async* {
    await Future.delayed(const Duration(seconds: 1));
    yield _invoices;
    yield* _invoicesStreamController.stream;
  }

  Stream<List<Report>> get reports async* {
    await Future.delayed(const Duration(seconds: 1));
    yield _reports;
    yield* _reportsStreamController.stream;
  }

  Future<void> getInvoices({required String driverName}) async {
    if (_invoices.length == 0) {
      final invoices = await _invoiceDataProvider.getAllInvoice()?.then(
          (invoices) => invoices
              .map(Invoice.fromJson)
              .where((invoice) => invoice.nama_driver == driverName)
              .toList());
      _invoices = invoices!;
    }
    _invoicesStreamController.add(_invoices);
  }

  Future<void> getReports({required String driverName}) async {
    if (_reports.length == 0) {
      if (_invoices.length == 0) {
        getInvoices(driverName: driverName);
      }
      _invoices.forEach((invoice) {
        if (invoice.nama_driver == driverName) {
          if (invoice.foto != "") {
            String _formatedDateString =
                "${invoice.date.replaceAll(r'-', "")} ${invoice.time}";
            final DateTime _date_time_report =
                DateTime.parse(_formatedDateString);

            String raw_location = invoice.location;
            double lat = double.parse(raw_location.split(",")[0]);
            double lng = double.parse(raw_location.split(",")[1]);
            final LatLng _updated_location = LatLng(lat, lng);

            var report = Report(
                invoice.foto,
                _date_time_report,
                _updated_location,
                invoice.nama_driver,
                invoice.nomor_nota,
                invoice.amount,
                invoice.payment_method);
            _reports.add(report);
            print("${report.nomor_nota} - ${report.creator} is added");
          }
        }
      });
    }
    _reportsStreamController.add(_reports);
  }

  void dispose() {
    _reportsStreamController.close();
    _invoicesStreamController.close();
  }
}
