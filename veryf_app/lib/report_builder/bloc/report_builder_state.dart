part of 'report_builder_bloc.dart';

enum ReportBuilderStatus {
  init,
  loading,
  error,
  success,
  retry,
  sendReport,
  sendReportFailed,
  sendReportSuccess,
}

class ReportBuilderState extends Equatable {
  final ReportBuilderRepositoryStatus repoStatus;
  final bool isInvoiceNumberBoxCropped;
  final bool isImagePathUpdated;
  final bool isInvoiceNumberDetected;
  final bool isInvoiceNumberValidated;
  final Invoice invoice;
  final Report report;
  final ReportBuilderStatus builderStatus;
  final String message;
  final String image_path;
  final List<dynamic> invoice_numbers;
  final int ocr_error_counter;
  final int progress;

  const ReportBuilderState(
    this.repoStatus,
    this.builderStatus,
    this.message,
    this.image_path,
    this.invoice_numbers,
    this.isInvoiceNumberBoxCropped,
    this.isImagePathUpdated,
    this.isInvoiceNumberDetected,
    this.isInvoiceNumberValidated,
    this.invoice,
    this.report,
    this.ocr_error_counter,
    this.progress,
  );

  ReportBuilderState.init()
      : this(
          ReportBuilderRepositoryStatus.standby,
          ReportBuilderStatus.init,
          "",
          "",
          [],
          false,
          false,
          false,
          false,
          Invoice.empty,
          Report.empty,
          0,
          0,
        );

  ReportBuilderState copyWith(
          {ReportBuilderRepositoryStatus? repoStatus,
          ReportBuilderStatus? builderStatus,
          String? message,
          String? image_path,
          List<dynamic>? invoice_numbers,
          bool? isInvoiceNumberBoxCropped,
          bool? isInvoiceNumberDetected,
          bool? isInvoiceNumberValidated,
          bool? isImagePathUpdated,
          List<ReportBuilderRepositoryStatus>? repoStatusLog,
          Invoice? invoice,
          Report? report,
          int? ocr_error_counter,
          int? progress,
          bool? isSubmited,
          SendReportStatus? sendReportStatus}) =>
      ReportBuilderState(
        repoStatus = repoStatus ?? this.repoStatus,
        builderStatus = builderStatus ?? this.builderStatus,
        message = message ?? this.message,
        image_path = image_path ?? this.image_path,
        invoice_numbers = invoice_numbers ?? this.invoice_numbers,
        isInvoiceNumberBoxCropped =
            isInvoiceNumberBoxCropped ?? this.isInvoiceNumberBoxCropped,
        isImagePathUpdated = isImagePathUpdated ?? this.isImagePathUpdated,
        isInvoiceNumberDetected =
            isInvoiceNumberDetected ?? this.isInvoiceNumberDetected,
        isInvoiceNumberValidated =
            isInvoiceNumberValidated ?? this.isInvoiceNumberValidated,
        invoice = invoice ?? this.invoice,
        report = report ?? this.report,
        ocr_error_counter = ocr_error_counter ?? this.ocr_error_counter,
        progress = progress ?? this.progress,
      );

  @override
  List<Object> get props => [
        repoStatus,
        builderStatus,
        message,
        image_path,
        invoice_numbers,
        isInvoiceNumberBoxCropped,
        isImagePathUpdated,
        isInvoiceNumberDetected,
        isInvoiceNumberValidated,
        invoice,
        report,
        ocr_error_counter,
        progress,
      ];
}
