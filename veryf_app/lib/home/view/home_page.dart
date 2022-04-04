import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veryf_app/authentication/authentication.dart';
import 'package:veryf_app/home/view/views.dart';
import 'package:veryf_app/static/static.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedPage;
  late PageController _pageController;
  final List<LaporanCardWidget> _listLaporanHariIni = List.generate(7, (index) {
    return LaporanCardWidget(
        image: Image.asset('assets/images/sample.jpg'),
        invoice_number: "#123456");
  });

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
    return SafeArea(
      child: Scaffold(
        appBar: ToolBarWidget(height: 92),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Laporan Driver",
                style: h4,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.0),
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
                child: PageView(
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
                      children: _listLaporanHariIni,
                    ),
                    // TODO: Filtered Laporan
                    const Center(
                      child: Text("Page 2"),
                    ),
                  ],
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
    );
  }
}

// return Scaffold(
    //   appBar: AppBar(title: const Text('Home')),
    //   body: Center(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: <Widget>[
    //         Builder(
    //           builder: (context) {
    //             final user = context.select(
    //               (AuthenticationBloc bloc) => bloc.state.user,
    //             );
    //             return Text(
    //                 'User: {${user.id}, ${user.username}, ${user.email}}');
    //           },
    //         ),
    //         ElevatedButton(
    //           child: const Text('Logout'),
    //           onPressed: () {
    //             context
    //                 .read<AuthenticationBloc>()
    //                 .add(AuthenticationLogoutRequested());
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );