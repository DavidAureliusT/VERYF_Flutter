import 'dart:async';

// import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:report_repository/report_repository.dart';
import 'package:veryf_app/authentication/authentication.dart';
// import 'package:veryf_app/home/home.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ReportRepository _reportRepository;

  late AuthenticationBloc _authenticationBloc;

  late StreamSubscription<List<Invoice>> _invoicesSubscription;
  late StreamSubscription<List<Report>> _reportsSubscription;

  HomeBloc({
    required AuthenticationBloc authenticationBloc,
  })  : _reportRepository = ReportRepository(),
        _authenticationBloc = authenticationBloc,
        super(HomeState(reports: [])) {
    on<RequestReports>(_onRequestReports);
    on<ReportsRetrived>(_onReportRetrived);
    _reportsSubscription = _reportRepository.reports.listen((reports) {
      add(ReportsRetrived(reports));
    });
  }
  @override
  Future<void> close() {
    _reportsSubscription.cancel();
    _invoicesSubscription.cancel();
    _reportRepository.dispose();
    return super.close();
  }

  Future<void> _onRequestReports(
    RequestReports event,
    Emitter<HomeState> emit,
  ) async {
    // print("Request Report");
    Future.delayed(Duration(seconds: 3), () {
      print(
          "request report punya ${_authenticationBloc.state.driver.driverName}!");
      _reportRepository.getReports(
          driverName: _authenticationBloc.state.driver.driverName);
    });
  }

  Future<void> _onReportRetrived(
    ReportsRetrived event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(reports: event.reports));
  }
}
