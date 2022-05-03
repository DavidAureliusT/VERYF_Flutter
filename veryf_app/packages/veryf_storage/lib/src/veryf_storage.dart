import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class VeryfStorage {
  Future<dynamic> uploadInvoiceImage(File imageFile) async {
    print("start upload to pbr");
    final mimeTypeData =
        lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])!.split("/");

    Uri url = Uri.parse("http://pbrbali.com/veryf-det/store-invoice-image");

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
}
