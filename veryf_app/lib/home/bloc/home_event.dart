part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HariIniButtonTapped extends HomeEvent {
  const HariIniButtonTapped();
}

class BulanIniButtonTapped extends HomeEvent {
  const BulanIniButtonTapped();
}
