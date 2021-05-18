import 'dart:typed_data';
import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/models/cat21.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class Cat21Table extends StatefulWidget {
  const Cat21Table({Key key}) : super(key: key);

  @override
  _Cat21TableState createState() => _Cat21TableState();
}

class _Cat21TableState extends State<Cat21Table> {
  bool sort = false;
  List<CAT21> selectedCat10 = [];
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
        title: 'Heading',
        field: 'text_field4b',
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
        field: 'text_field6a',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Target Report Descriptor Ext2',
        field: 'text_field6b',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Target Report Descriptor Ext3',
        field: 'text_field6c',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Track Number',
        field: 'text_field7',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Service Identification',
        field: 'text_field8',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'TimeofApplicability_Position',
        field: 'text_field9',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'LatitudeWGS_84',
        field: 'text_field10',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'LongitudeWGS_84',
        field: 'text_field11',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'LatitudeWGS_84 map',
        field: 'text_field11a',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'LongitudeWGS_84 map',
        field: 'text_field11b',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'High_Resolution_LatitudeWGS_84',
        field: 'text_field12',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'High_Resolution_LongitudeWGS_84',
        field: 'text_field13',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Time_of_Applicability_Velocity',
        field: 'text_field14',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'True_Air_Speed',
        field: 'text_field15',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Air_Speed',
        field: 'text_field16',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Target_address',
        field: 'text_field17',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Time_of_Message_Reception_Position',
        field: 'text_field18',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Time_of_Message_Reception_Position_High_Precision',
        field: 'text_field19',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Time_of_Message_Reception_Velocity',
        field: 'text_field20',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Time_of_Message_Reception_Velocity_High_Precision',
        field: 'text_field21',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Geometric_Height',
        field: 'text_field22',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Quality_Indicators',
        field: 'text_field23',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Quality_Indicators Extensions',
        field: 'text_field24',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'MOPS Version',
        field: 'text_field25',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'ModeA3',
        field: 'text_field26',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Roll_Angle',
        field: 'text_field27',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Flight_Level',
        field: 'text_field28',
        type: PlutoColumnType.text(),
      ),
      /// Text Column definition
      PlutoColumn(
        title: 'TrueAirspeed',
        field: 'text_field29',
        type: PlutoColumnType.text(),
      ),
      /// Text Column definition
      PlutoColumn(
        title: 'Magnetic_Heading',
        field: 'text_field30',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Target Status',
        field: 'text_field31',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Barometric_Vertical_Rate',
        field: 'text_field32',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Geometric_Vertical_Rate',
        field: 'text_field33',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Airborne Ground Vector',
        field: 'text_field34',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Track_Angle_Rate',
        field: 'text_field35',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Time_of_Asterix_Report_Transmission',
        field: 'text_field36',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'TimeOfDayInSeconds',
        field: 'text_field37',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Target_Identification',
        field: 'text_field38',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'ECAT',
        field: 'text_field39',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'MET_present',
        field: 'text_field40',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Selected Altitude',
        field: 'text_field41',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'State Selected Altitude',
        field: 'text_field42',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'TRAJECTORY INTENT',
        field: 'text_field43',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Service Management',
        field: 'text_field44',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Aircraft Operational Status',
        field: 'text_field45',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Surface Capabilities and Characteristics',
        field: 'text_field46',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Message Amplitude',
        field: 'text_field47',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Mode S MB Data',
        field: 'text_field48',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'ACAS Resolution Advisory Report',
        field: 'text_field49',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'RECEIVER ID',
        field: 'text_field50',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Data Ages',
        field: 'text_field51',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Data Ages Extension 1',
        field: 'text_field52',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Data Ages Extension 2',
        field: 'text_field53',
        type: PlutoColumnType.text(),
      ),

      /// Text Column definition
      PlutoColumn(
        title: 'Data Ages Extension 3',
        field: 'text_field54',
        type: PlutoColumnType.text(),
      )
    ];

    List<PlutoRow> rows = _catProvider.cat21All
        .map(
          (cat21) => PlutoRow(
            cells: {
              'num0': PlutoCell(value: cat21.Id ?? -1),
              'text_field1': PlutoCell(value: "21" ?? "None"),
              'text_field2': PlutoCell(value: cat21.SAC ?? "None"),
              'text_field3': PlutoCell(value: cat21.SIC ?? "None"),
              'text_field4': PlutoCell(value: cat21.TAR ?? "None"),
              'text_field4b': PlutoCell(value: cat21.heading ?? "None"),
              'text_field5': PlutoCell(value: cat21.messageType ?? "None"),
              'text_field6a': PlutoCell(
                  value: cat21.ATP != null
                      ? "ATP:${cat21.ATP}:ARC:${cat21.ARC}:RC:${cat21.RC}:RAB:${cat21.RAB}"
                      : "None"),
              'text_field6b': PlutoCell(
                  value: cat21.DCR != null
                      ? "DCR:${cat21.DCR}:DCR:${cat21.DCR}:GBS:${cat21.GBS}:SIM:${cat21.SIM}:TST:${cat21.TST}:SAA:${cat21.SAA}:CL:${cat21.CL}"
                      : "None"),
              'text_field6c': PlutoCell(
                  value: cat21.IPC != null
                      ? "IPC:${cat21.IPC}:NOGO:${cat21.NOGO}:CPR:${cat21.CPR}:LDPJ:${cat21.LDPJ}:RCF:${cat21.RCF}:FX:${cat21.FX}"
                      : "None"),
              'text_field7': PlutoCell(value: cat21.Track_Number ?? "None"),
              'text_field8':
                  PlutoCell(value: cat21.Service_Identification ?? "None"),
              'text_field9': PlutoCell(
                  value: cat21.Time_of_Applicability_Position ?? "None"),
              'text_field10': PlutoCell(value: cat21.LatitudeWGS_84 ?? "None"),
              'text_field11': PlutoCell(value: cat21.LongitudeWGS_84 ?? "None"),
              'text_field11a':
                  PlutoCell(value: cat21.LatitudeWGS_84_map ?? "None"),
              'text_field11b':
                  PlutoCell(value: cat21.LongitudeWGS_84_map ?? "None"),
              'text_field12': PlutoCell(
                  value: cat21.High_Resolution_LatitudeWGS_84 ?? "None"),
              'text_field13': PlutoCell(
                  value: cat21.High_Resolution_LongitudeWGS_84 ?? "None"),
              'text_field14': PlutoCell(
                  value: cat21.Time_of_Applicability_Velocity ?? "None"),
              'text_field15': PlutoCell(value: cat21.True_Air_Speed ?? "None"),
              'text_field16': PlutoCell(value: cat21.Air_Speed ?? "None"),
              'text_field17': PlutoCell(value: cat21.Target_address ?? "None"),
              'text_field18': PlutoCell(
                  value: cat21.Time_of_Message_Reception_Position ?? "None"),
              'text_field19': PlutoCell(
                  value:
                      cat21.Time_of_Message_Reception_Position_High_Precision ??
                          "None"),
              'text_field20': PlutoCell(
                  value: cat21.Time_of_Message_Reception_Velocity ?? "None"),
              'text_field21': PlutoCell(
                  value:
                      cat21.Time_of_Message_Reception_Velocity_High_Precision ??
                          "None"),
              'text_field22':
                  PlutoCell(value: cat21.Geometric_Height ?? "None"),
              'text_field23':
                  PlutoCell(value: cat21.Quality_Indicators ?? "None"),
              /// --- - -- - - - - - - - - -- - - - --  - -- - - - -- - ///
              // TODO: Fixme Quality_Indicators Extensions
              'text_field24':
              PlutoCell(value: cat21.Quality_Indicators ?? "None"),
              /// - - - - - - - - -- - - - - - - -- - - - - - -- - ///
              'text_field25': PlutoCell(
                  value: cat21.VNS != null
                      ? "VNS:${cat21.VNS}:MOPS:${cat21.MOPS}"
                      : "None"),
              'text_field26': PlutoCell(value: cat21.ModeA3 ?? "None"),
              'text_field27': PlutoCell(value: cat21.Roll_Angle ?? "None"),
              'text_field28': PlutoCell(value: cat21.Flight_Level ?? "None"),
              'text_field29': PlutoCell(value: cat21.True_Air_Speed ?? "None"),
              'text_field30':
                  PlutoCell(value: cat21.Magnetic_Heading ?? "None"),
              // Target Status
              'text_field31': PlutoCell(
                  value: cat21.ICF != null
                      ? "ICF:${cat21.ICF}:LNAV:${cat21.LNAV}:PS:${cat21.PS}:SS:${cat21.SS}"
                      : "None"),
              'text_field32':
                  PlutoCell(value: cat21.Barometric_Vertical_Rate ?? "None"),
              'text_field33':
                  PlutoCell(value: cat21.Geometric_Vertical_Rate ?? "None"),
              //Airborne Ground Vector
              'text_field34': PlutoCell(
                  value: cat21.Ground_Speed != null
                      ? "Ground_Speed:${cat21.Ground_Speed}:Track_Angle:${cat21.Track_Angle}:Ground_vector:${cat21.Ground_vector}"
                      : "None"),
              'text_field35':
                  PlutoCell(value: cat21.Track_Angle_Rate ?? "None"),
              'text_field36': PlutoCell(
                  value: cat21.Time_of_Asterix_Report_Transmission ?? "None"),
              'text_field37':
                  PlutoCell(value: cat21.TimeOfDayInSeconds ?? "None"),
              'text_field38':
                  PlutoCell(value: cat21.Target_Identification ?? "None"),
              'text_field39': PlutoCell(value: cat21.ECAT ?? "None"),
              'text_field40': PlutoCell(
                  value: cat21.MET_present != 0
                      ? "Wind_Speed:${cat21.Wind_Speed}:Wind_Direction:${cat21.Wind_Direction}:Temperature:${cat21.Temperature}:Turbulence:${cat21.Turbulence}"
                      : "None"),
              'text_field41': PlutoCell(
                  value: cat21.Source != null
                      ? "Source:${cat21.Source}:Selected_Altitude:${cat21.Selected_Altitude}"
                      : "None"),
              'text_field42':
                  PlutoCell(value: cat21.Final_State_Altitude ?? "None"),
              // TRAJECTORY INTENT
              'text_field43': PlutoCell(
                  value: cat21.NAV != null
                      ? "NAV:${cat21.NAV}:NVB:${cat21.NVB}"
                      : "None"),
              //Service Management
              'text_field44': PlutoCell(value: cat21.RP ?? "None"),
              //Aircraft Operational Status
              'text_field45': PlutoCell(
                  value: cat21.RA != null
                      ? "RA:${cat21.RA}:TC:${cat21.TC}:TS:${cat21.TS}:ARV:${cat21.ARV}:CDTIA:${cat21.CDTIA}:Not_TCAS:${cat21.Not_TCAS}:SA:${cat21.SA}"
                      : "None"),
              //Surface Capabilities and Characteristics
              'text_field46': PlutoCell(
                  value: cat21.POA != null
                      ? "POA:${cat21.POA}:CDTIS:${cat21.CDTIS}:B2_low:${cat21.B2_low}:RAS:${cat21.RAS}:IDENT:${cat21.IDENT}:LengthandWidth:${cat21.LengthandWidth}"
                      : "None"),
              'text_field47':
                  PlutoCell(value: cat21.Message_Amplitude ?? "None"),
              'text_field48': PlutoCell(
                  value: cat21.MB_Data != null
                      ? "MBData:${cat21.MB_Data.join("-")}:BDS1:${cat21.BDS1.join("-")}:BDS2:${cat21.BDS2.join("-")}:modeSrep:${cat21.modeS_rep ?? -1}"
                      : "None"),
              'text_field49': PlutoCell(
                  value: cat21.TYP != null
                      ? "TYP:${cat21.TYP}:STYP:${cat21.STYP}:ARA:${cat21.ARA}:RAC:${cat21.RAC}:RAT:${cat21.RAT}:MTE:${cat21.MTE}:TTI:${cat21.TTI}:TID:${cat21.TID}"
                      : "None"),
              'text_field50': PlutoCell(value: cat21.Receiver_ID ?? "None"),
              'text_field51': PlutoCell(
                  value: cat21.Data_Ages_present != 0
                      ? "AOS:${cat21.AOS}:TRD:${cat21.TRD}:M3A:${cat21.M3A}:QI:${cat21.QI}:TI:${cat21.TI}:MAM:${cat21.MAM}:GH:${cat21.GH}"
                      : "None"),
              'text_field52': PlutoCell(
                  value: cat21.FL != null
                      ? "FL:${cat21.AOS}:TRD:${cat21.TRD}:M3A:${cat21.M3A}:QI:${cat21.QI}:TI:${cat21.TI}:MAM:${cat21.MAM}:GH:${cat21.GH}"
                      : "None"),
              'text_field53': PlutoCell(
                  value: cat21.Data_Ages_present != 0
                      ? "AOS:${cat21.AOS}:TRD:${cat21.TRD}:M3A:${cat21.M3A}:QI:${cat21.QI}:TI:${cat21.TI}:MAM:${cat21.MAM}:GH:${cat21.GH}"
                      : "None"),
              'text_field54': PlutoCell(
                  value: cat21.Data_Ages_present != 0
                      ? "AOS:${cat21.AOS}:TRD:${cat21.TRD}:M3A:${cat21.M3A}:QI:${cat21.QI}:TI:${cat21.TI}:MAM:${cat21.MAM}:GH:${cat21.GH}"
                      : "None"),
            },
          ),
        )
        .toList();

    //--------------------Future TO------------------------------//
    /// [_fetchPreferences] We fetch the preference from the storage and notify in future
    Future<List<CAT21>> _fetchCATALL() async {
      print("Fetch Cat All");
      return _catProvider.cat21All;
    }

    //------------------------------------------------------------//
    final getFutureBuildWidget = FutureBuilder<List<CAT21>>(
      future: _fetchCATALL(),
      builder: (context, snapshot1) {
        switch (snapshot1.connectionState) {
          case ConnectionState.none:

            /// Show [ErrorScreen], as we are unable to get the response...
            return Text("Cannot Connect to Server...");
          case ConnectionState.waiting:

            /// Show [LoadingScreen], as we are waiting for the response...
            return Center(child: Text("Loading..."));
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
                  rows: rows);
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
