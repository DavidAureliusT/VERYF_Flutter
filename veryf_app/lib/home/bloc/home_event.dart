part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class InitializeUserData extends HomeEvent {
  const InitializeUserData();
}

class RequestInvoices extends HomeEvent {
  const RequestInvoices();
}

class RequestReports extends HomeEvent {
  const RequestReports();
}

class InvoicesRetrived extends HomeEvent {
  final List<Invoice> invoices;
  const InvoicesRetrived(this.invoices);
}

class ReportsRetrived extends HomeEvent {
  final List<Report> reports;
  const ReportsRetrived(this.reports);
}

class SendReport extends HomeEvent {
  final Report newReport;
  const SendReport(this.newReport);
}

class SendReportStatusUpdated extends HomeEvent {
  final SendReportStatus status;
  const SendReportStatusUpdated(this.status);
}
