library invoice_dataprovider;

import 'package:gsheet_service/gsheet_service.dart';

class InvoiceDataProvider extends GSheetService {
  InvoiceDataProvider()
      : super("Reports", [
          'nomor_nota',
          'tipe_nota',
          'amount',
          "date",
          "time",
          "nama_driver",
          "nama_helper",
          "nama_baca",
          "payment_method",
          "is_dana_diterima",
          "foto",
          "posisi",
          "data_time_checked",
          "date_text",
          "time_text",
          "data_time_checked_text"
        ]);

  Future<List<Map<String, String>>>? getAllInvoice() async {
    final data = await worksheet.values.map.allRows(fromRow: 2);
    return data == null ? [] : data;
  }

  Future<bool> storeNewReport({
    required String nomor_nota,
    required String photo,
    required String? date,
    required String? time,
    required String? location,
    required String? creator,
  }) async {
    final isFotoUpdated = await super.updateCell(
      id: int.parse(nomor_nota),
      key: "foto",
      value: photo,
    );
    print("isFotoUpdated: $isFotoUpdated");
    final isDateUpdated = await super.updateCell(
      id: int.parse(nomor_nota),
      key: "date_text",
      value: date,
    );
    print("isDateUpdated: $isDateUpdated");
    final isTimeUpdated = await super.updateCell(
      id: int.parse(nomor_nota),
      key: "time_text",
      value: time,
    );
    print("isTimeUpdated: $isTimeUpdated");
    final isLocationUpdated = await super.updateCell(
      id: int.parse(nomor_nota),
      key: "posisi",
      value: location,
    );
    print("isLocationUpdated: $isLocationUpdated");

    return isFotoUpdated && isDateUpdated && isTimeUpdated && isLocationUpdated;
  }
}
