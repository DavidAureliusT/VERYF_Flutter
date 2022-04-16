import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veryf_app/home/bloc/home_bloc.dart';
import 'package:veryf_app/static/static.dart';

import 'tab_button.dart';
import 'toolbar_widget.dart';

class HomeView extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomeView());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const ToolBarWidget(height: 92),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: BlocProvider(
            create: HomeBloc(),
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
