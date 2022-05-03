part of 'report_builder_bloc.dart';

abstract class ReportBuilderEvent extends Equatable {
  const ReportBuilderEvent();

  @override
  List<Object> get props => [];
}

class SendReportStatusUpdated extends ReportBuilderEvent {
  const SendReportStatusUpdated(this.status);

  final SendReportStatus status;

  @override
  List<Object> get props => [status];
}

class SubmitReport extends ReportBuilderEvent {
  const SubmitReport();
}

class CameraCaptureImage extends ReportBuilderEvent {
  const CameraCaptureImage(this.image_path);

  final String image_path;

  @override
  List<Object> get props => [image_path];
}

class DownloadCroppedImage extends ReportBuilderEvent {
  const DownloadCroppedImage(this.temporaryDirectory, this.filename);

  final String temporaryDirectory;
  final String filename;

  @override
  List<Object> get props => [temporaryDirectory, filename];
}

class InputInvoiceNumberManually extends ReportBuilderEvent {
  const InputInvoiceNumberManually(this.invoice_number);

  final String invoice_number;

  @override
  List<Object> get props => [invoice_number];
}

class ReportBuilderRepositoryStatusChanged extends ReportBuilderEvent {
  const ReportBuilderRepositoryStatusChanged(
      this.repoStatus, this.image_path, this.message, this.invoice_numbers);

  final ReportBuilderRepositoryStatus repoStatus;
  final String image_path;
  final String message;
  final List<dynamic> invoice_numbers;

  @override
  List<Object> get props => [repoStatus, image_path, message, invoice_numbers];
}

class Retry extends ReportBuilderEvent {
  const Retry();
}
