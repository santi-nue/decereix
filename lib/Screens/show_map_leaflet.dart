import 'dart:async';

import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:weight_slider/weight_slider.dart';

import 'error_show.dart';

const double pi = 3.1415;

class ShowMapLeaflet extends StatefulWidget {
  final List<List<Marker>> markerStack;
  final int lengthMarkerStack;

  const ShowMapLeaflet({Key key, @required this.markerStack, @required this.lengthMarkerStack})
      : super(key: key);

  @override
  _ShowMapLeafletState createState() => _ShowMapLeafletState();
}

class _ShowMapLeafletState extends State<ShowMapLeaflet> {
  static LatLng location = new LatLng(41.29561833, 2.095114167);

  /// A [MapController], used to control the map.
  MapController _mapController = new MapController();
  Timer timer;
  bool isPlaying = false;
  int initialTime = 86400;
  static int repetitionDelay = 1000; // milliseconds [ms]
  int currentSpeed = 1;
  static double minZoom = 6.0;
  static double maxZoom = 18.0;
  static double zoomFactor = 0.5;

  /// [ValueNotifier] Value Notifier with Initial Values which only rebuilds the
  /// widgets it is used
  //ValueNotifier<List<String>> universityNames = ValueNotifier(["Select your University:"]);
  ValueNotifier<int> currIndex = ValueNotifier(0);

  void autoPlay() {
    if (currIndex.value < widget.lengthMarkerStack) {
      if (widget.lengthMarkerStack == 1) {
        if (widget.markerStack[0].length != 0) {
          setState(() {
            currIndex.value = currIndex.value + 1;
          });
        }
      } else {
        setState(() {
          currIndex.value = currIndex.value + 1;
        });
      }
    } else {
      if (timer != null) {
        if (timer.isActive) {
          timer.cancel();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Floating Action Panel
    List<Widget> mapControls = [];

    /// To Go 1 second backward in time
    mapControls.add(
      FloatingActionRowButton(
        icon: Icon(Icons.fast_rewind),
        onTap: () {
          // All the trajectories must be reloaded for all of the plane for current Time
          if (currIndex.value > 0 &&
              currIndex.value < widget.lengthMarkerStack) {
            setState(() {
              currIndex.value = currIndex.value - 1;
            });
          }
        },
      ),
    );
    mapControls.add(
      FloatingActionRowDivider(),
    );

    /// [Play/Pause] Button for Autoplaying the plane movements
    mapControls.add(
      FloatingActionRowButton(
        icon: this.isPlaying
            ? Icon(Icons.pause_rounded)
            : Icon(Icons.play_arrow_rounded),
        onTap: () {

          setState(() {
            this.isPlaying = !this.isPlaying;
          });
          if (this.isPlaying) {
            if (timer != null) {
              if (timer.isActive) {
                timer.cancel();
              }
            }
            timer = Timer.periodic(Duration(milliseconds: repetitionDelay),
                (Timer t) => autoPlay());
          } else {
            if (timer != null) {
              if (timer.isActive) {
                timer.cancel();
              }
            }
          }
        },
      ),
    );
    mapControls.add(
      FloatingActionRowDivider(),
    );

    /// To Go 1 second forward in Time
    mapControls.add(
      FloatingActionRowButton(
        icon: Icon(Icons.fast_forward),
        onTap: () {
          if (currIndex.value < widget.lengthMarkerStack) {
            if (widget.lengthMarkerStack == 1) {
              if (widget.markerStack[0].length != 0) {
                setState(() {
                  currIndex.value = currIndex.value + 1;
                });
              }
            } else {
              setState(() {
                currIndex.value = currIndex.value + 1;
              });
            }
          }
        },
      ),
    );

    /// Top Center Floating Panel
    List<Widget> floatingPanelSpeed = [];
    floatingPanelSpeed.add(
      SizedBox(
        width: 96,
        height: 96,
        child: WeightSlider(
          weight: this.currentSpeed,
          minWeight: 1,
          maxWeight: 10,
          onChange: (val) => setState(() {
            int timerVal = repetitionDelay ~/ val;
            if (timer != null) {
              if (timer.isActive) {
                timer.cancel();
                timer = Timer.periodic(
                    Duration(milliseconds: timerVal), (Timer t) => autoPlay());
                setState(() {
                  this.currentSpeed = val;
                });
              } else {
                timer = Timer.periodic(
                    Duration(milliseconds: timerVal), (Timer t) => autoPlay());
                setState(() {
                  this.currentSpeed = val;
                });
              }
            }
          }),
          unit: 'x', // optional
        ),
      ),
    );
    // Flutter Map -- Widget
    Widget flutterMapWidget = ValueListenableBuilder(
      builder: (BuildContext context, int _index, Widget child) {
        // This builder will only get called when the _counter
        // is updated.
        return FlutterMap(
          mapController: _mapController,
          options: new MapOptions(
            center: location,
            zoom: 12.0,
            maxZoom: maxZoom,
            minZoom: minZoom,
          ),
          layers: [
            new TileLayerOptions(
                keepBuffer: 150,
                urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            new MarkerLayerOptions(
              markers: widget.markerStack[_index],
            ),
          ],
        );
      },
      valueListenable: currIndex,
      child: ErrorShow(errorText: "Unexpected error occured, Please Restart the App"),
    );
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: FloatingActionRow(
        children: floatingPanelSpeed,
        color: Colors.blueAccent,
        elevation: 4,
      ),
      body: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionRow(
          children: mapControls,
          color: Colors.blueAccent,
          elevation: 4,
        ),
        body: SafeArea(
          child: SizedBox.expand(
            child: Listener(
                onPointerSignal: (pointerSignal) {
                  if (pointerSignal is PointerScrollEvent) {
                    LatLng latlng = _mapController.center ?? new LatLng(0, 0);

                    /// Scroll Direction Normalized * [Zoom factor] :: [Windows Zoom] precision factor
                    double deltaZoom = (pointerSignal.scrollDelta.direction /
                            (pointerSignal.scrollDelta.direction).abs()) *
                        zoomFactor;
                    double zoomNew = _mapController.zoom - deltaZoom;
                    zoomNew = zoomNew < minZoom ? minZoom : zoomNew;
                    zoomNew = zoomNew > maxZoom ? maxZoom : zoomNew;
                    _mapController.move(latlng, zoomNew);
                  }
                },
                child: flutterMapWidget),
          ),
        ),
      ),
    );
  }
}
