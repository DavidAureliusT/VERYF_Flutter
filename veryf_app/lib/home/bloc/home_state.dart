part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<Invoice> invoices;
  final List<Report> reports;
  final DateTime dateTime;
  final LatLng latLng;
  final SendReportStatus sendReportStatus;

  HomeState({
    required this.invoices,
    required this.reports,
    required this.dateTime,
    required this.latLng,
    required this.sendReportStatus,
  });

  HomeState copyWith({
    List<Invoice>? invoices,
    List<Report>? reports,
    DateTime? dateTime,
    LatLng? latLng,
    SendReportStatus? sendReportStatus,
  }) {
    return HomeState(
      invoices: invoices ?? this.invoices,
      reports: reports ?? this.reports,
      dateTime: dateTime ?? this.dateTime,
      latLng: latLng ?? this.latLng,
      sendReportStatus: sendReportStatus ?? this.sendReportStatus,
    );
  }

  @override
  List<Object> get props => [
        invoices,
        reports,
        dateTime,
        latLng,
        sendReportStatus,
      ];
}
