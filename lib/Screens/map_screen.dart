import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/Screens/show_map_leaflet.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng locationBCN = new LatLng(41.29561833, 2.095114167);
  @override
  Widget build(BuildContext context) {
    CatProvider _catProvider = Provider.of<CatProvider>(context, listen: true);
    /// [_fetchPreferences] We fetch the preference from the storage and notify in future
    Future<List<LatLng>> _fetchCATALL() async {
      List<LatLng> points = [];
      _catProvider.mlatTrajectories.forEach((trayectory) {
        points.add(trayectory.ListPoints[0]);
      });
      debugPrint("Fetch Cat All");
      return points;
    }

    //------------------------------------------------------------//
    final getFutureBuildWidget = FutureBuilder<List<LatLng>>(
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
              return ShowMapLeaflet(location: this.locationBCN, pois: snapshot1.data,

              );
            }
        }
      },
    );

    return getFutureBuildWidget;
  }
}
