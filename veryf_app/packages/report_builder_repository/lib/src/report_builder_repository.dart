import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:invoice_dataprovider/invoice_dataprovider.dart';
import 'package:veryf_detection_api/veryf_detection_api.dart';

enum ReportBuilderRepositoryStatus {
  standby,
  scanningInvoiceNumberBox,
  invoiceNumberBoxCropped,
  invoiceNumberBoxUndetected,
  downloadCroppedImage,
  imagePathUpdated,
  downloadCroppedImageFailed,
  scanningInvoiceNumber,
  invoiceNumberDetected,
  invoiceNumberUndetected,
  extractingInvoiceNumber,
  extractionSuccess,
  extractionFailed,
  submitReport,
  submitReportSuccess,
  submitReportFailed,
}

class ReportBuilderSession extends Equatable {
  final ReportBuilderRepositoryStatus repoStatus;
  final String image_path;
  final String message;
  final List<dynamic> invoice_numbers;

  const ReportBuilderSession({
    required this.repoStatus,
    required this.image_path,
    required this.message,
    required this.invoice_numbers,
  });

  @override
  List<Object> get props => [
        repoStatus,
        image_path,
        message,
        invoice_numbers,
      ];
}

class ReportBuilderRepository {
  final _veryfDetectionApi = VeryfDetectionApi();
  final _invoiceDataProvider = InvoiceDataProvider();
  final _reportBuilderStreamController =
      StreamController<ReportBuilderSession>();

  Stream<ReportBuilderSession> get session async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield ReportBuilderSession(
      repoStatus: ReportBuilderRepositoryStatus.standby,
      image_path: "",
      message: "",
      invoice_numbers: [],
    );
    yield* _reportBuilderStreamController.stream;
  }

  Future<void> getCroppedImage({
    required String currentImagePath,
    required String temporaryDirectory,
    required String filename,
  }) async {
    String message = "";
    ReportBuilderRepositoryStatus repoStatus =
        ReportBuilderRepositoryStatus.downloadCroppedImage;

    _reportBuilderStreamController.add(ReportBuilderSession(
      repoStatus: repoStatus,
      image_path: currentImagePath,
      message: "",
      invoice_numbers: [],
    ));

    // get new path
    final updatedImagePath = await _veryfDetectionApi.downloadCroppedImage(
      currentImagePath,
      temporaryDirectory,
      filename,
    );

    if (updatedImagePath == currentImagePath) {
      message = "Download image failed";
      repoStatus = ReportBuilderRepositoryStatus.downloadCroppedImageFailed;
    } else {
      message = "Image Updated!";
      repoStatus = ReportBuilderRepositoryStatus.downloadCroppedImage;
    }
    _reportBuilderStreamController.add(ReportBuilderSession(
      repoStatus: repoStatus,
      image_path: updatedImagePath,
      message: message,
      invoice_numbers: [],
    ));
  }

  Future<bool> submitReport({
    required String nomor_nota,
    required String photo,
    required String? date,
    required String? time,
    required String? location,
    required String? creator,
  }) async {
    return _invoiceDataProvider.storeNewReport(
      nomor_nota: nomor_nota,
      photo: photo,
      date: date,
      time: time,
      location: location,
      creator: creator,
    );
  }

  Future<void> getInvoiceNumbers({
    // required bool testing,
    required String image_path,
  }) async {
    _reportBuilderStreamController.add(
      ReportBuilderSession(
        repoStatus: ReportBuilderRepositoryStatus.extractingInvoiceNumber,
        image_path: image_path,
        message: "",
        invoice_numbers: [],
      ),
    );
    final imageFile = File(image_path);
    await _veryfDetectionApi.extractInvoiceNumber(imageFile).then((response) {
      final message = response["data"]["message"];
      if (message == "failed") {
        _reportBuilderStreamController.add(
          ReportBuilderSession(
            repoStatus: ReportBuilderRepositoryStatus.extractionFailed,
            image_path: imageFile.path,
            message:
                "Kotak nomor nota tidak terdeteksi. Pastikan kembali posisi nota difoto sesuai dengan garis bantu yang tersedia",
            invoice_numbers: [],
          ),
        );
      } else if (message == "inaccuracy") {
        _reportBuilderStreamController.add(
          ReportBuilderSession(
            repoStatus: ReportBuilderRepositoryStatus.extractionFailed,
            image_path: imageFile.path,
            message:
                "Skor akurasi foto nota ${response["data"]["score"]}. Pastikan kembali foto diambil pada kondisi pencahayaan yang cukup dan hindari goncangan saat menambil foto (${response["data"]["runtime"]} seconds)",
            invoice_numbers: [],
          ),
        );
      } else if (message == "success") {
        final invoice_numbers = response["data"]["invoice_numbers"];
        _reportBuilderStreamController.add(
          ReportBuilderSession(
            repoStatus: ReportBuilderRepositoryStatus.extractionSuccess,
            image_path: imageFile.path,
            message:
                "Success. Detected string: ${invoice_numbers.toString()} (${response["data"]["runtime"]} seconds)",
            invoice_numbers: invoice_numbers,
          ),
        );
      }
    });
  }

  Future<void> getInvoiceNumberBox(
      {required bool testing, required String image_path}) async {
    String _image_path = "";
    if (testing) {
      _image_path = "assets/images/sample.jpg";
    } else {
      _image_path = image_path;
    }
    _reportBuilderStreamController.add(
      ReportBuilderSession(
        repoStatus: ReportBuilderRepositoryStatus.scanningInvoiceNumberBox,
        image_path: _image_path,
        message: "",
        invoice_numbers: [],
      ),
    );
    final imageFile = File(_image_path);
    await _veryfDetectionApi.detectInvoiceNumberBox(imageFile).then((response) {
      final message = response["data"]["message"];
      if (message == "failed") {
        _reportBuilderStreamController.add(
          ReportBuilderSession(
            repoStatus:
                ReportBuilderRepositoryStatus.invoiceNumberBoxUndetected,
            image_path: _image_path,
            message:
                "Kotak nomor nota tidak terdeteksi. Pastikan kembali posisi nota difoto sesuai dengan garis bantu yang tersedia",
            invoice_numbers: [],
          ),
        );
      } else if (message == "inaccuracy") {
        _reportBuilderStreamController.add(
          ReportBuilderSession(
            repoStatus:
                ReportBuilderRepositoryStatus.invoiceNumberBoxUndetected,
            image_path: _image_path,
            message:
                "Skor akurasi foto nota ${response["data"]["score"]}. Pastikan kembali foto diambil pada kondisi pencahayaan yang cukup dan hindari goncangan saat menambil foto (${response["data"]["runtime"]} seconds)",
            invoice_numbers: [],
          ),
        );
      } else if (message == "success") {
        _reportBuilderStreamController.add(
          ReportBuilderSession(
            repoStatus: ReportBuilderRepositoryStatus.invoiceNumberBoxCropped,
            image_path: _image_path,
            // ? image_url: "http://pbrbali.com/veryf-det/show-image/" +
            // ?    response["data"]["cropped_image_filename"],
            message:
                "Skor akurasi foto nota ${response["data"]["score"]}. (${response["data"]["runtime"]} seconds)",
            invoice_numbers: [],
          ),
        );
      }
    });
  }
}
