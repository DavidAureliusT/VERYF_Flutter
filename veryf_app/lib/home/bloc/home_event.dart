part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class RequestReports extends HomeEvent {
  const RequestReports();
}

class ReportsRetrived extends HomeEvent {
  final List<Report> reports;
  const ReportsRetrived(this.reports);
}
