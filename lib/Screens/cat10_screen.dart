import 'dart:typed_data';
import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/models/cat10.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class Cat10Table extends StatefulWidget {
  const Cat10Table({Key key}) : super(key: key);

  @override
  _Cat10TableState createState() => _Cat10TableState();
}

class _Cat10TableState extends State<Cat10Table> {
  bool sort = false;
  List<CAT10> selectedCat10;
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
        title: 'TAR',
        field: 'text_field4',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'MessageType',
        field: 'text_field5',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Target Report Descriptor',
        field: 'text_field6',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'TargetReportDescriptor First extension',
        field: 'text_field6a',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'TargetReportDescriptor Second extension',
        field: 'text_field6b',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'TimeOfDay',
        field: 'text_field7',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'TimeOfDayInSeconds',
        field: 'text_field8',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'latitude WGS84',
        field: 'text_field9a',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'longitude WGS84',
        field: 'text_field9b',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Position Polar',
        field: 'text_field10',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Pos Cartesian',
        field: 'text_field11',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Track Velocity',
        field: 'text_field12',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Velocity Cartesian',
        field: 'text_field13',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'TrackNumber',
        field: 'text_field15',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Track Status',
        field: 'text_field16a',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Track Status',
        field: 'text_field16b',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Track Status GHO',
        field: 'text_field16c',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Mode3/A',
        field: 'text_field17',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'TargetAddress',
        field: 'text_field18',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Target Identification',
        field: 'text_field18b',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'MODE S MB DATA',
        field: 'text_field19',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Fleet Identification',
        field: 'text_field20a',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'FLIGHT LEVEL',
        field: 'text_field20b',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'MeasuredHeight',
        field: 'text_field21',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'TARGET SIZE & ORIENTATION',
        field: 'text_field22',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'SYSTEM STATUS',
        field: 'text_field22b',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'PRE-PROGRAMMED MESSAGE',
        field: 'text_field23',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'STANDARD DEVIATION',
        field: 'text_field24',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'PRESENCE',
        field: 'text_field25',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'AMPLITUDE OF PRIMARY PLOT',
        field: 'text_field26',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'CALCULATED ACCELERATION',
        field: 'text_field27',
        type: PlutoColumnType.text(),
      ),
    ];

    List<PlutoRow> rows = _catProvider.cat10All
        .map(
          (cat10) => PlutoRow(
            cells: {
              'num0': PlutoCell(value: cat10.Id ?? -1),
              'text_field1': PlutoCell(value: "10" ?? "None"),
              'text_field2': PlutoCell(value: cat10.SAC ?? "None"),
              'text_field3': PlutoCell(value: cat10.SIC ?? "None"),
              'text_field4': PlutoCell(value: cat10.TAR ?? "None"),
              'text_field5': PlutoCell(value: cat10.messageType ?? "None"),
              'text_field6': PlutoCell(
                  value: cat10.TYP != null
                      ? "TYP:${cat10.TYP}:DCR:${cat10.DCR}:CHN:${cat10.CHN}:BS:${cat10.GBS}:CRT${cat10.CRT}"
                      : "None"),
              'text_field6a': PlutoCell(
                  value: cat10.CNF != null
                      ? "SIM:${cat10.SIM}:TST:${cat10.TST}:RAB:${cat10.RAB}:LOP:${cat10.LOP}:TOT:${cat10.TOT}"
                      : "None"),
              'text_field6b': PlutoCell(value: cat10.SPI ?? "None"),
              'text_field7': PlutoCell(value: cat10.TimeOfDay ?? "None"),
              'text_field8':
                  PlutoCell(value: cat10.TimeOfDayInSeconds ?? "None"),
              'text_field9a': PlutoCell(value: cat10.LatitudeWGS_84 ?? "None"),
              'text_field9b': PlutoCell(value: cat10.LongitudeWGS_84 ?? "None"),
              'text_field10': PlutoCell(
                  value: cat10.RHO != null
                      ? "RHO:${cat10.RHO}-Theta:${cat10.THETA}"
                      : "None"),
              'text_field11': PlutoCell(
                  value: cat10.X_Component != null
                      ? "X:${cat10.X_Component}-Y:${cat10.Y_Component}"
                      : "None"),
              'text_field12': PlutoCell(
                  value: cat10.GroundSpeed != null
                      ? "GroundSpeed:${cat10.GroundSpeed}-TrackAngle:${cat10.TrackAngle}"
                      : "None"),
              'text_field13': PlutoCell(
                  value: cat10.Vx != null
                      ? "Vx:${cat10.Vx}-Vy:${cat10.Vy}"
                      : "None"),
              'text_field15': PlutoCell(value: cat10.TrackNumber ?? "None"),
              'text_field16a': PlutoCell(
                  value: cat10.CNF != null
                      ? "CNF:${cat10.CNF}:TRE:${cat10.TRE}:CST:${cat10.CST}:MAH:${cat10.MAH}:TCC${cat10.TCC}:STH${cat10.STH}"
                      : "None"),
              'text_field16b': PlutoCell(
                  value: cat10.TOM != null
                      ? "TOM:${cat10.TOM}:DOU:${cat10.DOU}:MRS:${cat10.MRS}"
                      : "None"),
              'text_field16c': PlutoCell(value: cat10.GHO ?? "None"),
              'text_field17': PlutoCell(
                  value: cat10.VMode3A != null
                      ? "VMode3A:${cat10.VMode3A}:GMode3A:${cat10.GMode3A}:LMode3A:${cat10.LMode3A}:Mode3A:${cat10.Mode3A}"
                      : "None"),
              'text_field18': PlutoCell(value: cat10.TargetAddress ?? "None"),
              'text_field18b': PlutoCell(value: cat10.STI ?? "None"),
              'text_field19': PlutoCell(
                  value: cat10.MBData != null
                      ? "MBData:${cat10.MBData.join("-")}:BDS1:${cat10.BDS1.join("-")}:BDS2:${cat10.BDS2.join("-")}:modeSrep:${cat10.modeSrep ?? -1}"
                      : "None"),
              'text_field20a': PlutoCell(value: cat10.VFI ?? "None"),
              'text_field20b': PlutoCell(
                  value: cat10.VFlightLevel != null
                      ? "VFlightLevel:${cat10.VFlightLevel}:GFlightLevel:${cat10.GFlightLevel}:FlightLevel:${cat10.FlightLevel}"
                      : "None"),
              'text_field21': PlutoCell(value: cat10.MeasuredHeight ?? "None"),
              'text_field22': PlutoCell(
                  value: cat10.LENGHT != null
                      ? "LENGHT:${cat10.LENGHT}:ORIENTATION:${cat10.ORIENTATION}:WIDTH:${cat10.WIDTH}"
                      : "None"),
              'text_field22b': PlutoCell(
                  value: cat10.NOGO != null
                      ? "NOGO:${cat10.NOGO}:OVL:${cat10.OVL}:TSV:${cat10.TSV}:DIV:${cat10.DIV}:TIF:${cat10.TIF}"
                      : "None"),
              'text_field23': PlutoCell(
                  value: cat10.TRB != null
                      ? "TRB:${cat10.TRB}:MSG:${cat10.MSG}"
                      : "None"),
              'text_field24': PlutoCell(
                  value: cat10.DeviationX != null
                      ? "DeviationX:${cat10.DeviationX}:DeviationY:${cat10.DeviationY}:CovarianceXY:${cat10.CovarianceXY}"
                      : "None"),
              'text_field25': PlutoCell(
                  value: cat10.DRHO != null
                      ? "DRHO:${cat10.DRHO}:DTHETA:${cat10.DTHETA}"
                      : "None"),
              'text_field26': PlutoCell(value: cat10.PAM ?? "None"),
              'text_field27': PlutoCell(
                  value: cat10.Ax != null
                      ? "Ax:${cat10.Ax}:Ay:${cat10.Ax}"
                      : "None"),
            },
          ),
        )
        .toList();

    //--------------------Future TO------------------------------//
    /// [_fetchPreferences] We fetch the preference from the storage and notify in future
    Future<List<CAT10>> _fetchCATALL() async {
      print("Fetch Cat All");
      return _catProvider.cat10All;
    }

    //------------------------------------------------------------//
    final getFutureBuildWidget = FutureBuilder<List<CAT10>>(
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
