import 'dart:typed_data';

import 'package:decereix/Helpers/cat10Helper.dart';
import 'package:decereix/Helpers/helpDecode.dart';
import 'package:flutter/cupertino.dart';

class CAT10 {
  List<String> message = [];
  int Id=0;
  int numOctets=0;
  int numItems = 0;

  String FSPEC;

//DATA SOURCE IDENTIFIER
  String SAC;
  String SIC;
  String TAR;
  int airportCode=0;
//MESSAGE TYPE
  String messageType;

//TARGET REPORT DESCRIPTOR
  String TYP;
  String DCR;
  String CHN;
  String GBS;
  String CRT;
//First extension
  String SIM;
  String TST;
  String RAB;
  String LOP;
  String TOT;
//Second extension
  String SPI;

//TIME OF DAY
  String TimeOfDay;
  int TimeOfDayInSeconds=0;

//POSITION IN WGS-84 CO-ORDINATES
  String LatitudeWGS_84;
  String LongitudeWGS_84;
  double LatitudeWGS_84_map = -200;
  double LongitudeWGS_84_map = -200;
//MEASURED POSITION IN POLAR CO-ORDINATES
  String RHO;
  String THETA;

//POSITION IN CARTESIAN CO-ORDINATES
  String X_Component;
  String Y_Component;
  String Position_In_Polar;
//CALCULATED TRACK VELOCITY IN POLAR CO-ORDINATES
  String GroundSpeed;
  String TrackAngle;

//CALCULATED TRACK VELOCITY IN CARTESIAN CO-ORDINATES
  String Vx;
  String Vy;

//TRACK NUMBER
  String TrackNumber;

//TRACK STATUS
  String CNF;
  String TRE;
  String CST;
  String MAH;
  String TCC;
  String STH;
//First Extent
  String TOM;
  String DOU;
  String MRS;
//Second Extent
  String GHO;

//MODE-3/A CODE IN OCTAL REPRESANTATION
  String VMode3A;
  String GMode3A;
  String LMode3A;
  String Mode3A;

//TARGET ADDRESS
  String TargetAddress;

//TARGET IDENTIFICATION
  String STI;

//MODE S MB DATA
  List<String> MBData=[];
  List<String> BDS1=[];
  List<String> BDS2=[];
  int modeSrep=0;

//VEHICLE FLEET IDENTIFICATION
  String VFI;

//FLIGHT LEVEL IN BINARY REPRESENTATION
  String VFlightLevel;
  String GFlightLevel;
  String FlightLevelBinary;
  String FlightLevel;

//MEASURED HEIGHT
  String MeasuredHeight;

//TARGET SIZE & ORIENTATION
  String LENGHT;
  String ORIENTATION;
  String WIDTH;

//SYSTEM STATUS
  String NOGO;
  String OVL;
  String TSV;
  String DIV;
  String TIF;

//PRE-PROGRAMMED MESSAGE
  String TRB;
  String MSG;

//STANDARD DEVIATION
  String DeviationX;
  String DeviationY;
  String CovarianceXY;

//PRESENCE
  int REP = 0;
  List<String> DRHO=[];
  List<String> DTHETA=[];

//AMPLITUDE OF PRIMARY PLOT
  String PAM;

//CALCULATED ACCELERATION
  String Ax;
  String Ay;

  CAT10(HelpDecode decode, CAT10Helper cat10Helper, int id,
      List<String> messageBinary) {
    try {
      //Decode FSPEC
      String fspec0 = decode.getFSPEC(messageBinary);
      int octetsFSPEC = (fspec0.length ~/ 7); // double/division to Int
      int index = 3 + octetsFSPEC;
      this.FSPEC = fspec0.substring(0, fspec0.length);

      this.Id = id;
      if (id == 34) {
        String ds = "";
      }
      this.numOctets = messageBinary.length;
      if (FSPEC[0] == '1') {
        index = cat10Helper.Compute_Data_Source_Identifier(messageBinary, index);
        this.SAC = cat10Helper.SAC;
        this.SIC = cat10Helper.SIC;
        this.airportCode = cat10Helper.airportCode;
      } //
      if (FSPEC[1] == '1') {
        index = cat10Helper.Compute_Message_Type(messageBinary, index);
        this.messageType = cat10Helper.MESSAGE_TYPE;
      } //
      if (FSPEC[2] == '1') {
        index =
            cat10Helper.Compute_Target_Report_Descriptor(messageBinary, index);
        this.TYP = cat10Helper.TYP;
        this.DCR = cat10Helper.DCR;
        this.CHN = cat10Helper.CHN;
        this.GBS = cat10Helper.GBS;
        this.CRT = cat10Helper.CRT;
        this.SIM = cat10Helper.SIM;
        this.TST = cat10Helper.TST;
        this.RAB = cat10Helper.RAB;
        this.LOP = cat10Helper.LOP;
        this.TOT = cat10Helper.TOT;
        this.SPI = cat10Helper.SPI;
      } //
      if (FSPEC[3] == '1') {
        index = cat10Helper.Compute_Time_of_Day(messageBinary, index);
        this.TimeOfDay = cat10Helper.Time_Of_Day;
        this.TimeOfDayInSeconds = cat10Helper.Time_of_day_sec;
      } //
      if (FSPEC[4] == '1') {
        index = cat10Helper.Compute_Position_in_WGS_84_Coordinates(
            messageBinary, index);
        this.LatitudeWGS_84 = cat10Helper.Latitude_in_WGS_84;
        this.LongitudeWGS_84 = cat10Helper.Longitude_in_WGS_84;
        this.LatitudeWGS_84_map = cat10Helper.LatitudeWGS_84_map;
        this.LongitudeWGS_84_map = cat10Helper.LongitudeWGS_84_map;
      }
      if (FSPEC[5] == '1') {
        index = cat10Helper.Compute_Measured_Position_in_Polar_Coordinates(
            messageBinary, index);
        this.RHO = cat10Helper.RHO;
        this.THETA = cat10Helper.THETA;
      }
      if (FSPEC[6] == '1') {
        index = cat10Helper.Compute_Position_in_Cartesian_Coordinates(
            messageBinary, index);
        this.X_Component = cat10Helper.X_Component;
        this.Y_Component = cat10Helper.Y_Component;
        this.Position_In_Polar = cat10Helper.Position_In_Polar;
        this.LatitudeWGS_84 = cat10Helper.Latitude_in_WGS_84;
        this.LongitudeWGS_84 = cat10Helper.Longitude_in_WGS_84;
        this.LatitudeWGS_84_map = cat10Helper.LatitudeWGS_84_map;
        this.LongitudeWGS_84_map = cat10Helper.LongitudeWGS_84_map;
      } //
      if (FSPEC.length > 8) {
        if (FSPEC[7] == '1') {
          index = cat10Helper.Compute_Track_Velocity_in_Polar_Coordinates(
              messageBinary, index);
          this.GroundSpeed = cat10Helper.Ground_Speed;
          this.TrackAngle = cat10Helper.Track_Angle;
        } //
        if (FSPEC[8] == '1') {
          index = cat10Helper.Compute_Track_Velocity_in_Cartesian_Coordinates(
              messageBinary, index);
          this.Vx = cat10Helper.Vx;
          this.Vy = cat10Helper.Vy;
        } //
        if (FSPEC[9] == '1') {
          index = cat10Helper.Compute_Track_Number(messageBinary, index);
          this.TrackNumber = cat10Helper.Track_Number;
        } //
        if (FSPEC[10] == '1') {
          index = cat10Helper.Compute_Track_Status(messageBinary, index);
          this.CNF = cat10Helper.CNF;
          this.TRE = cat10Helper.TRE;
          this.CST = cat10Helper.CST;
          this.MAH = cat10Helper.MAH;
          this.TCC = cat10Helper.TCC;
          this.STH = cat10Helper.STH;
          this.TOM = cat10Helper.TOM;
          this.DOU = cat10Helper.DOU;
          this.MRS = cat10Helper.MRS;
          this.GHO = cat10Helper.GHO;
        } //
        if (FSPEC[11] == '1') {
          index = cat10Helper.Compute_Mode_3A_Code_in_Octal_Representation(
              messageBinary, index);
          this.VMode3A = cat10Helper.V_Mode_3A;
          this.GMode3A = cat10Helper.G_Mode_3A;
          this.LMode3A = cat10Helper.L_Mode_3A;
          this.Mode3A = cat10Helper.Mode_3A;
        } //
        if (FSPEC[12] == '1') {
          index = cat10Helper.Compute_Target_Address(messageBinary, index);
          this.TargetAddress = cat10Helper.Target_Address;
        } //
        if (FSPEC[13] == '1') {
          index =
              cat10Helper.Compute_Target_Identification(messageBinary, index);
          this.STI = cat10Helper.STI;
        } //
      }
      if (FSPEC.length > 16) {
        if (FSPEC[14] == '1') {
          index = cat10Helper.Compute_Mode_S_MB_Data(messageBinary, index);
          this.MBData = cat10Helper.MB_Data;
          this.BDS1 = cat10Helper.BDS1;
          this.BDS2 = cat10Helper.BDS2;
          this.modeSrep = cat10Helper.modeS_rep;
        } //
        if (FSPEC[15] == '1') {
          index = cat10Helper.Compute_Vehicle_Fleet_Identificatior(
              messageBinary, index);
          this.VFI = cat10Helper.VFI;
        } //
        if (FSPEC[16] == '1') {
          index = cat10Helper.Compute_Flight_Level_in_Binary_Representaion(
              messageBinary, index);
          this.VFlightLevel = cat10Helper.V_Flight_Level;
          this.GFlightLevel = cat10Helper.G_Flight_Level;
          this.FlightLevelBinary = cat10Helper.Flight_Level_Binary;
          this.FlightLevel = cat10Helper.Flight_Level;
        } //
        if (FSPEC[17] == '1') {
          index = cat10Helper.Compute_Measured_Height(messageBinary, index);
          this.MeasuredHeight = cat10Helper.Measured_Height;
        } //
        if (FSPEC[18] == '1') {
          index = cat10Helper.Compute_Target_Size_and_Orientation(
              messageBinary, index);
          this.LENGHT = cat10Helper.LENGHT;
          this.ORIENTATION = cat10Helper.ORIENTATION;
          this.WIDTH = cat10Helper.WIDTH;
        } //
        if (FSPEC[19] == '1') {
          index = cat10Helper.Compute_System_Status(messageBinary, index);
          this.NOGO = cat10Helper.NOGO;
          this.OVL = cat10Helper.OVL;
          this.TSV = cat10Helper.TSV;
          this.DIV = cat10Helper.DIV;
          this.SAC = cat10Helper.TIF;
        } //
        if (FSPEC[20] == '1') {
          index =
              cat10Helper.Compute_Preprogrammed_Message(messageBinary, index);
          this.TRB = cat10Helper.TRB;
          this.MSG = cat10Helper.MSG;
        } //
      }
      if (FSPEC.length > 22) {
        if (FSPEC[21] == '1') {
          index = cat10Helper.Compute_Standard_Deviation_of_Position(
              messageBinary, index);
          this.DeviationX = cat10Helper.Deviation_X;
          this.DeviationY = cat10Helper.Deviation_Y;
          this.CovarianceXY = cat10Helper.Covariance_XY;
        }
        if (FSPEC[22] == '1') {
          index = cat10Helper.Compute_Presence(messageBinary, index);
          this.REP = cat10Helper.REP_Presence;
          this.DRHO = cat10Helper.DRHO;
          this.DTHETA = cat10Helper.DTHETA;
        }
        if (FSPEC[23] == '1') {
          index = cat10Helper.Compute_Amplitude_of_Primary_Plot(
              messageBinary, index);
          this.PAM = cat10Helper.PAM;
        }
        if (FSPEC[24] == '1') {
          index =
              cat10Helper.Compute_Calculated_Acceleration(messageBinary, index);
          this.Ax = cat10Helper.Ax;
          this.Ay = cat10Helper.Ay;
        }
      }
      String xs = "";
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
