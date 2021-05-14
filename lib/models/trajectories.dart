import 'package:extended_math/extended_math.dart';
import 'package:latlong/latlong.dart';
class Trajectories {
  String CAT;

  String SAC;

  String SIC;

  String Target_Identification;

  String Target_Address;

  String Track_number;

  // Type =[0=Point,1=Car,2=Plane]
  int type;

  String DetectionMode;
  List<double> ListAngles = [];
  List<LatLng> ListPoints = [];
  List<int> ListTime = [];

  Trajectories(
      String Callsign,
      int Time,
      double lat,
      double lon,
      double heading,
      String emitter,
      String TargetAddress,
      String DetectionMode,
      String CAT,
      String SAC,
      String SIC,
      String TrackNumber) {
    var p = [lat, lon];
    // Angle Plane
    /*if(ListPoints.isNotEmpty){*/
      this.ListAngles.add(heading);
    /*}else if(ListPoints.length==1){
      this.ListAngles[0] = x;
      this.ListAngles.add(x);
    }else{
      this.ListAngles.add(0);
    }*/

    this.ListPoints.add(new LatLng(lat,lon));
    this.ListTime.add(Time);
    /*this.ListTimePoints.add(pt);*/
    this.CAT = CAT;
    this.Target_Identification = Callsign;
    this.SAC = SAC;
    this.SIC = SIC;
    this.Target_Address = TargetAddress;
    if (emitter == "car") {
      this.type = 1;
    } else if (emitter == "plane") {
      this.type = 2;
    } else {
      this.type = 0;
    }
    this.DetectionMode = DetectionMode;
    this.Track_number = TrackNumber;
  }
  void AddPoint(double lat,double lon,double heading,int time)
  {
    this.ListAngles.add(heading);
    this.ListPoints.add(new LatLng(lat,lon));
    this.ListTime.add(time);
    // Angle Plane

  }
}
