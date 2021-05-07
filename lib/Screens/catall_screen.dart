import 'dart:typed_data';
import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/models/catall.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatAllTable extends StatefulWidget {
  const CatAllTable({Key key}) : super(key: key);

  @override
  _CatAllTableState createState() => _CatAllTableState();
}

class _CatAllTableState extends State<CatAllTable> {
  bool sort = false;
  List<CATALL> selectedCatAll;
  @override
  Widget build(BuildContext context) {
    CatProvider _catProvider = Provider.of<CatProvider>(context, listen: true);
    //--------------------------------------------------------------//
    SingleChildScrollView dataBody() {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            DataTable(
              sortAscending: sort,
              sortColumnIndex: 0,
              columns: [
                DataColumn(
                    label: Text("Num"),
                    numeric: false,
                    tooltip: "This is message number",
                    onSort: (columnIndex, ascending) {
                      /* setState(() {
                        sort = !sort;
                      }); */
                      /* onSortColum(columnIndex, ascending); */
                    }),
                DataColumn(
                  label: Text("CAT"),
                  numeric: false,
                  tooltip: "This is CAT",
                ),
                DataColumn(
                  label: Text("SAC"),
                  numeric: false,
                  tooltip: "This is SAC",
                ),
                DataColumn(
                  label: Text("SIC"),
                  numeric: false,
                  tooltip: "This is SIC",
                ),
                DataColumn(
                  label: Text("Target Identification"),
                  numeric: false,
                  tooltip: "This is Target Identification",
                ),
                DataColumn(
                  label: Text("Target Address"),
                  numeric: false,
                  tooltip: "This is Last Name",
                ),
                DataColumn(
                  label: Text("Time of Day"),
                  numeric: false,
                  tooltip: "This is Last Name",
                ),
                DataColumn(
                  label: Text("List Time of Day"),
                  numeric: false,
                  tooltip: "This is Last Name",
                ),
                DataColumn(
                  label: Text("Track Number"),
                  numeric: false,
                  tooltip: "This is Last Name",
                ),
                DataColumn(
                  label: Text("latitude WGS84"),
                  numeric: false,
                  tooltip: "This is Last Name",
                ),
                DataColumn(
                  label: Text("Longitude WGS84"),
                  numeric: false,
                  tooltip: "This is Last Name",
                ),
                DataColumn(
                  label: Text("Flight Level"),
                  numeric: false,
                  tooltip: "This is Last Name",
                ),
                DataColumn(
                  label: Text("Type"),
                  numeric: false,
                  tooltip: "This is Last Name",
                ),
                DataColumn(
                  label: Text("Detection Mode"),
                  numeric: false,
                  tooltip: "This is Last Name",
                ),
              ],
              rows: _catProvider.catAll
                  .map(
                    (catAll) => DataRow(
                        selected: false,
                        onSelectChanged: (b) {
                          print("Onselect");
                          /* onSelectedRow(b, user); */
                        },
                        cells: [
                          DataCell(
                            Text(catAll.num.toString() ?? "None"),
                          ),
                          DataCell(
                            Text(catAll.CAT ?? "None"),
                          ),
                          DataCell(
                            Text(catAll.SAC ?? "None"),
                          ),
                          DataCell(
                            Text(catAll.SIC ?? "None"),
                          ),
                          DataCell(
                            Text(catAll.Target_Identification ?? "None"),
                          ),
                          DataCell(
                            Text(catAll.Target_Address ?? "None"),
                          ),
                          DataCell(
                            Text(catAll.Time_Of_day.toString() ?? "None"),
                          ),
                          DataCell(
                            Text(catAll.List_Time_Of_Day.toString() ?? "None"),
                          ),
                          DataCell(
                            Text(catAll.Track_number ?? "None"),
                          ),
                          DataCell(
                            Text(
                                catAll.Latitude_in_WGS_84.toString() ?? "None"),
                          ),
                          DataCell(
                            Text(catAll.Longitude_in_WGS_84.toString() ??
                                "None"),
                          ),
                          DataCell(
                            Text(catAll.Flight_level ?? "None"),
                          ),
                          DataCell(
                            Text(catAll.type ?? "None"),
                          ),
                          DataCell(
                            Text(catAll.DetectionMode ?? "None"),
                          ),
                        ]),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    }

    //--------------------Future TO------------------------------//
    /// [_fetchPreferences] We fetch the preference from the storage and notify in future
    Future<List<CATALL>> _fetchCATALL() async {
      print("Fetch Cat All");
      return _catProvider.catAll;
    }

    //------------------------------------------------------------//
    final getFutureBuildWidget = FutureBuilder<List<CATALL>>(
      future: _fetchCATALL(),
      builder: (context, snapshot1) {
        switch (snapshot1.connectionState) {
          case ConnectionState.none:

            /// Show [ErrorScreen], as we are unable to get the response...
            return Text("Cannot Connect to Server...");
          case ConnectionState.waiting:

            /// Show [LoadingScreen], as we are waiting for the response...
            return Text("Loading...");
          default:
            if (snapshot1.hasError) {
              /// Show [ErrorScreen], as we got a error
              return Text(
                snapshot1.error.toString(),
              );
            } else {
              //Error in Autologgin --> Login probably -1
              /// Redirect to [Login]
              return dataBody();
            }
        }
      },
    );

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Expanded(
            child: getFutureBuildWidget,
          ),
        ],
      ),
    );
  }
}
