import 'package:user_dataprovider/user_dataprovider.dart';

Future<void> main() async {
  UserDataProvider userDataProvider = UserDataProvider();
  await userDataProvider.init();
  print("try to get all driver data");
  final drivers = await userDataProvider.getAllDriver();
  drivers?.forEach((element) {
    print(
        "Driver: {${element.id}, ${element.driverName}, ${element.email}, ${element.password}}");
  });
}
