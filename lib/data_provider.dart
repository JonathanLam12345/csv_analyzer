import 'package:ecobee_csv_analyzer/widgets/troubleshoot_output.dart';
import 'package:flutter/foundation.dart';

class DataProvider extends ChangeNotifier {
  String serialNumber;
  String thermostatName;
  String startDate;
  String endDate;


  DataProvider();


  void updateThermostatName(String thermostatName) {   //The read method is in change of calling this.
    this.thermostatName = thermostatName;
    notifyListeners();
  }
}
