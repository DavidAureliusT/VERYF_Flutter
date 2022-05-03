import 'dart:async';
import 'dart:io';

// import 'package:gdrive_service/gdrive_service.dart';
import 'package:invoice_dataprovider/invoice_dataprovider.dart';
import 'package:latlng/latlng.dart';
import 'package:report_repository/src/models/model.dart';
import 'package:veryf_storage/veryf_storage.dart';

enum SendReportStatus {
  standby,
  inProgress,
  failed,
  success,
}

class ReportRepository {
  List<Invoice> _invoices = [];
  List<Report> _reports = [];

  final InvoiceDataProvider _invoiceDataProvider = InvoiceDataProvider();
  final VeryfStorage _veryfStorage = VeryfStorage();

  static const getInvoiceImageBaseUrl =
      "https://pbrbali.com/veryf-det/get-invoice-image/";

  final _invoicesStreamController = StreamController<List<Invoice>>();
  final _reportsStreamController = StreamController<List<Report>>();
  final _sendReportStatusStreamController =
      StreamController<SendReportStatus>();

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

  Stream<SendReportStatus> get status async* {
    await Future.delayed(const Duration(seconds: 1));
    yield SendReportStatus.standby;
    yield* _sendReportStatusStreamController.stream;
  }

  Future<void> sendReport({required Report report}) async {
    _sendReportStatusStreamController.add(SendReportStatus.inProgress);
    final File reportPhoto = File(report.photo);
    // final imageDrive = await GDriveService().upload(reportPhoto);
    final storeImageRes = await _veryfStorage.uploadInvoiceImage(reportPhoto);
    bool isSuccess = false;
    if (storeImageRes.isNotEmpty) {
      final _dateText =
          "${report.dateTime!.year}-${report.dateTime!.month}-${report.dateTime!.day}";
      final _timeText =
          "${report.dateTime!.hour}:${report.dateTime!.minute}:${report.dateTime!.second}";
      final _locationText =
          "${report.location!.latitude},${report.location!.longitude}";
      isSuccess = await _invoiceDataProvider.storeNewReport(
        nomor_nota: report.nomor_nota,
        photo: getInvoiceImageBaseUrl + storeImageRes["filename"],
        date: _dateText,
        time: _timeText,
        location: _locationText,
        creator: report.creator,
      );
    }
    if (isSuccess) {
      _sendReportStatusStreamController.add(SendReportStatus.success);
    } else {
      _sendReportStatusStreamController.add(SendReportStatus.failed);
    }
  }

  Future<void> getInvoices({required String driverName}) async {
    if (_invoices.length == 0) {
      final invoices = await _invoiceDataProvider.getAllInvoice()?.then(
          (invoices) => invoices
              .map(Invoice.fromJson)
              .where((invoice) => invoice.nama_driver == driverName)
              .toList());
      _invoices = invoices!;
      _invoicesStreamController.add(_invoices);
    }
  }

  Future<void> getReports({required String driverName}) async {
    if (_reports.length == 0) {
      if (_invoices.length == 0) {
        await getInvoices(driverName: driverName);
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
            // print("${report.nomor_nota} - ${report.creator} is added");
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
