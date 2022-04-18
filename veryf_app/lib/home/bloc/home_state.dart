part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<Report> reports;

  HomeState({required this.reports});

  HomeState copyWith({required List<Report> reports}) {
    return HomeState(reports: reports);
  }

  @override
  List<Object> get props => [reports];
}
