import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:report_builder_repository/report_builder_repository.dart';
import 'package:veryf_app/report_builder/report_builder.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    Key? key,
  }) : super(key: key);

  static Route route(
      {required ReportBuilderRepository reportBuilderRepository}) {
    return MaterialPageRoute(builder: (_) => CameraPage());
  }

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription>? cameras;
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    initCamera().then((_) {
      setCamera(0);
    });
  }

  Future initCamera() async {
    cameras = await availableCameras();
    setState(() {});
  }

  Future<File> takePicture() async {
    XFile? file;
    try {
      file = await controller?.takePicture();
    } catch (e) {}
    return File(file!.path);
  }

  void setCamera(int index) {
    controller = CameraController(cameras![index], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<File> fixExifRotation(String imagePath) async {
    final originalFile = File(imagePath);
    List<int> imageBytes = await originalFile.readAsBytes();

    final originalImage = img.decodeImage(imageBytes);

    img.Image fixedImage = img.copyRotate(originalImage!, -90);

    final fixedFile =
        await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

    return fixedFile;
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ReportBuilderBloc, ReportBuilderState>(
          builder: (context, state) {
            return Column(
              children: [
                Stack(
                  children: [
                    CameraPreview(controller!),
                    // SizedBox.(
                    //   child: Image.asset(
                    //     "assets/images/GuidingCamera.png",
                    //     fit: BoxFit.fill,
                    //   ),
                    // ),

                    // Center(
                    //   child: AspectRatio(
                    //     aspectRatio: 0.75,
                    //     child: CameraPreview(controller!),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.width * 4 / 3,
                    //   width: MediaQuery.of(context).size.width,
                    //   child:
                    // ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.width * 4 / 3,
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Image.asset(
                    //     "assets/images/GuidingCamera.png",
                    //     fit: BoxFit.cover,
                    //   ),
                    // )
                  ],
                ),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        // File imageFile = await takePicture();
                        final filename = "sample.jpg";
                        final samplePath = "images/$filename";
                        final byteData =
                            await rootBundle.load('assets/$samplePath');
                        final file = await File(
                                '${(await getApplicationDocumentsDirectory()).path}/$filename')
                            .create(recursive: true);

                        await file.writeAsBytes(byteData.buffer.asUint8List(
                            byteData.offsetInBytes, byteData.lengthInBytes));

                        final String documentPath =
                            (await getApplicationDocumentsDirectory()).path;

                        final storedFile = await File('$documentPath/$filename')
                            .create(recursive: true);

                        // File rotatedImageFile =
                        //     await fixExifRotation(storedFile.path);

                        context
                            .read<ReportBuilderBloc>()
                            .add(CameraCaptureImage("${storedFile.path}"));
                      },
                      child:
                          Image.asset('assets/images/CaptureImageButton.png'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
