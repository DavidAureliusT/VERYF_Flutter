import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:report_builder_repository/report_builder_repository.dart';
import 'package:report_repository/report_repository.dart';
import 'package:veryf_app/report_builder/report_builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:veryf_app/static/app_color.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final Stream _progressStream =
      Stream.periodic(const Duration(seconds: 1), (int count) {
    return count;
  });

  late StreamSubscription _progressSubscription;

  String tempDir = "";
  bool hasRequestCroppedImage = false;
  int _progress = 0;

  Future accessDownloadDirectory() async {
    // storage permission ask
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    // the downloads folder path
    Directory tempDir = await getTemporaryDirectory();
    setState(() {
      this.tempDir = tempDir.path;
    });
  }

  @override
  void initState() {
    _progressSubscription = _progressStream.listen((event) {
      setState(() {
        _progress = event;
      });
    });
    accessDownloadDirectory();
    super.initState();
  }

  @override
  void dispose() {
    _progressSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ReportBuilderBloc, ReportBuilderState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Loading",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            body: Container(
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      child: Image.file(
                        File(state.image_path),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Verification",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    if (state.repoStatus ==
                        ReportBuilderRepositoryStatus.extractingInvoiceNumber)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: LinearProgressIndicator(
                          value: _progress / 150,
                          backgroundColor: Colors.white30,
                          color: primaryColor,
                          minHeight: 20.0,
                        ),
                      ),

                    //? BuilderRepositoryStatusIndicator(
                    //?   title: "Scanning Invoice Number Box",
                    //?   isDone: state.isInvoiceNumberBoxCropped,
                    //?   isBreak: state.builderStatus == ReportBuilderStatus.error,
                    //? ),
                    //? BuilderRepositoryStatusIndicator(
                    //?   title: "Get Cropped Image",
                    //?   isDone: state.isImagePathUpdated,
                    //?   isBreak: state.builderStatus == ReportBuilderStatus.error,
                    //? ),
                    //? BuilderRepositoryStatusIndicator(
                    //?   title: "Scanning Invoice Number",
                    //?   isDone: state.isInvoiceNumberDetected,
                    //?   isBreak: state.builderStatus == ReportBuilderStatus.error,
                    //? ),
                    if (state.message != "")
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          state.message,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    if (state.invoice != Invoice.empty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Text(
                              state.invoice.nomor_nota,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              state.invoice.amount,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              state.invoice.payment_method,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    Spacer(),
                    if (state.builderStatus == ReportBuilderStatus.error)
                      TextButton(
                          onPressed: () =>
                              context.read<ReportBuilderBloc>().add(Retry()),
                          child: Text("Retry")),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// class BuilderRepositoryStatusIndicator extends StatelessWidget {
//   const BuilderRepositoryStatusIndicator({
//     Key? key,
//     required this.title,
//     required this.isDone,
//     required this.isBreak,
//   }) : super(key: key);

//   final String title;
//   final bool isDone;
//   final bool isBreak;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         if (!isDone && !isBreak)
//           Container(
//             child: SizedBox(
//               height: 25.0,
//               width: 25.0,
//               child: CircularProgressIndicator(),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//           ),
//         if (isBreak && !isDone)
//           Container(
//             child: SizedBox(
//               height: 25.0,
//               width: 25.0,
//               child: Icon(Icons.error, color: Colors.red),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//           ),
//         if (isDone || (isDone && isBreak))
//           Container(
//             child: SizedBox(
//               height: 25.0,
//               width: 25.0,
//               child: Icon(Icons.check_circle_rounded, color: Colors.green),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//           ),
//         Text(
//           "$title",
//           style: Theme.of(context).textTheme.bodyLarge,
//         )
//       ],
//     );
//   }
// }
