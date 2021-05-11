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

  double computeAngle(var ini, LatLng fin)
  {
    /*// Initial[lat,long] and Final[lat,long]
    double H = sqrt((fin[0] - ini[0]) * (fin[0] - ini[0]) + (fin[1] - ini[1]) * (fin[1] - ini[1]));
    return acos((fin[0] - ini[0]) / H);*/
/*    double X = p.point.Lng - message.Longitude_in_WGS_84;
    double Y = p.point.Lat - message.Latitude_in_WGS_84;
    int direction = 100;
    double dir = 0;
    dir = atan2(Y, X) * (180 / pi);*/

    var longitudinalDifference = fin.longitude - ini[1];
    var latitudinalDifference = fin.latitude - ini[0];
    double azimuth = (pi * 0.5) - atan2(latitudinalDifference,longitudinalDifference);
    if (longitudinalDifference > 0) return azimuth;
    else if (longitudinalDifference < 0) return azimuth + pi;
    else if (latitudinalDifference < 0) return pi;
    return 0;
  }

  Trajectories(
      String Callsign,
      int Time,
      double lat,
      double lon,
      String emitter,
      String TargetAddress,
      String DetectionMode,
      String CAT,
      String SAC,
      String SIC,
      String TrackNumber) {
    var p = [lat, lon];
    // Angle Plane
    if(ListPoints.isNotEmpty){
      this.ListAngles.add(computeAngle(p,ListPoints.last));
    }else if(ListPoints.length==1){
      double x = computeAngle(p,ListPoints.last);
      this.ListAngles[0] = x;
      this.ListAngles.add(x);
    }else{
      this.ListAngles.add(0);
    }

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
  void AddPoint(double lat,double lon,int time)
  {
    this.ListAngles.add(computeAngle([lat,lon],ListPoints.last));
    this.ListPoints.add(new LatLng(lat,lon));
    this.ListTime.add(time);
    // Angle Plane

  }
}
