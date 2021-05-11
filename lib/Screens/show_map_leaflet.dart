import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
const double pi = 3.1415;
class ShowMapLeaflet extends StatefulWidget {
  final List<List<Marker>> markerStack;
  final int lengthMarkerStack;
  const ShowMapLeaflet({Key key,@required this.markerStack,@required this.lengthMarkerStack}) : super(key: key);

  @override
  _ShowMapLeafletState createState() => _ShowMapLeafletState();
}

class _ShowMapLeafletState extends State<ShowMapLeaflet> {
  static LatLng location = new LatLng(41.29561833, 2.095114167);
  int index = 0; bool isPlaying=false;
  int initialTime = 86400;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Floating Action Panel
    List<Widget> children = [];
    children.add(
      FloatingActionRowButton(
        icon: Icon(Icons.arrow_back_rounded),
        onTap: () {
          // All the trajectories must be reloaded for all of the plane for current Time
          setState(() {
            this.index = (this.index-1)>0 ? this.index-- : 0;
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
          setState(() {
            this.index = (this.index)<=widget.lengthMarkerStack ? this.index++ : this.index;
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
        child: SizedBox.expand(child: Listener(
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              // do something when scrolled
              print('Scrolled');
            }
          },
          child: FlutterMap(
            options: new MapOptions(
              center: location,
              zoom: 12.0,
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
                markers: widget.markerStack[this.index],
              ),
            ],
          ),),
    ),),);

  }
}
