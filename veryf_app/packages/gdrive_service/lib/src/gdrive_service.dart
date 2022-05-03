import 'dart:io';

import 'package:gdrive_service/helpers/constants.dart';
import 'package:googleapis/drive/v3.dart' as gdrive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

class GDriveService {
  List<String> _scopes = [gdrive.DriveApi.driveScope];

  getHttpClient() async {
    return await clientViaUserConsent(ClientId(clientId), _scopes, prompt);
  }

  prompt(String url) {
    launchUrl(Uri.parse(url));
  }

  Future<String> upload(File file) async {
    var client = await getHttpClient();
    var drive = gdrive.DriveApi(client);
    var res = await drive.files.create(
      gdrive.File(),
      uploadMedia: gdrive.Media(file.openRead(), file.lengthSync()),
    );
    return res.id.toString();
  }
}
