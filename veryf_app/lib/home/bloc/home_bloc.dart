import 'dart:async';

// import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlng/latlng.dart';
import 'package:location/location.dart';
import 'package:report_repository/report_repository.dart';
import 'package:veryf_app/authentication/authentication.dart';
// import 'package:veryf_app/home/home.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ReportRepository _reportRepository;

  late AuthenticationBloc _authenticationBloc;

  late StreamSubscription<List<Report>> _reportsSubscription;
  late StreamSubscription<List<Invoice>> _invoicesSubscription;

  HomeBloc({
    required AuthenticationBloc authenticationBloc,
    required ReportRepository reportRepository,
  })  : _reportRepository = reportRepository,
        _authenticationBloc = authenticationBloc,
        super(HomeState(
          invoices: [],
          reports: [],
          dateTime: DateTime.now(),
          latLng: LatLng(0, 0),
          sendReportStatus: SendReportStatus.standby,
        )) {
    on<RequestReports>(_onRequestReports);
    on<RequestInvoices>(_onRequestInvoices);
    on<ReportsRetrived>(_onReportsRetrived);
    on<InvoicesRetrived>(_onInvoicesRetrived);
    on<InitializeUserData>(_onInitializeUserData);
    on<SendReport>(_onSendReport);
    add(InitializeUserData());
    add(RequestReports());
    _reportsSubscription = _reportRepository.reports.listen((reports) {
      add(ReportsRetrived(reports));
    });
    _invoicesSubscription = _reportRepository.invoices.listen((invoices) {
      add(InvoicesRetrived(invoices));
    });
  }

  @override
  Future<void> close() {
    _invoicesSubscription.cancel();
    _reportsSubscription.cancel();
    _reportRepository.dispose();
    return super.close();
  }

  Future<void> _onInitializeUserData(
    InitializeUserData event,
    Emitter<HomeState> emit,
  ) async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    final _lat = _locationData.latitude!;
    final _lng = _locationData.longitude!;
    final _latLng = LatLng(_lat, _lng);
    emit(state.copyWith(latLng: _latLng));
  }

  Future<void> _onRequestReports(
    RequestReports event,
    Emitter<HomeState> emit,
  ) async {
    print(
        "Request Reports punya ${_authenticationBloc.state.driver.driverName}!!");
    Future.delayed(Duration(seconds: 3), () {
      _reportRepository.getReports(
          driverName: _authenticationBloc.state.driver.driverName);
    });
  }

  Future<void> _onRequestInvoices(
    RequestInvoices event,
    Emitter<HomeState> emit,
  ) async {
    print("Request Invoices !!");
    Future.delayed(Duration(seconds: 3), () {
      _reportRepository.getInvoices(
          driverName: _authenticationBloc.state.driver.driverName);
    });
  }

  Future<void> _onReportsRetrived(
    ReportsRetrived event,
    Emitter<HomeState> emit,
  ) async {
    print("_onReportsRetrived");
    print("current reports event${event.reports.length}");
    event.reports.forEach((report) =>
        print("${report.nomor_nota} - ${report.amount} - ${report.photo}"));
    emit(state.copyWith(
      reports: event.reports,
    ));
  }

  Future<void> _onInvoicesRetrived(
    InvoicesRetrived event,
    Emitter<HomeState> emit,
  ) async {
    print("_onInvoicesRetrived");
    print("current Invoice state${event.invoices.length}");
    event.invoices.forEach((invoice) =>
        print("${invoice.nomor_nota} - ${invoice.amount} - ${invoice.foto}"));
    emit(state.copyWith(
      invoices: event.invoices,
    ));
  }

  Future<void> _onSendReport(
    SendReport event,
    Emitter<HomeState> emit,
  ) async {
    await _reportRepository.sendReport(report: event.newReport);
  }
}
