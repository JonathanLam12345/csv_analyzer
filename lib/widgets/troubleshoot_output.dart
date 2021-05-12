import 'package:link/link.dart';

import 'package:flutter/material.dart';

class AnalyzedReport extends StatelessWidget {
  final reportList;

  AnalyzedReport(this.reportList);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: reportList.length,
        itemBuilder: (BuildContext context, int index) {
          // print('index: ' + index.toString());

          if (index == 0) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TableInfo("Serial Number", reportList[index]),
              ],
            );
          }
          if (index == 1) {
            return TableInfo("Thermostat Name", reportList[index]);
          }
          if (index == 2) {
            return TableInfo("Start Date", reportList[index]);
          }
          if (index == 3) {
            return TableInfo("End Date", reportList[index]);
          }

          /////////////////////////////////
          if ((index == 4)) {
            //print('help me');
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TableInfoIssues("System Mode", "Start Time", "End Time",
                    "Duration (sec)", "Issue", Colors.grey[350]),
                TableInfoIssues(
                  reportList[index].toString(), //heat
                  reportList[index + 1].toString(), //startTime
                  reportList[index + 2].toString(), //endTime
                  reportList[index + 3].toString(), //duration
                  reportList[index + 4].toString(), //issue
                  reportList[index + 5], //issueColor
                ),
              ],
            );
          }
          if (index >= 9 &&
              ((index - 4) % 6 == 0) &&
              index < (reportList.length - 4)) {
            return TableInfoIssues(
                reportList[index].toString(),
                reportList[index + 1].toString(),
                reportList[index + 2].toString(),
                reportList[index + 3].toString(),
                reportList[index + 4].toString(),
                reportList[index + 5]);
          }

          return SizedBox(width: 0, height: 0);
        });
  }
}

class TableInfo extends StatelessWidget {
  String rowName;
  String rowInfo;

  TableInfo(this.rowName, this.rowInfo);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(0),
          child: Table(
            defaultColumnWidth: FixedColumnWidth((screenWidth * (1 / 5)) - 10),
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  ColoredBox(
                    color: Colors.grey[350],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(rowName,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(rowInfo, textAlign: TextAlign.center),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class TableInfoIssues extends StatelessWidget {
  String systemMode;
  String startTime;
  String endTime;
  String duration;
  String issue;
  Color issueColor;

  TableInfoIssues(this.systemMode, this.startTime, this.endTime, this.duration,
      this.issue, this.issueColor);

  String getHyperLink(String issue) {
    print(issue);
    if (issue.contains('Temperature decreasing on heating call')) {
      return 'https://support.ecobee.com/hc/en-us/articles/360015758752-My-furnace-won-t-turn-on-How-can-I-troubleshoot-';
    } else if (issue.contains('High Limit Switch Issue')) {
      return 'https://support.ecobee.com/hc/en-us/articles/115006261328-My-ecobee-thermostat-keeps-losing-power-and-displaying-a-calibrating-message-or-N-A-or-500F-Why-';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(0),
          child: Table(
            // defaultColumnWidth: FixedColumnWidth(screenWidth * 0.5 - 100),
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  Container(
                    color: issueColor,
                    child: Text('\n' + systemMode + '\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ColoredBox(
                    color: issueColor,
                    child: Text('\n' + startTime + '\n',
                        textAlign: TextAlign.center),
                  ),
                  ColoredBox(
                    color: issueColor,
                    child: Text('\n' + endTime + '\n',
                        textAlign: TextAlign.center),
                  ),
                  ColoredBox(
                    color: issueColor,
                    child: Text('\n' + duration + '\n',
                        textAlign: TextAlign.center),
                  ),
                  ColoredBox(
                      color: issueColor,
                      child: Link(
                        child: issue == 'Issue'
                            ? Text(
                                '\n' + issue + '\n',
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                '\n' + issue + '\n',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue[800]),
                              ),
                        url: (getHyperLink(issue)),
                      )),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
