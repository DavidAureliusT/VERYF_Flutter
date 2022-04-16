library driver_dataprovider;

import 'package:gsheet_service/gsheet_service.dart';

class DriverDataProvider extends GSheetService {
  DriverDataProvider()
      : super("Drivers", ['ID', 'DRIVERNAME', "EMAIL", "PASSWORD"]);

  Future<List<Map<String, String>>>? getAllDriver() async {
    final data = await worksheet.values.map.allRows(fromRow: 2, count: 5);
    return data == null ? [] : data;
  }
}
