import 'package:csv/csv.dart';

class CSVReader {
  final String stringFile;

  CSVReader(this.stringFile);

  List<List<dynamic>> convertStringToList(stringFile) {
    List<List<dynamic>> rowsAsListOfValues =
    const CsvToListConverter().convert(stringFile);

    return rowsAsListOfValues;
  }
}
