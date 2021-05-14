import 'package:decereix/models/cat10.dart';
import 'package:decereix/models/cat21.dart';

class CATALL {
  int num=0;
  String CAT;
  String SAC;
  String SIC;
  String Target_Identification;
  String Target_Address;
  int Time_Of_day=0;
  int List_Time_Of_Day=0;
  String Track_number;
  String Latitude_in_WGS_84;
  String Longitude_in_WGS_84;
  double Latitude_in_WGS_84_map=0;
  double Longitude_in_WGS_84_map=0;
  double heading = 0;
  String Flight_level;
  String type;
  String DetectionMode;
  int direction=0;
  int refreshratio = -1;

  CATALL();

  /// <summary>
  /// Create an instance of class CAT all from an instance of class CAT10
  /// </summary>
  /// <param name="message">CAT10 instance from which you want to create a CAT All instance</param>
  /// <param name="First_time_of_day">Parameter that indicates the time 00:00:00 of the day of the message (if the message is from the second day the time will be 86400)</param>
  /// <param name="first_time">Indicates the time of the first message in that file. In this way, if a file lasts 2
  /// days we can identify the messages that are on the second day and host them correctly</param>
  CATALL.fromCat10(CAT10 message, int FirstTimeOfDay) {
    this.num = message.Id;
    this.CAT = "10";
    this.SAC = message.SAC;
    this.SIC = message.SIC;
    this.Target_Identification = message.Target_Identification;
    this.Target_Address = message.TargetAddress;
    this.Track_number = message.TrackNumber;
    this.Latitude_in_WGS_84 = message.LatitudeWGS_84;
    this.Longitude_in_WGS_84 = message.LongitudeWGS_84;
    this.Longitude_in_WGS_84_map = message.LongitudeWGS_84_map;
    this.Latitude_in_WGS_84_map = message.LatitudeWGS_84_map;
    this.Flight_level = message.FlightLevel;
    this.Time_Of_day = message.TimeOfDayInSeconds;
    this.List_Time_Of_Day = message.TimeOfDayInSeconds + FirstTimeOfDay;
    this.heading = message.heading;
    /* } */
    if (message.TOT == "Ground vehicle") {
      type = "car";
    } else if (message.TOT == "Aircraft") {
      type = "plane";
    } else {
      type = "undetermined";
    }
    if (message.TYP == "PSR") {
      DetectionMode = "SMR";
    }
    if (message.TYP == "Mode S MLAT") {
      DetectionMode = "MLAT";
    }
  }

  /// </summary>
  /// <param name="message">CAT 21 version 2.1 instance from which you want to create a CAT All instance</param>
  /// <param name="First_time_of_day">Parameter that indicates the time 00:00:00 of the day of the message (if the message is from the second day the time will be 86400)</param>
  /// <param name="first_time">Indicates the time of the first message in that file. In this way, if a file lasts 2
  /// days we can identify the messages that are on the second day and host them correctly</param>
  CATALL.fromCat21(CAT21 message, int FirstTimeOfDay) {
    this.num = message.Id;
    this.CAT = "21";
    this.SAC = message.SAC;
    this.SIC = message.SIC;
    this.Target_Identification = message.Target_Identification;
    this.Target_Address = message.Target_address;
    this.Track_number = message.Track_Number;
    this.Latitude_in_WGS_84_map = message.LatitudeWGS_84_map;
    this.Longitude_in_WGS_84_map = message.LongitudeWGS_84_map;
    this.heading = message.heading;
    this.Flight_level = message.Flight_Level;
    this.Time_Of_day = message.TimeOfDayInSeconds;
    this.List_Time_Of_Day = message.TimeOfDayInSeconds + FirstTimeOfDay;
    /* } */
    if (message.ECAT == "Surface emergency vehicle" ||
        message.ECAT == "Surface service vehicle") {
      type = "car";
    } else if (message.ECAT == "Light aircraft" ||
        message.ECAT == "Small aircraft" ||
        message.ECAT == "Medium aircraft" ||
        message.ECAT == "Heavy aircraft") {
      type = "plane";
    } else {
      type = "undetermined";
    }
    DetectionMode = "ADSB";
  }
}
