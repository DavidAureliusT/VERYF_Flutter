part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List? reports;
  final int selectedPage;
  final PageController pageController = PageController();

  HomeState._({this.reports, required this.selectedPage});

  HomeState.unloaded() : this._(reports: [], selectedPage: 0);

  HomeState.loaded(List reports) : this._(reports: reports, selectedPage: 0);

  HomeState.filtered(List reports, int selectedPage)
      : this._(reports: reports, selectedPage: selectedPage);

  @override
  List<Object> get props => [selectedPage, pageController];
}
