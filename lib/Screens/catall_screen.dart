import 'dart:typed_data';
import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/models/catall.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
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
    //------------------PLUTO---------------------------------------//
    List<PlutoColumn> columns = [
      /// Number Column definition
      PlutoColumn(
        title: 'Index',
        field: 'num0',
        type: PlutoColumnType.number(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'CAT',
        field: 'text_field1',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'SAC',
        field: 'text_field2',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'SIC',
        field: 'text_field3',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Target Identification',
        field: 'text_field4',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Target Address',
        field: 'text_field5',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Time of Day',
        field: 'text_field6',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'List Time of Day',
        field: 'text_field7',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Track Number',
        field: 'text_field8',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'latitude WGS84',
        field: 'text_field9',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Longitude WGS84',
        field: 'text_field10',
        type: PlutoColumnType.text(),
      ),
      /// Text Column definition
      PlutoColumn(
        title: 'latitude WGS84Map',
        field: 'text_field9b',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Longitude WGS84Map',
        field: 'text_field10b',
        type: PlutoColumnType.text(),
      ),
      /// Text Column definition
      PlutoColumn(
        title: 'Flight Level',
        field: 'text_field11',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Type',
        field: 'text_field12',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Detection Mode',
        field: 'text_field13',
        type: PlutoColumnType.text(),
      ),
    ];

    List<PlutoRow> rows = _catProvider.catAll
        .map(
          (catAll) => PlutoRow(
            cells: {
              'num0': PlutoCell(value: catAll.num ?? -1),
              'text_field1': PlutoCell(value: catAll.CAT ?? "None"),
              'text_field2': PlutoCell(value: catAll.SAC ?? "None"),
              'text_field3': PlutoCell(value: catAll.SIC ?? "None"),
              'text_field4':
                  PlutoCell(value: catAll.Target_Identification ?? "None"),
              'text_field5': PlutoCell(value: catAll.Target_Address ?? "None"),
              'text_field6': PlutoCell(value: catAll.Time_Of_day ?? "None"),
              'text_field7':
                  PlutoCell(value: catAll.List_Time_Of_Day ?? "None"),
              'text_field8': PlutoCell(value: catAll.Track_number ?? "None"),
              'text_field9':
                  PlutoCell(value: catAll.Latitude_in_WGS_84 ?? "None"),
              'text_field10':
                  PlutoCell(value: catAll.Longitude_in_WGS_84 ?? "None"),
              'text_field9b':
              PlutoCell(value: catAll.Latitude_in_WGS_84_map ?? "None"),
              'text_field10b':
              PlutoCell(value: catAll.Longitude_in_WGS_84_map ?? "None"),
              'text_field11': PlutoCell(value: catAll.Flight_level ?? "None"),
              'text_field12': PlutoCell(value: catAll.type ?? "None"),
              'text_field13': PlutoCell(value: catAll.DetectionMode ?? "None"),
            },
          ),
        )
        .toList();

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
              return PlutoGrid(
                  columns: columns,
                  rows: rows,
                  onChanged: (PlutoGridOnChangedEvent event) {
                    print(event);
                  },
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    print(event);
                  });
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
