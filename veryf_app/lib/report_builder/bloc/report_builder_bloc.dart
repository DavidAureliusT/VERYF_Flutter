import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:report_builder_repository/report_builder_repository.dart';
import 'package:report_repository/report_repository.dart';
import 'package:veryf_app/authentication/authentication.dart';
import 'package:veryf_app/home/bloc/home_bloc.dart';

part 'report_builder_event.dart';
part 'report_builder_state.dart';

class ReportBuilderBloc extends Bloc<ReportBuilderEvent, ReportBuilderState> {
  final ReportBuilderRepository _reportBuilderRepository;
  final HomeBloc _homeBloc;
  final AuthenticationBloc _authenticationBloc;
  late StreamSubscription<ReportBuilderSession>
      _reportBuilderStatusSubscription;

  late StreamSubscription<SendReportStatus> _sendReportStatusSubscription;

  ReportBuilderBloc({
    required ReportBuilderRepository reportBuilderRepository,
    required AuthenticationBloc authenticationBloc,
    required HomeBloc homeBloc,
    required ReportRepository reportRepository,
  })  : this._reportBuilderRepository = reportBuilderRepository,
        this._authenticationBloc = authenticationBloc,
        this._homeBloc = homeBloc,
        super(ReportBuilderState.init()) {
    on<ReportBuilderRepositoryStatusChanged>(
        _onReportBuilderRepositoryStatusChanged);
    on<CameraCaptureImage>(_onCameraCaptureImage);
    on<DownloadCroppedImage>(_onDownloadCroppedImage);
    on<Retry>(_onRetry);
    on<SubmitReport>(_onSubmitReport);
    on<SendReportStatusUpdated>(_onSendReportStatusUpdated);

    _reportBuilderStatusSubscription =
        _reportBuilderRepository.session.listen((session) {
      add(ReportBuilderRepositoryStatusChanged(
        session.repoStatus,
        session.image_path,
        session.message,
        session.invoice_numbers,
      ));
    });

    _sendReportStatusSubscription = reportRepository.status.listen((status) {
      add(SendReportStatusUpdated(status));
    });
  }

  @override
  Future<void> close() {
    _reportBuilderStatusSubscription.cancel();
    _sendReportStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onReportBuilderRepositoryStatusChanged(
    ReportBuilderRepositoryStatusChanged event,
    Emitter<ReportBuilderState> emit,
  ) async {
    bool isInvoiceNumberBoxCropped = state.isInvoiceNumberBoxCropped;
    bool isInvoiceNumberDetected = state.isInvoiceNumberDetected;
    bool isImagePathUpdated = state.isImagePathUpdated;
    Invoice _tempInvoice = state.invoice;
    Report _tempReport = state.report;
    // bool isInvoiceNumberValidated = state.isInvoiceNumberValidated;

    late ReportBuilderStatus builderStatus;

    switch (event.repoStatus) {
      case ReportBuilderRepositoryStatus.extractingInvoiceNumber:
        builderStatus = ReportBuilderStatus.loading;
        break;
      case ReportBuilderRepositoryStatus.extractionFailed:
        builderStatus = ReportBuilderStatus.error;
        break;
      case ReportBuilderRepositoryStatus.extractionSuccess:
        builderStatus = ReportBuilderStatus.success;
        print(_homeBloc.state.invoices.length);
        if (_homeBloc.state.invoices.length > 0)
          _homeBloc.state.invoices.forEach((invoice) {
            if (_tempInvoice == Invoice.empty) {
              if (event.invoice_numbers
                  .map((item) => item as String)
                  .toList()
                  .contains(invoice.nomor_nota)) {
                _tempInvoice = invoice;
              }
            }
          });
        _tempReport = Report(
          state.image_path,
          _homeBloc.state.dateTime,
          _homeBloc.state.latLng,
          _authenticationBloc.state.driver.driverName,
          _tempInvoice.nomor_nota,
          _tempInvoice.amount,
          _tempInvoice.payment_method,
        );

        break;
      case ReportBuilderRepositoryStatus.scanningInvoiceNumberBox:
        builderStatus = ReportBuilderStatus.loading;
        break;
      case ReportBuilderRepositoryStatus.invoiceNumberBoxCropped:
        builderStatus = ReportBuilderStatus.loading;
        isInvoiceNumberBoxCropped = true;
        break;
      case ReportBuilderRepositoryStatus.invoiceNumberBoxUndetected:
        builderStatus = ReportBuilderStatus.error;
        break;
      case ReportBuilderRepositoryStatus.downloadCroppedImage:
        builderStatus = ReportBuilderStatus.loading;
        break;
      case ReportBuilderRepositoryStatus.imagePathUpdated:
        builderStatus = ReportBuilderStatus.loading;
        isImagePathUpdated = true;
        break;
      case ReportBuilderRepositoryStatus.downloadCroppedImageFailed:
        builderStatus = ReportBuilderStatus.error;
        break;
      case ReportBuilderRepositoryStatus.scanningInvoiceNumber:
        builderStatus = ReportBuilderStatus.loading;
        break;
      case ReportBuilderRepositoryStatus.invoiceNumberDetected:
        builderStatus = ReportBuilderStatus.loading;
        isInvoiceNumberDetected = true;
        break;
      case ReportBuilderRepositoryStatus.invoiceNumberUndetected:
        builderStatus = ReportBuilderStatus.error;
        break;
      default:
    }

    print(event.repoStatus.name);
    emit(state.copyWith(
      repoStatus: event.repoStatus,
      builderStatus: builderStatus,
      image_path: event.image_path,
      invoice_numbers: event.invoice_numbers,
      message: event.message,
      isInvoiceNumberBoxCropped: isInvoiceNumberBoxCropped,
      isImagePathUpdated: isImagePathUpdated,
      isInvoiceNumberDetected: isInvoiceNumberDetected,
      invoice: _tempInvoice,
      report: _tempReport,
    ));
  }

  Future<void> _onCameraCaptureImage(
    CameraCaptureImage event,
    Emitter<ReportBuilderState> emit,
  ) async {
    await _reportBuilderRepository.getInvoiceNumbers(
        image_path: event.image_path);
  }

  Future<void> _onDownloadCroppedImage(
    DownloadCroppedImage event,
    Emitter<ReportBuilderState> emit,
  ) async {
    await _reportBuilderRepository.getCroppedImage(
      currentImagePath: state.image_path,
      temporaryDirectory: event.temporaryDirectory,
      filename: event.filename,
    );
  }

  Future<void> _onRetry(
    Retry event,
    Emitter<ReportBuilderState> emit,
  ) async {
    var updatedState = ReportBuilderState.init();
    updatedState =
        updatedState.copyWith(ocr_error_counter: state.ocr_error_counter + 1);
    emit(updatedState);
  }

  Future<void> _onSubmitReport(
    SubmitReport event,
    Emitter<ReportBuilderState> emit,
  ) async {
    _homeBloc.add(SendReport(state.report));
    emit(state.copyWith(builderStatus: ReportBuilderStatus.sendReport));
  }

  Future<void> _onSendReportStatusUpdated(
    SendReportStatusUpdated event,
    Emitter<ReportBuilderState> emit,
  ) async {
    if (event.status == SendReportStatus.inProgress) {
      emit(state.copyWith(builderStatus: ReportBuilderStatus.sendReport));
    } else if (event.status == SendReportStatus.failed) {
      emit(state.copyWith(builderStatus: ReportBuilderStatus.sendReportFailed));
    } else if (event.status == SendReportStatus.success) {
      emit(
          state.copyWith(builderStatus: ReportBuilderStatus.sendReportSuccess));
    }
  }
}
