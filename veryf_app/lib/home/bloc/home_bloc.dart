import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:report_repository/report_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ReportRepository _reportRepository;
  final UserRepository _userRepository;

  HomeBloc({
    required ReportRepository reportRepository,
    required UserRepository userRepository,
  })  : _reportRepository = reportRepository,
        _userRepository = userRepository,
        super(HomeState.unloaded()) {
    on<HomeEvent>((event, emit) {

    });

    // TODO: Handle onHariIniButtonTapped

    // TODO: Handle onBulanIniButtonTapped

    // TODO: override close()
    
  }

  

}
