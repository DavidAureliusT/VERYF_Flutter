import 'dart:io';

import '../lib/gdrive_service.dart';

Future<void> main() async {
  final File imageFile = File.fromUri(Uri.parse(
      "https://drive.google.com/uc?export=view&id=1ZMS9z77arzrndPzEMrWYilk9_V4nEOOe/view?usp=sharing"));

  final gDrive = GDriveService();

  print(await gDrive.upload(imageFile));
}
