import 'package:gsheets/gsheets.dart';
import 'package:user_dataprovider/src/models/driver.dart';

class UserDataProvider {
  static final _credentials = r'''
    {
      "type": "service_account",
      "project_id": "veryf-client",
      "private_key_id": "d0e8890705ea9256ef742b2e55792415d2119f37",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDTNSeTf1//pwTh\nyR4RjVL2w9ydBZ82lXkMofVSI+PEa4CNAVm09SNRk6GbMxS0h7ZEyp/kdxqumGZ/\nKuAHxvc+i/DT4qRL+veYvCZt6krX5oaFRy2y4yTDDg9n5pMFDhFLiV/90qcUuLpZ\nO3TlFrkAvW+M5FqnEFC/juBmgKN/3OX0BfwSgVEQ9WbQx8zB20ADv7CfurZgUOL9\npbv3KL5gAW0kJRgS2/221b+Ty7mHjmSIhaWOhGn+01i+6wl0nqSFmrIs6BufNwOm\nTfhv6A3WjDAwGgSPj9D+n+k0jVApJ8UtAFn4FzoVmojzX3wgnwq2x5WHsFhs+Oml\nphcncrg9AgMBAAECggEACxkD/pfRipcd0PhWnGD9jupNOAdLgvHOhbz9LTGmE5Qm\nJyKUR7IexuKij0tbPJN/SV+P5bsNZkcAkbuGFdqHnhwlIsO0qCpkd/x2P3hxXM/9\nLwPFsVyGj2TjJy2MzutFj4oacWBFd7eve6X9tyuJu9x4VUygEnRaGH/7J1+oglIX\nruseClKOwzn2NrsyaqrkuvthiBeyr3LzjsqQzFjtU76b7ggQElh9SA6Y7fm2qW5b\nnoJTQpNJMY1lWqDNwDG50B3CPNG/vsTGyKwGhv0n8hDvxfjCNJIa9dowHGis/KbB\nZRan1bEv1GFugUgNZLGJd9COwqRCpiY3VFg5z/Te+QKBgQD4uAWoVHcu2Pv5W4wk\nJryWg6LtvBMt8frlu5veX/SHxDx8Q70LclZYlAYE4SEyQqqz3Al/DQkWt7fmxcjQ\nsXdhyePw7zyKDX/ewo+1tpc4is1NTOPm7kbrVGHmTIge9JoLWID0ojRS1XAYfMnd\nN0hdgteyA6N+2Uh8XdTeTS8y5QKBgQDZZAL7T9JPPGMbpL5h/FdWFJA5eLqDPBoh\nuqKxJbSWaLn4BX8+BwDE9O1a8OqM+4zmNyqVl12X9/h37MTYiLXm+h4y9V/Y7ErU\n0MzlsOhjgzmtyKaP6t8ugpa6VgFb5wEDYjgYkitSiEafhImp4iBgfms3FD1S0lmn\nWuThPYhieQKBgQDQXKHotfIunfrhmI8bzhPZaCf7T78lk32kLfpTXkGl54DgfYMG\n7t9lT4SHW+8Kgw0spl6SQGJn1LtMqk8kfjfMBW1e75zg7pQ8EvR/v5qJ9MYvRwX5\n9Y4WIdfuLhkvDa1radaGmsiIyGQjL4+RMnn+VNnMOP4kC3WNMrJdFX4//QKBgB2A\ngx8UABicu15/Bw9JLZkTBVenWLiCqZE2QOoFkfJvl/1e0ZvbW3FfQ+75jvs/ECoW\nBoNynVMIZgHwce5o7za/buW/gxhvSOCEzanGTmNi5ar99gzF9S/crRPwpBKS0QJi\ni/ZZr+Ntdxgi5oPVmks+HNLGvmPFBEHABhvDPAURAoGAexNRceCInXCWUYd6YL3d\nrcqJmr2YkeOxwACNDrcJEgaYHaKxcI8Aa4kjAKBapCiKfOVy+k6LsK5mdtXmOnqS\n89AfiMegE6BNje8cRniwY1FECG1FhxmscLYjnFev+Fb5e2HUYnf2ZKvf/5gd4eeP\nw3uSZpAlzFmwwWIqj2hKRsQ=\n-----END PRIVATE KEY-----\n",
      "client_email": "veryf-client-gsheets@veryf-client.iam.gserviceaccount.com",
      "client_id": "101307107569315196952",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/veryf-client-gsheets%40veryf-client.iam.gserviceaccount.com"
    }
    ''';
  static final spreadsheetId = "1-0JKVifASP3dbhVYOdJGpw-TtO4QEZNtg6OLDfhTGHM";
  static final _driverHeaders = ["ID", "DRIVERNAME", "EMAIL", "PASSWORD"];

  GSheets? _gsheets;
  Worksheet? _driverSheet;

  UserDataProvider();

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  Future init() async {
    print("Start initialize the user data provider!");
    if (_gsheets == null) {
      try {
        _gsheets = GSheets(_credentials);
        final spreadsheet = await _gsheets!.spreadsheet(spreadsheetId);
        _driverSheet = await _getWorkSheet(spreadsheet, title: "Drivers");
        _driverSheet!.values.insertRow(1, _driverHeaders);
      } on Exception catch (e) {
        print("Init Error: $e");
      }
    }
    print("user data provider initialized!");
  }

  Future<List<Driver>>? getAllDriver() async {
    final data = await _driverSheet!.values.map.allRows(fromRow: 2, count: 5);
    return data == null ? <Driver>[] : data.map(Driver.fromJson).toList();
  }
}
