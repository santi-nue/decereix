import 'package:decereix/Screens/show_map_leaflet.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng locationBCN = new LatLng(41.29561833, 2.095114167);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ShowMapLeaflet(location: this.locationBCN,
      ),
    );
  }
}
