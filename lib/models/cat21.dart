import 'dart:typed_data';
import 'package:decereix/Helpers/cat21Helper.dart';
import 'package:decereix/Helpers/helpDecode.dart';
import 'package:flutter/cupertino.dart';

class CAT21 {
  String FSPEC;
  List<String> message;
  List<String> items = [];

  int Id;
  int numOctets;

  // COMPUTE PARAMETERS

  //MESSAGE TYPE
  String messageType;

  //DATA SOURCE IDENTIFIER
  String SAC;
  String SIC;

  // Target Report Descriptor
  String ATP;
  String ARC;
  String RC;
  String RAB;

  String DCR;
  String GBS;
  String SIM;
  String TST;
  String SAA;
  String CL;

  String IPC;
  String NOGO;
  String CPR;
  String LDPJ;
  String RCF;
  String FX;
  // Track Number
  String Track_Number;
  // Service Identification
  String Service_Identification;
  // Time of Applicability for indexition
  String Time_of_Applicability_Position;
  //  indexition in WGS-84 Co-ordinates.
  String LatitudeWGS_84;
  String LongitudeWGS_84;
  double LatitudeWGS_84_map = -200;
  double LongitudeWGS_84_map = -200;
  //  High-Resolution indexition in WGS-84 Co-ordinates
  String High_Resolution_LatitudeWGS_84;
  String High_Resolution_LongitudeWGS_84;
  // Time of Applicability Velocity
  String Time_of_Applicability_Velocity;
  // True Airspeed
  String True_Air_Speed;
  // Air Speed
  String Air_Speed;
  //TARGET ADDRESS
  String Target_address;
  // Time of Message Reception indexition
  String Time_of_Message_Reception_Position;
  // Time_of_Message_Reception_indexition_High_Precision
  String Time_of_Message_Reception_Position_High_Precision;
  // Time_of_Message_Reception_Velocity
  String Time_of_Message_Reception_Velocity;
  // Data Item I021/076, Time of Message Reception of Velocity–High Precision
  String Time_of_Message_Reception_Velocity_High_Precision;

  String Geometric_Height;

  String Quality_Indicators;
  // Quality Indicators
  String NUCr_NACv;
  String NUCp_NIC;
  String NICbaro;
  String SIL;
  String NACp;
  String SILS;
  String SDA;
  String GVA;
  int PIC;
  String ICB;
  String NUCp;
  String NIC;
  // MOPS Version
  String VNS;
  String LTT;
  String MOPS;
  // Mode 3/A Code in Octal Representation
  String ModeA3;
  // Roll Angle
  String Roll_Angle;
  // Flight Level
  String Flight_Level;
  //Magnetic Heading (Element of Air Vector).
  String Magnetic_Heading;
  //Target Status
  String ICF;
  String LNAV;
  String PS;
  String SS;
  //Barometric Vertical Rate, in two’s complement form.
  String Barometric_Vertical_Rate;
  //Geometric Vertical Rate, in two’s complement form, with reference to WGS-84.
  String Geometric_Vertical_Rate;
  //  Ground Speed and Track Angle elements of Airborne Ground Vector.
  String Ground_Speed;
  String Track_Angle;
  String Ground_vector;
  // Track Angle Rate, Rate of Turn, in two’s complement form.
  String Track_Angle_Rate;
  // Time of ASTERIX Report Transmission
  String Time_of_Asterix_Report_Transmission;
  int TimeOfDayInSeconds;
  // Data Item I021/170, Target Identification
  String Target_Identification;
  //EMITTER CATEGORY
  String ECAT;
  // Meteorological information.
  int MET_present = 0;
  String Wind_Speed;
  String Wind_Direction;
  String Temperature;
  String Turbulence;
  // Data Item I021/146, Selected Altitude
  String SAS;
  String Source;
  String Sel_Altitude;
  String Selected_Altitude;
  // Data Item I021/148, Final State Selected Altitude
  String MV;
  String AH;
  String AM;
  String Final_State_Altitude;
  //TRAJECTORY INTENT
  int Trajectory_present = 0;
  bool subfield1;
  bool subfield2;
  String NAV;
  String NVB;
  int REP;
  List<String> TCA;
  List<String> NC;
  List<int> TCP;
  List<String> Altitude;
  List<String> Latitude;
  List<String> Longitude;
  List<String> Point_Type;
  List<String> TD;
  List<String> TRA;
  List<String> TOA;
  List<String> TOV;
  List<String> TTR;
  // Data Item I021/016, Service Management
  String RP;
  // Data Item I021/008, Aircraft Operational Status
  String RA;
  String TC;
  String TS;
  String ARV;
  String CDTIA;
  String Not_TCAS;
  String SA;
  // Data Item I021/271, Surface Capabilities and Characteristics
  String POA;
  String CDTIS;
  String B2_low;
  String RAS;
  String IDENT;
  String LengthandWidth;
  // Data Item I021/132, Message Amplitude
  String Message_Amplitude;
  // Data Item I021/250, Mode S MB Data
  List<String> MB_Data;
  List<String> BDS1;
  List<String> BDS2;
  int modeS_rep;
  // Data Item I021/260, ACAS Resolution Advisory Report
  String TYP;
  String STYP;
  String ARA;
  String RAC;
  String RAT;
  String MTE;
  String TTI;
  String TID;
  // RECEIVER ID
  String Receiver_ID;
  // Data Item I021/295, Data Ages
  int Data_Ages_present = 0;
  String AOS;
  String TRD;
  String M3A;
  String QI;
  String TI;
  String MAM;
  String GH;

  String FL;
  String ISA;
  String FSA;
  String AS;
  String TAS;
  String MH;
  String BVR;

  String GVR;
  String GV;
  String TAR;
  String TI_DataAge;
  String TS_DataAge;
  String MET;
  String ROA;

  String ARA_DataAge;
  String SCC;
  CAT21(HelpDecode decode, CAT21Helper cat21Helper, Uint8List messageInt,
      int id, List<String> message) {
    try {
      //Decode FSPEC
      String FSPEC0 = decode.getFSPEC(message);
      int octetsFSPEC = FSPEC0.length ~/ 7;
      int index = 3 + octetsFSPEC;
      this.FSPEC = FSPEC0;
      this.message = message;
      // Data Item Header
      this.Id = id;
      this.numOctets = message.length;

      /* From now on each function looks to see if the decoding parameter exists in the
                     message (checking if the FSPEC in its indexition == 1) and if it exists calls the function to decode the parameter */

      if (FSPEC[0] == '1') {
        index = cat21Helper.Compute_Data_Source_Identification(message, index);
        SAC = cat21Helper.SAC;
        SIC = cat21Helper.SIC;
      }
      if (FSPEC[1] == '1') {
        index = cat21Helper.Compute_Target_Report_Descripter(message, index);
        ATP = cat21Helper.ATP;
        ARC = cat21Helper.ARC;
        RC = cat21Helper.RC;
        RAB = cat21Helper.RAB;
        DCR = cat21Helper.DCR;
        GBS = cat21Helper.GBS;
        SIM = cat21Helper.SIM;
        TST = cat21Helper.TST;
        this.SAA = cat21Helper.SAA;
        CL = cat21Helper.CL;
        IPC = cat21Helper.IPC;
        NOGO = cat21Helper.NOGO;
        CPR = cat21Helper.CPR;
        LDPJ = cat21Helper.LDPJ;
        RCF = cat21Helper.RCF;
        FX = cat21Helper.FX;
      }
      if (FSPEC[2] == '1') {
        index = cat21Helper.Compute_Track_Number(message, index);
        Track_Number = cat21Helper.Track_Number;
      }
      if (FSPEC[3] == '1') {
        index = cat21Helper.Compute_Service_Identification(message, index);
        Service_Identification = cat21Helper.Service_Identification;
      }
      if (FSPEC[4] == '1') {
        index =
            cat21Helper.Compute_Time_of_Aplicabillity_Position(message, index);
        Time_of_Applicability_Position =
            cat21Helper.Time_of_Applicability_Position;
      }
      if (FSPEC[5] == '1') {
        index = cat21Helper.Compute_PositionWGS_84(message, index);
        LatitudeWGS_84 = cat21Helper.LatitudeWGS_84;
        LongitudeWGS_84 = cat21Helper.LongitudeWGS_84;
        LatitudeWGS_84_map = cat21Helper.LatitudeWGS_84_map;
        LongitudeWGS_84_map = cat21Helper.LongitudeWGS_84_map;
      }
      if (FSPEC[6] == '1') {
        index =
            cat21Helper.Compute_High_Resolution_PositionWGS_84(message, index);
        High_Resolution_LatitudeWGS_84 =
            cat21Helper.High_Resolution_LatitudeWGS_84;
        High_Resolution_LongitudeWGS_84 =
            cat21Helper.High_Resolution_LongitudeWGS_84;
      }
      if (FSPEC.length > 8) {
        if (FSPEC[7] == '1') {
          index = cat21Helper.Compute_Time_of_Aplicabillity_Velocity(
              message, index);
          Time_of_Applicability_Velocity =
              cat21Helper.Time_of_Applicability_Velocity;
        }
        if (FSPEC[8] == '1') {
          index = cat21Helper.Compute_Air_Speed(message, index);
          Air_Speed = cat21Helper.Air_Speed;
        }
        if (FSPEC[9] == '1') {
          index = cat21Helper.Compute_True_Air_Speed(message, index);
          True_Air_Speed = cat21Helper.True_Air_Speed;
        }
        if (FSPEC[10] == '1') {
          index = cat21Helper.Compute_Target_Address(messageInt, index);
          Target_address = cat21Helper.Target_address;
        }
        if (FSPEC[11] == '1') {
          index = cat21Helper.Compute_Time_of_Message_Reception_Position(
              message, index);
          Time_of_Message_Reception_Position =
              cat21Helper.Time_of_Message_Reception_Position;
        }
        if (FSPEC[12] == '1') {
          index = cat21Helper
              .Compute_Time_of_Message_Reception_Position_High_Precision(
                  message, index);
          Time_of_Message_Reception_Position_High_Precision =
              cat21Helper.Time_of_Message_Reception_Position_High_Precision;
        }
        if (FSPEC[13] == '1') {
          index = cat21Helper.Compute_Time_of_Message_Reception_Velocity(
              message, index);
          Time_of_Message_Reception_Velocity =
              cat21Helper.Time_of_Message_Reception_Velocity;
        }
      }
      if (FSPEC.length > 16) {
        if (FSPEC[14] == '1') {
          index = cat21Helper
              .Compute_Time_of_Message_Reception_Velocity_High_Precision(
                  message, index);
          Time_of_Message_Reception_Velocity_High_Precision =
              cat21Helper.Time_of_Message_Reception_Velocity_High_Precision;
        }
        if (FSPEC[15] == '1') {
          index = cat21Helper.Compute_Geometric_Height(message, index);
          Geometric_Height = cat21Helper.Geometric_Height;
        }
        if (FSPEC[16] == '1') {
          index = cat21Helper.Compute_Quality_Indicators(message, index);
          Quality_Indicators = cat21Helper.Quality_Indicators;
          NUCr_NACv = cat21Helper.NUCr_NACv;
          NUCp_NIC = cat21Helper.NUCp_NIC;
          NICbaro = cat21Helper.NICbaro;
          SIL = cat21Helper.SIL;
          NACp = cat21Helper.NACp;
          SILS = cat21Helper.SILS;
          SDA = cat21Helper.SDA;
          GVA = cat21Helper.GVA;
          PIC = cat21Helper.PIC;
          ICB = cat21Helper.ICB;
          NUCp = cat21Helper.NUCp;
          NIC = cat21Helper.NIC;
        }
        if (FSPEC[17] == '1') {
          index = cat21Helper.Compute_MOPS_Version(message, index);
          VNS = cat21Helper.VNS;
          LTT = cat21Helper.LTT;
          MOPS = cat21Helper.MOPS;
        }
        if (FSPEC[18] == '1') {
          index = cat21Helper.Compute_Mode_A3(message, index);
          ModeA3 = cat21Helper.ModeA3;
        }
        if (FSPEC[19] == '1') {
          index = cat21Helper.Compute_Roll_Angle(message, index);
          Roll_Angle = cat21Helper.Roll_Angle;
        }
        if (FSPEC[20] == '1') {
          index = cat21Helper.Compute_Flight_level(message, index);
          Flight_Level = cat21Helper.Flight_Level;
        }
      }
      if (FSPEC.length > 22) {
        if (FSPEC[21] == '1') {
          index = cat21Helper.Compute_Magnetic_Heading(message, index);
          Magnetic_Heading = cat21Helper.Magnetic_Heading;
        }
        if (FSPEC[22] == '1') {
          index = cat21Helper.Compute_Target_Status(message, index);
          ICF = cat21Helper.ICF;
          LNAV = cat21Helper.LNAV;
          PS = cat21Helper.PS;
          SS = cat21Helper.SS;
        }
        if (FSPEC[23] == '1') {
          index = cat21Helper.Compute_Barometric_Vertical_Rate(message, index);
          Barometric_Vertical_Rate = cat21Helper.Barometric_Vertical_Rate;
        }
        if (FSPEC[24] == '1') {
          index = cat21Helper.Compute_Geometric_Vertical_Rate(message, index);
          Geometric_Vertical_Rate = cat21Helper.Geometric_Vertical_Rate;
        }
        if (FSPEC[25] == '1') {
          index = cat21Helper.Compute_Airborne_Ground_Vector(message, index);
          Ground_Speed = cat21Helper.Ground_Speed;
          Track_Angle = cat21Helper.Track_Angle;
          Ground_vector = cat21Helper.Ground_vector;
        }
        if (FSPEC[26] == '1') {
          index = cat21Helper.Compute_Track_Angle_Rate(message, index);
          Track_Angle_Rate = cat21Helper.Track_Angle_Rate;
        }
        if (FSPEC[27] == '1') {
          index = cat21Helper.Compute_Time_of_Asterix_Report_Transmission(
              message, index);
          Time_of_Asterix_Report_Transmission =
              cat21Helper.Time_of_Asterix_Report_Transmission;
          TimeOfDayInSeconds = cat21Helper.Time_of_day_sec;
        }
      }
      if (FSPEC.length > 29) {
        if (FSPEC[28] == '1') {
          index = cat21Helper.Compute_Target_Identification(message, index);
          Target_Identification = cat21Helper.Target_Identification;
        }
        if (FSPEC[29] == '1') {
          index = cat21Helper.Compute_Emitter_Category(message, index);
          ECAT = cat21Helper.ECAT;
        }
        if (FSPEC[30] == '1') {
          index = cat21Helper.Compute_Met_Information(message, index);
          MET_present = cat21Helper.MET_present;
          Wind_Speed = cat21Helper.Wind_Speed;
          Wind_Direction = cat21Helper.Wind_Direction;
          Temperature = cat21Helper.Temperature;
          Turbulence = cat21Helper.Turbulence;
        }
        if (FSPEC[31] == '1') {
          index = cat21Helper.Compute_Selected_Altitude(message, index);
          SAS = cat21Helper.SAS;
          Source = cat21Helper.Source;
          Sel_Altitude = cat21Helper.Sel_Altitude;
          Selected_Altitude = cat21Helper.Selected_Altitude;
        }
        if (FSPEC[32] == '1') {
          index =
              cat21Helper.Compute_Final_State_Selected_Altitude(message, index);
          MV = cat21Helper.MV;
          AH = cat21Helper.AH;
          AM = cat21Helper.AM;
          Final_State_Altitude = cat21Helper.Final_State_Altitude;
        }
        if (FSPEC[33] == '1') {
          index = cat21Helper.Compute_Trajectory_Intent(message, index);
          Trajectory_present = cat21Helper.Trajectory_present;
          subfield1 = cat21Helper.subfield1;
          subfield2 = cat21Helper.subfield2;
          NAV = cat21Helper.NAV;
          NVB = cat21Helper.NVB;
          REP = cat21Helper.REP;
          TCA = cat21Helper.TCA;
          NC = cat21Helper.NC;
          TCP = cat21Helper.TCP;
          Altitude = cat21Helper.Altitude;

          Latitude = cat21Helper.Latitude;
          Longitude = cat21Helper.Longitude;
          Point_Type = cat21Helper.Point_Type;
          TD = cat21Helper.TD;
          TRA = cat21Helper.TRA;
          TOA = cat21Helper.TOA;
          TOV = cat21Helper.TOV;
          TTR = cat21Helper.TTR;
        }
        if (FSPEC[34] == '1') {
          index = cat21Helper.Compute_Service_Managment(message, index);
          RP = cat21Helper.RP;
        }
      }
      if (FSPEC.length > 36) {
        if (FSPEC[35] == '1') {
          index =
              cat21Helper.Compute_Aircraft_Operational_Status(message, index);
          RA = cat21Helper.RA;
          TC = cat21Helper.TC;
          TS = cat21Helper.TS;
          ARV = cat21Helper.ARV;
          CDTIA = cat21Helper.CDTIA;
          Not_TCAS = cat21Helper.Not_TCAS;
          SA = cat21Helper.SA;
        }
        if (FSPEC[36] == '1') {
          index = cat21Helper.Compute_Surface_Capabiliteies_and_Characteristics(
              message, index);
          POA = cat21Helper.POA;
          CDTIS = cat21Helper.CDTIS;
          B2_low = cat21Helper.B2_low;
          RAS = cat21Helper.RAS;
          IDENT = cat21Helper.IDENT;
          LengthandWidth = cat21Helper.LengthandWidth;
        }
        if (FSPEC[37] == '1') {
          index = cat21Helper.Compute_Message_Amplitude(message, index);
          Message_Amplitude = cat21Helper.Message_Amplitude;
        }
        if (FSPEC[38] == '1') {
          index = cat21Helper.Compute_Mode_S_MB_DATA(message, index);
          MB_Data = cat21Helper.MB_Data;
          BDS1 = cat21Helper.BDS1;
          BDS2 = cat21Helper.BDS2;
          modeS_rep = cat21Helper.modeS_rep;
        }
        if (FSPEC[39] == '1') {
          index = cat21Helper.Compute_ACAS_Resolution_Advisory_Report(
              message, index);
          TYP = cat21Helper.TYP;
          STYP = cat21Helper.STYP;
          ARA = cat21Helper.ARA;
          RAC = cat21Helper.RAC;
          RAT = cat21Helper.RAT;
          MTE = cat21Helper.MTE;
          TTI = cat21Helper.TTI;
          TID = cat21Helper.TID;
        }
        if (FSPEC[40] == '1') {
          index = cat21Helper.Compute_Receiver_ID(message, index);
          Receiver_ID = cat21Helper.Receiver_ID;
        }
        if (FSPEC[41] == '1') {
          index = cat21Helper.Compute_Data_Age(message, index);
          Data_Ages_present = cat21Helper.Data_Ages_present;
          AOS = cat21Helper.AOS;
          TRD = cat21Helper.TRD;
          M3A = cat21Helper.M3A;
          QI = cat21Helper.QI;
          TI = cat21Helper.TI;
          MAM = cat21Helper.MAM;
          GH = cat21Helper.GH;
          FL = cat21Helper.FL;
          ISA = cat21Helper.ISA;
          FSA = cat21Helper.FSA;
          AS = cat21Helper.AS;
          TAS = cat21Helper.TAS;
          MH = cat21Helper.MH;
          BVR = cat21Helper.BVR;
          GVR = cat21Helper.GVR;
          GV = cat21Helper.GV;
          TAR = cat21Helper.TAR;
          TI_DataAge = cat21Helper.TI_DataAge;
          TS_DataAge = cat21Helper.TS_DataAge;
          MET = cat21Helper.MET;
          ROA = cat21Helper.ROA;
          ARA_DataAge = cat21Helper.ARA_DataAge;
          SCC = cat21Helper.SCC;
        }
      }
    } catch (e) {
      message = message;
    }
  }
}
