import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/Screens/loading.dart';
import 'package:decereix/Screens/show_map_leaflet.dart';
import 'package:decereix/models/trajectories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static double sizeImage = 10; int initialTime = 86400;
  List<List<Marker>> markerStack = [];

  static List<List<Marker>> computePoints(List<Trajectories> SMRTrajectories, List<Trajectories> MLATTrajectories,
      List<Trajectories> ADSBTrajectories, int initialTime, int endTime) {
    List<List<Marker>> markersStack = [];
    List<Marker> markers = [];
    String hoverText = "";
    for (int currTime = initialTime; currTime < (endTime + 1); currTime++) {
      SMRTrajectories.forEach((element) {
        // List Time pick the latest
        int k = element.ListTime.lastIndexWhere(
                (element) => ((element < (currTime + 1))&& (element > (currTime -1))));
        if (k != -1) {
          if (element.type == 2) {
            hoverText = element.Target_Identification ?? element.Target_Address;
            markers.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Transform.rotate(
                angle: element.ListAngles[k],
                child: Icon(
                  Icons.airplanemode_active,
                  color: Colors.pinkAccent,
                  size: sizeImage*2,
                  semanticLabel: hoverText, //For Accessibility
                ),
              ),
            ));
          } else if (element.type == 1) {
            hoverText = element.Target_Identification ?? element.Target_Address;
            markers.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Transform.rotate(
                angle: element.ListAngles[k],
                child: Icon(
                  Icons.local_car_wash_rounded,
                  color: Colors.redAccent,
                  size: sizeImage,
                  semanticLabel: hoverText, //For Accessibility
                ),
              ),
            ));
          } else {
            hoverText = element.Target_Identification ?? element.Target_Address;
            markers.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Transform.rotate(
                angle: element.ListAngles[k],
                child: Icon(
                  Icons.grade,
                  color: Colors.blueAccent,
                  size: sizeImage,
                  semanticLabel: hoverText, //For Accessibility
                ),
              ),
            ));
          }
        }
      });
      MLATTrajectories.forEach((element) {
        // List Time pick the latest
        int k = element.ListTime.lastIndexWhere(
                (element) => ((element < (currTime + 1))&& (element > (currTime -1))));
        if (k != -1) {
          if (element.type == 2) {
            hoverText = element.Target_Identification ?? element.Target_Address;
            markers.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Transform.rotate(
                angle: element.ListAngles[k],
                child: Icon(
                  Icons.airplanemode_active,
                  color: Colors.pinkAccent,
                  size: sizeImage*2,
                  semanticLabel: hoverText, //For Accessibility
                ),
              ),
            ));
          } else if (element.type == 1) {
            hoverText = element.Target_Identification ?? element.Target_Address;
            markers.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Transform.rotate(
                angle: element.ListAngles[k],
                child: Icon(
                  Icons.local_car_wash_rounded,
                  color: Colors.redAccent,
                  size: sizeImage,
                  semanticLabel: hoverText, //For Accessibility
                ),
              ),
            ));
          } else {
            hoverText = element.Target_Identification ?? element.Target_Address;
            markers.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Transform.rotate(
                angle: element.ListAngles[k],
                child: Icon(
                  Icons.grade,
                  color: Colors.blueAccent,
                  size: sizeImage,
                  semanticLabel: hoverText, //For Accessibility
                ),
              ),
            ));
          }
        }
      });
      ADSBTrajectories.forEach((element) {
        // List Time pick the latest
        int k = element.ListTime.lastIndexWhere(
                (element) => ((element < (currTime + 1))&& (element > (currTime -1))));
        if (k != -1) {
          if (element.type == 2) {
            hoverText = element.Target_Identification ?? element.Target_Address;
            markers.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Transform.rotate(
                angle: element.ListAngles[k],
                child: Icon(
                  Icons.airplanemode_active,
                  color: Colors.pinkAccent,
                  size: sizeImage*2,
                  semanticLabel: hoverText, //For Accessibility
                ),
              ),
            ));
          } else if (element.type == 1) {
            hoverText = element.Target_Identification ?? element.Target_Address;
            markers.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Transform.rotate(
                angle: element.ListAngles[k],
                child: Icon(
                  Icons.local_car_wash_rounded,
                  color: Colors.redAccent,
                  size: sizeImage,
                  semanticLabel: hoverText, //For Accessibility
                ),
              ),
            ));
          } else {
            hoverText = element.Target_Identification ?? element.Target_Address;
            markers.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Transform.rotate(
                angle: element.ListAngles[k],
                child: Icon(
                  Icons.grade,
                  color: Colors.blueAccent,
                  size: sizeImage,
                  semanticLabel: hoverText, //For Accessibility
                ),
              ),
            ));
          }
        }
      });
      markersStack.add(markers);
      markers=[];
    }
    return markersStack;
  }


  @override
  Widget build(BuildContext context) {
    CatProvider _catProvider = Provider.of<CatProvider>(context, listen: true);

    /// [_fetchPreferences] We fetch the preference from the storage and notify in future
    Future< bool> _fetchMarkers() async {
      try{
        if(!_catProvider.hasMarkers){
        // Time
        initialTime = _catProvider.firstTime; //Units seconds[s]
        this.markerStack =  computePoints(_catProvider.smrTrajectories,_catProvider.mlatTrajectories,_catProvider.adsbTrajectories, initialTime, _catProvider.endTime);
        _catProvider.markers = this.markerStack;
        _catProvider.hasMarkers = true;
        debugPrint("Fetch Cat All");
        }
        else{
          this.markerStack = _catProvider.markers;
        }
        return true;
      }
      catch(e){
        return false;
      }
    }
    //--------------------List of Trajectories--------------------------//
    final getFutureBuildWidget = FutureBuilder<bool>(
      future: _fetchMarkers(),
      builder: (context, snapshot1) {
        switch (snapshot1.connectionState) {
          case ConnectionState.none:

            /// Show [ErrorScreen], as we are unable to get the response...
            return Text("Cannot Retrieve Trajectories...");
          case ConnectionState.waiting:

            /// Show [LoadingScreen], as we are waiting for the response...
            return LoadingPage();
          default:
            if (snapshot1.hasError) {
              /// Show [ErrorScreen], as we got a error
              return Text(
                snapshot1.error.toString(),
              );
            } else {
              /// Show [Map] with trajectories for current time
              if(snapshot1.data){
                return ShowMapLeaflet( markerStack: this.markerStack, lengthMarkerStack: this.markerStack.length,);
              }else{
                return Container(
                  child: Text("Error: Could not load trajectory!"),
                );
              }
            }
        }
      },
    );

    return getFutureBuildWidget;
  }
}
