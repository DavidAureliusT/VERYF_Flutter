// import 'dart:convert';

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class VeryfDetectionApi {
  Future<http.Response> test() {
    return http.get(Uri.parse("http://pbrbali.com/veryf-det/"));
  }

  Future<dynamic> detectInvoiceNumberBox(File imageFile) async {
    final mimeTypeData =
        lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])!.split("/");

    Uri url = Uri.parse("http://pbrbali.com/veryf-det/scan-invoice-number-box");

    var request = http.MultipartRequest("POST", url);

    final multipartFile = await http.MultipartFile.fromPath(
        "file", imageFile.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    request.files.add(multipartFile);

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);

    return json.decode(result);
  }

  Future<String> downloadCroppedImage(String currentImagePath,
      String temporaryDirectory, String filename) async {
    var dio = Dio();
    String url = "http://pbrbali.com/veryf-det/get-image/$filename";
    try {
      Response response = await dio.get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      String savePath = temporaryDirectory + "/$filename";
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return savePath;
    } catch (e) {
      print(e);
      return currentImagePath;
    }
  }

  Future<dynamic> extractInvoiceNumber(
    File image,
  ) async {
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])!.split("/");

    Uri url = Uri.parse("http://pbrbali.com/veryf-det/scan-invoice-number");

    var request = http.MultipartRequest("POST", url);

    final multipartFile = await http.MultipartFile.fromPath("file", image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    request.files.add(multipartFile);

    var response = await request.send();
    var data = "";
    print(response.statusCode);
    print(response.statusCode == 301);
    if (response.statusCode == 301) {
      var redirectUrlText = "";
      response.headers.forEach((key, value) {
        print("$key : $value");
        if (key == "location") redirectUrlText = value;
      });
      print(redirectUrlText);
      Uri redirectUrl = Uri.parse(redirectUrlText);
      var responseRedirectUrl = await http.get(redirectUrl);
      print(responseRedirectUrl.body);
      data = responseRedirectUrl.body;
    } else {
      var responseData = await response.stream.toBytes();
      data = String.fromCharCodes(responseData);
    }

    return json.decode(data);
  }
}
