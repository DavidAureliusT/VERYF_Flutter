import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlng/latlng.dart';
import 'package:report_repository/report_repository.dart';
import 'package:veryf_app/authentication/authentication.dart';
import 'package:veryf_app/home/bloc/home_bloc.dart';
import 'package:veryf_app/home/view/views.dart';
import 'package:veryf_app/report_builder/views/report_builder_navigator.dart';
import 'package:veryf_app/static/static.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.reportRepository,
  }) : super(key: key);

  final ReportRepository reportRepository;

  static Route route({required ReportRepository reportRepository}) {
    return MaterialPageRoute(
        builder: (_) => RepositoryProvider(
              create: (context) => ReportRepository(),
              child: HomePage(reportRepository: reportRepository),
            ));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedPage;
  late PageController _pageController;
  Iterable<Widget> reportListHariIni = {};
  Iterable<Widget> reportListBulanIni = {};
  int invoicesCount = 0;
  int reportsCount = 0;
  LatLng location = LatLng(0, 0);

  void _changePage(int pageNumber) {
    setState(() {
      _selectedPage = pageNumber;
      _pageController.animateToPage(
        pageNumber,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  void _updateHome(HomeState state) {
    if (state.reports.length != reportsCount ||
        state.invoices.length != invoicesCount ||
        state.latLng != location) {
      setState(() {
        invoicesCount = state.invoices.length;
        reportsCount = state.reports.length;
        location = state.latLng;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedPage = 0;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        reportRepository: RepositoryProvider.of<ReportRepository>(context),
        authenticationBloc: RepositoryProvider.of<AuthenticationBloc>(context),
      ),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                titleSpacing: 8.0,
                title: Text(
                  'Welcome, ${state.driver.driverName}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                actions: [
                  TextButton(
                    onPressed: () => context
                        .read<AuthenticationBloc>()
                        .add(AuthenticationLogoutRequested()),
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Invoice: $invoicesCount"),
                    Text("Total Report: $reportsCount"),
                    // Text(
                    // "Location: ${location.latitude}, ${location.longitude}"),
                    Row(
                      children: [
                        Text(
                          "Laporan Driver",
                          style: h4,
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () =>
                              context.read<HomeBloc>().add(RequestReports()),
                          child: Text(
                            "Refresh",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          TabButtonWidget(
                            text: "HARI INI",
                            selectedPage: 0,
                            pageNumber: _selectedPage,
                            // onPressed: () => print("change page 0"),
                            onPressed: () => _changePage(0),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TabButtonWidget(
                            text: "BULAN INI",
                            selectedPage: 1,
                            pageNumber: _selectedPage,
                            // onPressed: () => print("change page 1"),
                            onPressed: () => _changePage(1),
                          ),
                        ],
                      ),
                    ),
                    BlocListener<HomeBloc, HomeState>(
                      listener: (context, state) {
                        _updateHome(state);
                      },
                      child: Expanded(
                        child: BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            reportListBulanIni = state.reports.map(
                              (report) {
                                return ReportCard(
                                  image: Image.network(report.photo),
                                  invoice_number: report.nomor_nota,
                                );
                              },
                            );
                            reportListHariIni = reportListBulanIni;
                            return PageView(
                              onPageChanged: (int _pageNumber) {
                                setState(() {
                                  _selectedPage = _pageNumber;
                                });
                              },
                              controller: _pageController,
                              children: [
                                GridView.count(
                                  padding: EdgeInsets.only(right: 8.0),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 3 / 4,
                                  children: reportListHariIni.toList(),
                                ),
                                GridView.count(
                                  padding: EdgeInsets.only(right: 8.0),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 3 / 4,
                                  children: reportListBulanIni.toList(),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    ReportBuilder.route(
                      RepositoryProvider.of<HomeBloc>(context),
                      RepositoryProvider.of<ReportRepository>(context),
                      context,
                    ),
                  );
                },
                child: const Icon(Icons.add),
                backgroundColor: primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
