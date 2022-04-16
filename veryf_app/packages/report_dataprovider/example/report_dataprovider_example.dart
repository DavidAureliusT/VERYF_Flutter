import 'package:report_dataprovider/report_dataprovider.dart';

Future main() async {
  ReportDataProvider dataProvider = ReportDataProvider();
  await dataProvider.init();
  final reports = await dataProvider.getAllReport();
  reports?.forEach((element) => print(element));
}
