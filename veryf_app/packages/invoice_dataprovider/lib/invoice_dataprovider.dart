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
}

//contructor tabel invoices