import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/report_builder_bloc.dart';

class FinalPage extends StatelessWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBuilderBloc, ReportBuilderState>(
      listener: (context, state) {
        if (state.repoStatus == ReportBuilderStatus.sendReportFailed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                  content: Text('Send Report Failure, Please try again')),
            );
        } else if (state.repoStatus == ReportBuilderStatus.sendReportSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Send Report Success')),
            );
        }
      },
      child: BlocBuilder<ReportBuilderBloc, ReportBuilderState>(
          builder: ((context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Detail Laporan",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            body: Column(
              children: [
                Image.file(File(state.image_path)),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("${state.report.creator}"),
                      Text(
                        "Waktu",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(
                        height: 18.0,
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/date_icon.png",
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "${state.report.dateTime?.day}-${state.report.dateTime?.month}-${state.report.dateTime?.year}",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.0),
                      SizedBox(
                        height: 18.0,
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/time_icon.png",
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "${state.report.dateTime?.hour} : ${state.report.dateTime?.minute}",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Lokasi",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(height: 4.0),
                      SizedBox(
                        height: 18.0,
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/location_icon.png",
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "${state.report.location!.latitude}, ${state.report.location!.longitude}",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Info Nota",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            "Nomor Nota",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Spacer(),
                          Text(
                            "#${state.report.nomor_nota}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Text(
                            "Amount",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Spacer(),
                          Text(
                            "Rp ${state.report.amount}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Text(
                            "Metode Pembayaran",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Spacer(),
                          Text(
                            "${state.report.payment_method}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      state.repoStatus == ReportBuilderStatus.sendReport
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () => context
                                  .read<ReportBuilderBloc>()
                                  .add(SubmitReport()),
                              child: Text("Simpan"),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      })),
    );
  }
}
