import 'package:ecobee_csv_analyzer/data_provider.dart';
import 'package:ecobee_csv_analyzer/widgets/troubleshoot_output.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Troubleshooting {
  List<dynamic> reportList;
  String serialNumber;
  String thermostatName;
  String startDate;
  String endDate;
  var values = [];
  int duration = 0;

  Troubleshooting(List<dynamic> reportList) {
    this.reportList = reportList;
  }

  Future<List<dynamic>> findIssues() async {
    serialNumber = reportList
        .elementAt(3)
        .toString()
        .substring(0, reportList.elementAt(3).toString().indexOf('\n'));
    thermostatName = reportList
        .elementAt(6)
        .toString()
        .substring(0, reportList.elementAt(6).toString().indexOf('\n'));
    startDate = reportList
        .elementAt(9)
        .toString()
        .substring(0, reportList.elementAt(9).toString().indexOf('\n'));
    endDate = reportList
        .elementAt(12)
        .toString()
        .substring(0, reportList.elementAt(9).toString().indexOf('\n'));

    values.add(serialNumber);
    values.add(thermostatName);
    values.add(startDate);
    values.add(endDate);
//    print(serialNumber);
//    print(thermostatName);
//    print(startDate);
//    print(endDate);
//    print(reportList.length);

    bool isHeating = false;
    double getCurrentTemperature;
    String issue = '';
    Color issueColor = Colors.white;
    for (int i = 0; i < reportList.length; i++) {
      //     print(i.toString() + ' : ' + reportList.elementAt(i).toString());
//      if (reportList.elementAt(i).toString().contains('\n') &&
//          !reportList.elementAt(i).toString().contains('#')) {
//        print('new line');
//      }

      if ((i >= 43) && ((i - 43) % 19) == 0) {
        //     print('is it heating or not?');

        if (reportList.elementAt(i) != 0 && reportList.elementAt(i) != "") {
          //      print('It is heating!');
          //       print(reportList.elementAt(i));
          if (isHeating == false) {
            //heating just started
            //         print('heating just started now!');
            //
            getCurrentTemperature = reportList.elementAt(i - 5);
//            print('heating start time: ' +
//                reportList.elementAt(i - 13).toString().substring(
//                    reportList.elementAt(i - 13).toString().indexOf('\n') + 1) +
//                ' ' +
//                reportList.elementAt(i - 12).toString());

            values.add('heat');
            values.add(reportList.elementAt(i - 13).toString().substring(
                    reportList.elementAt(i - 13).toString().indexOf('\n') + 1) +
                ' ' +
                reportList.elementAt(i - 12).toString());

            duration = reportList.elementAt(i);

            isHeating = true;
          }
          //continue heating
          else {
            //yellow
            if (reportList.elementAt(i - 5) == getCurrentTemperature) {
             // if (!issue.contains("Steady current temperature"))
              //  issue = issue + "- Steady current temperature";
              //issueColor = Colors.yellow;
            }
            //red
            else if (reportList.elementAt(i - 5) < getCurrentTemperature) {
              if (!issue
                  .contains("- Temperature decreasing on heating call")) {
                issue = issue + "- Temperature decreasing on heating call";
                issueColor = Colors.red;
              }
            }
            duration = duration + reportList.elementAt(i);
          }
        } else {
          // if heating stage 1 is zero
          //heating just stopped
          // print('heating just stopped' + reportList.elementAt(i).toString());

          if (isHeating) {
            //if current temp is not visible, it means the ecobee is powered off. high limit switch issue.
            if (reportList.elementAt(i - 5) == "") {
              issue = "High Limit Switch Issue";
              //  print(issue);
              issueColor = Colors.red;
              values.add(reportList.elementAt(i - 13).toString().substring(
                      reportList.elementAt(i - 13).toString().indexOf('\n') +
                          1) +
                  ' ' +
                  reportList.elementAt(i - 12).toString());

              values.add(duration);
              values.add(issue);
              values.add(issueColor);
            } else {
//              print('heating end time: ' +
//                  reportList.elementAt(i - 13).toString().substring(
//                      reportList.elementAt(i - 13).toString().indexOf('\n') +
//                          1) +
//                  ' ' +
//                  reportList.elementAt(i - 12).toString());

              values.add(reportList.elementAt(i - 13).toString().substring(
                      reportList.elementAt(i - 13).toString().indexOf('\n') +
                          1) +
                  ' ' +
                  reportList.elementAt(i - 12).toString());

              if (issue.contains(
                      "Temperature decreasing on heating call") &&
                  duration == 300) {
                issue =
                    "Current temperature decreasing on heating call, but increased after the heating call.";
                issueColor = Colors.yellow;
              }

              values.add(duration);
              values.add(issue);
              values.add(issueColor);
            } //  print('//////////////////');
            duration = 0;
            isHeating = false;
            issue = '';
            issueColor = Colors.white;
          }
        }
      }
    }

    await new Future.delayed(new Duration(seconds: 1));

    return values;
  }
}
