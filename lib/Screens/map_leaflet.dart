import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapLeaflet extends StatefulWidget {
  final Function onLocationPicked;
  const MapLeaflet({Key key, @required this.onLocationPicked}) : super(key: key);

  @override
  _MapLeafletState createState() => _MapLeafletState();
}

class _MapLeafletState extends State<MapLeaflet> {
  /// [logger] to logg all of the logs in console prettily!
  List<LatLng> tappedPoints = [];

  @override
  Widget build(BuildContext context) {
    void showModal() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            Size size = MediaQuery.of(context).size;
            return Container(
              //constraints:
              //BoxConstraints.tightForFinite(width: size.width, height: size.height * 0.5),
              color: Color(0xff737373),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 4,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Container(
                          width: size.width * 0.30,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 1,
                      ),
                    ),
                    Flexible(
                      flex: 92,
                      child: Text(
                        "Long Press on the Map to select a Location for meeting.",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    var markers = tappedPoints.map((latlng) {
      return Marker(
        width: 60.0,
        height: 60.0,
        point: latlng,
        builder: (ctx) => Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 42.0,
          semanticLabel: 'Marker Placed on Map', //For Accessibility
        ),
      );
    }).toList();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: new FlutterMap(
                options: new MapOptions(
                  center: new LatLng(41.27533, 1.98723),
                  zoom: 17.0,
                  maxZoom: 18.0,
                  minZoom: 7.0,
                  onLongPress: _handleTap,
                ),
                layers: [
                  new TileLayerOptions(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
                  new MarkerLayerOptions(
                    markers: markers,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    title: Text("Search..."),
                    trailing: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      //Search Bar Map
                    }),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: showModal,
          tooltip: "Long Press on the Map to select a Location for meeting.",
          child: SizedBox.expand(child: Icon(Icons.help, size: 56, color: Colors.blue)),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      tappedPoints.add(latlng);
    });
  }
}
