// import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:report_repository/report_repository.dart';
import 'package:veryf_app/authentication/authentication.dart';
import 'package:veryf_app/home/bloc/home_bloc.dart';
import 'package:veryf_app/home/view/views.dart';
import 'package:veryf_app/static/static.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.reportRepository,
  }) : super(key: key);

  final ReportRepository reportRepository;

  static Route route({required ReportRepository reportRepository}) {
    return MaterialPageRoute(
        builder: (_) => HomePage(reportRepository: reportRepository));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedPage; //? untuk navigasi antar page
  late PageController _pageController; //? controller untuk page slider

  // final List<ReportCard> _listLaporanHariIni = List.generate(7, (index) {
  //   return ReportCard(
  //       image: Image.asset('assets/images/sample.jpg'),
  //       invoice_number: "#123456");
  // }); //? Builder LaporanCard base on reports

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
        authenticationBloc: RepositoryProvider.of<AuthenticationBloc>(context),
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: const ToolBarWidget(height: 92),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Laporan Driver",
                  style: h4,
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
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      // Iterable<Widget> reportListHariIni = {};
                      Iterable<Widget> reportListBulanIni = {};
                      reportListBulanIni = state.reports.map(
                        (report) {
                          // if (report.dateTime.month == DateTime.now().month) {
                          return ReportCard(
                            image: Image.asset('assets/images/sample.jpg'),
                            invoice_number: report.nomor_nota,
                          );
                          // }
                          // return Text("No Report This Month");
                        },
                      );
                      context.read<HomeBloc>().add(RequestReports());
                      return PageView(
                        onPageChanged: (int _pageNumber) {
                          setState(() {
                            _selectedPage = _pageNumber;
                          });
                        },
                        controller: _pageController,
                        children: [
                          GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 3 / 4,
                            children: [
                              TextButton(
                                onPressed: () => context
                                    .read<HomeBloc>()
                                    .add(RequestReports()),
                                child: Text("Reload"),
                              )
                            ],
                          ),
                          GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 3 / 4,
                            children: reportListBulanIni.toList(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/camera');
            },
            child: const Icon(Icons.add),
            backgroundColor: primaryColor,
          ),
        ),
      ),
    );
  }
}

// reportListHariIni = state.reports!.map(
//   (report) {
    // if (report.dateTime.day == DateTime.now().day) {
//     return ReportCard(
//       image: Image.asset('assets/images/sample.jpg'),
//       invoice_number: report.nomor_nota,
//     );
    // }
    // return Text("No Report Today");
//   },
// );
// reportListBulanIni = state.reports!.map(
//   (report) {
    // if (report.dateTime.month == DateTime.now().month) {
//     return ReportCard(
//       image: Image.asset('assets/images/sample.jpg'),
//       invoice_number: report.nomor_nota,
//     );
    // }
    // return Text("No Report This Month");
//   },
// );

// return PageView(
//   onPageChanged: (int _pageNumber) {
//     setState(() {
//       _selectedPage = _pageNumber;
//     });
//   },
//   controller: _pageController,
//   children: [
//     GridView.count(
//       crossAxisCount: 2,
//       mainAxisSpacing: 16,
//       crossAxisSpacing: 16,
//       childAspectRatio: 3 / 4,
//       children: [
//         Text(reportListHariIni.toList().length.toString())
//       ],
//     ),
//     GridView.count(
//       crossAxisCount: 2,
//       mainAxisSpacing: 16,
//       crossAxisSpacing: 16,
//       childAspectRatio: 3 / 4,
//       children: [
//         Text(
//             reportListBulanIni.toList().length.toString())
//       ],
//     ),
//   ],
// );