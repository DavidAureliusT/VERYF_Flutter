import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report_builder_repository/report_builder_repository.dart';
import 'package:report_repository/report_repository.dart';
import 'package:veryf_app/authentication/authentication.dart';
import 'package:veryf_app/home/bloc/home_bloc.dart';
import 'package:veryf_app/report_builder/report_builder.dart';

class ReportBuilder extends StatelessWidget {
  const ReportBuilder({
    Key? key,
    required this.authenticationBloc,
    required this.homeBloc,
    required this.reportBuilderRepository,
    required this.reportRepository,
  }) : super(key: key);

  static Route route(HomeBloc _homeBloc, ReportRepository _reportRepository,
      BuildContext context) {
    return MaterialPageRoute<void>(
      builder: (_) => ReportBuilder(
        authenticationBloc: RepositoryProvider.of<AuthenticationBloc>(context),
        homeBloc: _homeBloc,
        reportBuilderRepository: ReportBuilderRepository(),
        reportRepository: _reportRepository,
      ),
    );
  }

  final AuthenticationBloc authenticationBloc;
  final HomeBloc homeBloc;
  final ReportBuilderRepository reportBuilderRepository;
  final ReportRepository reportRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: reportBuilderRepository,
      child: BlocProvider(
        create: (_) => ReportBuilderBloc(
          reportBuilderRepository: reportBuilderRepository,
          authenticationBloc:
              RepositoryProvider.of<AuthenticationBloc>(context),
          homeBloc: homeBloc,
          reportRepository: reportRepository,
        ),
        child: ReportBuilderNavigator(),
      ),
    );
  }
}

class ReportBuilderNavigator extends StatefulWidget {
  const ReportBuilderNavigator({Key? key}) : super(key: key);

  @override
  State<ReportBuilderNavigator> createState() => _ReportBuilderState();
}

class _ReportBuilderState extends State<ReportBuilderNavigator> {
  ReportBuilderStatus reportBuilderStatus = ReportBuilderStatus.init;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBuilderBloc, ReportBuilderState>(
      listener: (context, state) {
        if (reportBuilderStatus == ReportBuilderStatus.sendReportSuccess) {
          ;
        }
        setState(() {
          reportBuilderStatus = state.builderStatus;
        });
      },
      child: MaterialApp(
        theme: Theme.of(context),
        debugShowCheckedModeBanner: false,
        home: Navigator(
          pages: [
            if (reportBuilderStatus == ReportBuilderStatus.init ||
                reportBuilderStatus == ReportBuilderStatus.retry)
              MaterialPage(
                child: CameraPage(),
              ),
            if (reportBuilderStatus == ReportBuilderStatus.loading ||
                reportBuilderStatus == ReportBuilderStatus.error)
              MaterialPage(
                child: LoadingPage(),
              ),
            if (reportBuilderStatus == ReportBuilderStatus.success ||
                reportBuilderStatus == ReportBuilderStatus.sendReport ||
                reportBuilderStatus == ReportBuilderStatus.sendReportFailed)
              MaterialPage(
                child: FinalPage(),
              ),
          ],
          onPopPage: (route, result) {
            reportBuilderStatus = ReportBuilderStatus.init;
            return route.didPop(result);
          },
        ),
      ),
    );
  }
}
