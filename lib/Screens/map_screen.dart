import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/Screens/show_map_leaflet.dart';
import 'package:decereix/models/trajectories.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:floating_action_row/floating_action_row.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static LatLng location = new LatLng(41.29561833, 2.095114167);
  bool isPlaying = false;
  int initialTime = 86400;
  int currTime = 86400;
  static double sizeImage = 10;
  // Trajectories
  List<Trajectories> SMRTrajectories = [];
  List<Trajectories> MLATTrajectories = [];
  List<Trajectories> ADSBTrajectories = [];
  // Marker Locations
  List<LatLng> pointsCars = [];
  List<LatLng> pointsPlanes = [];
  List<LatLng> pointsCircle = [];
  @override
  Widget build(BuildContext context) {
    CatProvider _catProvider = Provider.of<CatProvider>(context, listen: true);
    void computePoints(){
      SMRTrajectories.forEach((element) {
        // List Time pick the latest
        int k = element.ListTime.lastIndexWhere((element) => element<(currTime+1));
        if(k!=-1){
          if(element.type == 2){
            pointsPlanes.add(element.ListPoints[0]);
          }else if(element.type == 1){
            pointsCars.add(element.ListPoints[0]);
          }else{
            pointsCircle.add(element.ListPoints[0]);
          }
        }
      });
      MLATTrajectories.forEach((element) {
        // List Time pick the latest
        int k = element.ListTime.lastIndexWhere((element) => element<(currTime+1));
        if(k!=-1){
          if(element.type == 2){
            pointsPlanes.add(element.ListPoints[0]);
          }else if(element.type == 1){
            pointsCars.add(element.ListPoints[0]);
          }else{
            pointsCircle.add(element.ListPoints[0]);
          }
        }
      });
      MLATTrajectories.forEach((element) {
        // List Time pick the latest
        int k = element.ListTime.lastIndexWhere((element) => element<(currTime+1));
        if(k!=-1){
          if(element.type == 2){
            pointsPlanes.add(element.ListPoints[0]);
          }else if(element.type == 1){
            pointsCars.add(element.ListPoints[0]);
          }else{
            pointsCircle.add(element.ListPoints[0]);
          }
        }
      });
    }
    /// [_fetchPreferences] We fetch the preference from the storage and notify in future
    Future<List<LatLng>> _fetchCATALL() async {
      // Trajectories
      if(_catProvider.smrTrajectories!=null) {
        SMRTrajectories = _catProvider.smrTrajectories;
      }
      if(_catProvider.mlatTrajectories!=null) {
        MLATTrajectories = _catProvider.mlatTrajectories;
      }
      if(_catProvider.adsbTrajectories!=null) {
        ADSBTrajectories = _catProvider.adsbTrajectories;
      }
      // Time
      currTime = _catProvider.firstTime; //Units seconds[s]
      initialTime = currTime; //Units seconds[s]
      computePoints();
      debugPrint("Fetch Cat All");
      return pointsCircle;
    }
    // Create Stacked Queue List of Points[LatLng] Cars/Plane/Circle

    //------------------------MARKERS-----------------------------------//
    List<Marker> markers() {
      //print(widget.elements);
      List<Marker> returnMarkers = [];
      if (pointsPlanes.isNotEmpty) {
        pointsPlanes.forEach((val) => returnMarkers.add(
            new Marker(
              width: 10.0,
              height: 10.0,
              point: val,
              builder: (ctx) => Transform.rotate(
                angle: 0 * pi / 180,
                child: Icon(
                  Icons.airplanemode_active,
                  color: Colors.pinkAccent,
                  size: sizeImage,
                  semanticLabel: 'Marker Placed on Map', //For Accessibility
                ),
              ),
            )
        ));
      }
      if (pointsCars.isNotEmpty) {
        pointsCars.forEach((val) => returnMarkers.add(
            new Marker(
              width: 10.0,
              height: 10.0,
              point: val,
              builder: (ctx) => Transform.rotate(
                angle: 0 * pi / 180,
                child: Icon(
                  Icons.local_car_wash_rounded,
                  color: Colors.amber,
                  size: sizeImage,
                  semanticLabel: 'Marker Placed on Map', //For Accessibility
                ),
              ),
            )
        ));
      }
      if (pointsCircle.isNotEmpty) {
        pointsCircle.forEach((val) => returnMarkers.add(
            new Marker(
              width: 10.0,
              height: 10.0,
              point: val,
              builder: (ctx) => Transform.rotate(
                angle: 0 * pi / 180,
                child: Icon(
                  Icons.grade,
                  color: Colors.tealAccent,
                  size: sizeImage,
                  semanticLabel: 'Marker', //For Accessibility
                ),
              ),
            )
        ));
      }
      return returnMarkers;
    }
    //--------------------List of Trajectories--------------------------//
    final getFutureBuildWidget = FutureBuilder<List<LatLng>>(
      future: _fetchCATALL(),
      builder: (context, snapshot1) {
        switch (snapshot1.connectionState) {
          case ConnectionState.none:

            /// Show [ErrorScreen], as we are unable to get the response...
            return Text("Cannot Retrieve Trajectories...");
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
              /// Show [Map] with trajectories for current time
              return Listener(
                onPointerSignal: (pointerSignal) {
                  if (pointerSignal is PointerScrollEvent) {
                    // do something when scrolled
                    print('Scrolled');
                  }
                },
                child: FlutterMap(
                  options: new MapOptions(
                    center: location,
                    zoom: 15.0,
                    maxZoom: 18.0,
                    minZoom: 7.0,
                  ),
                  layers: [
                    new TileLayerOptions(
                        keepBuffer: 150,
                        urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                    new MarkerLayerOptions(
                      markers: markers(),
                    ),
                  ],
                ),);
            }
        }
      },
    );
    // Floating Action Panel
    List<Widget> children = [];
    children.add(
      FloatingActionRowButton(
        icon: Icon(Icons.arrow_back_rounded),
        onTap: () {
          // All the trajectories must be reloaded for all of the plane for current Time
            this.currTime--;
            computePoints();
            setState(() {
              pointsPlanes = pointsPlanes;
              pointsCars = pointsCars;
              pointsCircle = pointsCircle;

            });
        },
      ),
    );
    children.add(
      FloatingActionRowDivider(),
    );
    children.add(
      FloatingActionRowButton(
        icon: this.isPlaying ? Icon(Icons.play_arrow_rounded):Icon(Icons.pause_rounded),
        onTap: () {
          setState(() => this.isPlaying = !this.isPlaying);
        },
      ),
    );
    children.add(
      FloatingActionRowDivider(),
    );
    children.add(
      FloatingActionRowButton(
        icon: Icon(Icons.arrow_forward),
        onTap: () {
            this.currTime++;
            computePoints();
            setState(() {
              pointsPlanes = pointsPlanes;
              pointsCars = pointsCars;
              pointsCircle = pointsCircle;

            });
        },
      ),
    );
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionRow(
        children: children,
        color: Colors.blueAccent,
        elevation: 4,
      ),
      body: SafeArea(
        child: SizedBox.expand(child: Container(
            color: Colors.teal,
            child: getFutureBuildWidget)),
      ),
    );
  }
}
