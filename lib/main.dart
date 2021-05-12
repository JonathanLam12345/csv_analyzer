import 'dart:typed_data';

import 'package:ecobee_csv_analyzer/data_provider.dart';
import 'package:ecobee_csv_analyzer/widgets/troubleshoot_output.dart';
import 'package:ecobee_csv_analyzer/troubleshooting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:csv_reader/csv_reader.dart';
import 'package:csv/csv.dart';
import 'package:provider/provider.dart';

import 'csvReader.dart';

// https://pub.dev/packages/csv

void main() {
  return runApp(MyApp());
}

var screenWidth;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DataProvider>(
      create: (context) {
        return DataProvider();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ecobee Thermostat Report Analyzer',
        home: MyApp2(),
      ),
    );
  }
}

class MyApp2 extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

Widget futureBuilder;
bool resultToggle = false;

class _MyAppState extends State<MyApp2> {
  DropzoneViewController controller1;
  String message1 = 'Drop csv File Here';

  Widget report;
  bool highlighted1 = false;
  double width;

  void resultToggleView() {
    setState(() {
      resultToggle = !resultToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ecobee Thermostat Report Analyzer'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/images/ecobee_logo.png',
            height: 100,
            width: 500,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 80,
              width: screenWidth - 60,
              color: highlighted1 ? Colors.blueAccent : Colors.grey,
              child: Stack(
                children: [
                  buildZone1(context),
                  Center(child: Text(message1)),
                ],
              ),
            ),
          ),
          Expanded(child: resultToggle ? futureBuilder : Text(""))
        ],
      ),
    );
  }

  Widget buildZone1(BuildContext context) => Builder(
        builder: (context) {
          return DropzoneView(
            operation: DragOperation.copy,
            cursor: CursorType.grab,
            onCreated: (ctrl) => controller1 = ctrl,
            onLoaded: () {
              return print('Zone 1 loaded');
            },
            onError: (ev) => print('Zone 1 error: $ev'),
            onHover: () {
              setState(() {
                if (resultToggle) {
                  resultToggleView();
                }
                highlighted1 = true;
              });

              //  print('Zone 1 hovered');
            },
            onLeave: () {
              setState(() => highlighted1 = false);
              //   print('Zone 1 left');
            },
            onDrop: (ev) async {
              var list = await controller1.getFileData(ev);

              Uint8List bytes = Uint8List.fromList(list);
              String string = String.fromCharCodes(bytes);

              //   print('Zone 1 drop: ${ev.name}');
              setState(() {
                message1 = '[ ${ev.name} ] dropped';
                highlighted1 = false;
                print(message1);
                List<List<dynamic>> rowsAsListOfValues =
                    const CsvToListConverter().convert(string);
                //print( rowsAsListOfValues);
                futureBuilder = new FutureBuilder(
                    future: Troubleshooting(rowsAsListOfValues.elementAt(0))
                        .findIssues(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Text('loading...');
                      }
                      if (snapshot.hasError) {
                        return new Text('Error: ${snapshot.error}');
                      } else {
                        return createListView(context, snapshot);
                      }
                    });

                resultToggleView();
              });
            },
          );
        },
      );
}

Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
  List<dynamic> values = snapshot.data;

  return AnalyzedReport(values);
}
