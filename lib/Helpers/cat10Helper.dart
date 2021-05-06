import 'dart:typed_data';

import 'package:decereix/Helpers/helpDecode.dart';

class CAT10Helper{
  HelpDecode lib = new HelpDecode();
  // Empty Constructor
  CAT10Helper();

  /// <summary>
  /// Data Item I010/010, Data Source Identifier
  ///
  /// Definition: Identification of the system from which the data are received.
  /// Format: Two-octet fixed length Data Item.
  /// </summary>
  String SAC;
  String SIC;
  int airportCode;
  int Compute_Data_Source_Identifier(Uint8List message, int pos)
  {
  SAC = message[pos].toString();
  SIC = message[pos + 1].toString();
  this.airportCode = GetAirporteCode(message[pos+1]);
  pos += 2;
  return pos;
  }
  int GetAirporteCode(int SIC)
  {
    int i = 0;
    if (SIC == 107 || SIC == 7 || SIC == 219) { i = 0; } //BARCELONA
    else if (SIC == 5 || SIC == 105 || SIC == 209) { i = 1; } //ASTURIAS
    else if (SIC == 2 || SIC == 102) { i = 2; } //PALMA
    else if (SIC == 6 || SIC == 106 || SIC == 227 || SIC == 228) { i = 3; } //SANTIAGO
    else if (SIC == 3 || SIC == 4 || SIC == 104) { i = 4; } //BARAJAS
    else if (SIC == 1 || SIC == 101) { i = 5; } //TENERIFE
    else if (SIC == 108) { i = 6; } //Malaga
    else if (SIC == 203) { i = 7; } //Bilbao
    else if (SIC == 206) { i = 8; } //ALICANTE
    else if (SIC == 207) { i = 9; } //GRANADA
    else if (SIC == 210) { i = 10; } //LANZAROTE
    else if (SIC == 211) { i = 11; } //TURRILLAS
    else if (SIC == 212) { i = 12; } //Menorca
    else if (SIC == 213 || SIC == 229) { i = 13; } //IBIZA
    else if (SIC == 214) { i = 14; } //VALDESPINA
    else if (SIC == 215 || SIC == 221) { i = 15; } //PARACUELLOS
    else if (SIC == 216) { i = 16; } //RANDA
    else if (SIC == 218) { i = 17; } //GERONA
    else if (SIC == 220 || SIC == 222) { i = 18; } //ESPIÑEIRAS
    else if (SIC == 223) { i = 19; } //VEJER
    else if (SIC == 224) { i = 20; } //YESTE
    else if (SIC == 225 || SIC == 226) { i = 21; } //VIGO
    else if (SIC == 230) { i = 22; } //VALENCIA
    else if (SIC == 231) { i = 23; } //SEVILLA
    return i;
  }
  /// HHHH
  /// <summary>
  /// Data Item I010/000, Message Type
  ///
  /// Definition: This Data Item allows for a more convenient handling of the messages at the receiver side by further defining the type of transaction.
  /// Format: One-octet fixed length Data Item.
  /// </summary>
  String MESSAGE_TYPE;
  int Compute_Message_Type(Uint8List message, int pos)
  {
    MESSAGE_TYPE = "Error";
    int Message_Type = message[pos];
    if (Message_Type == 1) { MESSAGE_TYPE = "Target Report"; }
    if (Message_Type == 2) { MESSAGE_TYPE = "Start of Update Cycle"; }
    if (Message_Type == 3) { MESSAGE_TYPE = "Periodic Status Message"; }
    if (Message_Type == 4) { MESSAGE_TYPE = "Event-triggered Status Message"; }
    pos++;
    return pos;
  }
  /// <summary>
  /// Data Item I010/020, Target Report Descriptor
  ///
  /// Definition: Type and characteristics of the data as transmitted by a system.
  /// Format: Variable length Data Item comprising a first part of one-octet, followed by one-octet extents as necessary.
  /// </summary>

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
  int Compute_Target_Report_Descriptor(List<String> messageOctets, int pos)
  {
    int cont = 1;
    String octeto1 = messageOctets[pos];
    String TYP = octeto1.substring(0, 3);
    if (TYP == "000")
    this.TYP = "SSR MLAT";
    if (TYP == "001")
    this.TYP = "Mode S MLAT";
    if (TYP == "010")
    this.TYP = "ADS-B";
    if (TYP == "011")
    this.TYP = "PSR";
    if (TYP == "100")
    this.TYP = "Magnetic Loop System";
    if (TYP == "101")
    this.TYP = "HF MLAT";
    if (TYP == "110")
    this.TYP = "Not defined";
    if (TYP == "111")
    this.TYP = "Other types";

    String DCR = octeto1[3];
    if (DCR == "0")
    this.DCR = "No differential correction";
    if (DCR == "1")
    this.DCR = "Differential correction";

    String CHN = octeto1[4];
    if (CHN == "1")
    this.CHN = "Chain 2";
    if (CHN == "0")
    this.CHN = "Chain 1";

    String GBS = octeto1[5];
    if (GBS == "0")
    this.GBS = "Transponder Ground bit not set";
    if (GBS == "1")
    this.GBS = "Transponder Ground bit set";

    String CRT = octeto1[6];
    if (CRT == "0")
    this.CRT = "No Corrupted reply in multilateration";
    if (CRT == "1")
    this.CRT = "Corrupted replies in multilateration";
    String FX = octeto1[7];
    while (FX == "1")
    {
      String newoctet = messageOctets[pos + cont];
      FX = newoctet[7];
      if (cont == 1)
      {
      String SIM = newoctet[0];
      if (SIM == "0")
      this.SIM = "Actual target report";
      if (SIM == "1")
      this.SIM = "Simulated target report";

      String TST = newoctet[1];
      if (TST == "0")
      this.TST = "TST: Default";
      if (TST == "1")
      this.TST = "Test Target";

      String RAB = newoctet[2];
      if (RAB == "0")
      this.RAB = "Report from target transponder";
      if (RAB == "1")
      this.RAB = "Report from field monitor (fixed transponder)";

      String LOP = newoctet.substring(3,5);
      if (LOP == "00")
      this.LOP = "Loop status: Undetermined";
      if (LOP == "01")
      this.LOP = "Loop start";
      if (LOP == "10")
      this.LOP = "Loop finish";

      String TOT = newoctet.substring(5,7);
      if (TOT == "00")
      this.TOT = "Type of vehicle: Undetermined";
      if (TOT == "01")
      this.TOT = "Aircraft";
      if (TOT == "10")
      this.TOT = "Ground vehicle";
      if (TOT == "11")
      this.TOT = "Helicopter";
      }
      else
      {
      if (newoctet.substring(0, 1) == "0")
        this.SPI = "Absence of SPI (Special Position Identification)";
        if (newoctet.substring(0, 1) == "1")
        this.SPI = "SPI (Special Position Identification)";
      }
      cont++;
    }
    pos = cont + pos;
    return pos;
  }

  /// <summary>
  /// Data Item I010/140, Time of Day
  ///
  /// Definition: Absolute time stamping expressed as UTC.
  /// Format: Three-octet fixed length Data Item.
  /// </summary>
  /// <param name="Time_of_day_sec">Seconds in int format to be used in map</param>
  /// <param name="Time_of_day_sec">Seconds in String format to be shown in tables</param>
  String Time_Of_Day;
  int Time_of_day_sec;
  int Compute_Time_of_Day(List<String> messageOctets, int pos)
  {
    int str =  int.parse(messageOctets[pos]+ messageOctets[pos + 1]+ messageOctets[pos + 2]);
    double seconds = str / 128;
    Time_of_day_sec = seconds.truncate();
    final d3 = Duration(milliseconds: str*1000);
    Time_Of_Day = d3.toString().substring(2, 7);
    pos += 3;
    return pos;
  }
  /// <summary>
  /// Data Item I010/041, Position in WGS-84 Co-ordinates
  ///
  /// Definition : Position of a target in WGS-84 Co-ordinates.
  /// Format : Eight-octet fixed length Data Item
  /// </summary>
  /// <param name="Latitude_in_WGS_84">Latitude in Degrees minutes seconds that will show in the tables</param>
  /// <param name="Longitudee_in_WGS_84">Longitude in Degrees minutes seconds that will show in the tables</param>
  /// <param name="Latitude_in_WGS_84_map">Latitude in decimals used to draw markers on map</param>
  /// <param name="Latitude_in_WGS_84_map">Longiutde in decimals used to draw markers on map</param>
  ///
  String Latitude_in_WGS_84;
  String Longitude_in_WGS_84;
  double LatitudeWGS_84_map = -200;
  double LongitudeWGS_84_map = -200;
  int Compute_Position_in_WGS_84_Coordinates(List<String> messageOctets, int pos)
  {
    double Latitude = this.lib.TwoComplement2Decimal(messageOctets[pos]+ messageOctets[pos + 1]+ messageOctets[pos + 2]+ messageOctets[pos + 3]) * (180 / 8.38190317e-8);
    pos += 4;
    double Longitude = this.lib.TwoComplement2Decimal(messageOctets[pos]+ messageOctets[pos + 1]+ messageOctets[pos + 2]+ messageOctets[pos + 3]) * (180 / 8.38190317e-8);
    pos += 4;
    int Latdegres = Latitude.truncate();
    int Latmin = ((Latitude - Latdegres) * 60).truncate();
    double Latsec = (Latitude - (Latdegres + (Latmin / 60)))*3600;
    int Londegres = Longitude.truncate();
    int Lonmin = ((Longitude - Londegres) * 60).truncate();
    double Lonsec = (Longitude - (Londegres + (Lonmin / 60)))*3600;
    Latitude_in_WGS_84 = Latdegres.toString() + "º " + Latmin.toString() + "' " + Latsec.toString() + "''";
    Longitude_in_WGS_84 = Londegres.toString() + "º" + Lonmin.toString() + "' " + Lonsec.toString() + "''";
    return pos;
  }
  /// <summary>
  /// Data Item I010/040, Measured Position in Polar Co-ordinates
  ///
  /// Definition: Measured position of a target in local polar co-ordinates.
  /// Format: Four-octet fixed length Data Item.
  /// </summary>
  String RHO;
  String THETA;
   String Position_In_Polar;
   int Compute_Measured_Position_in_Polar_Coordinates(List<String> message, int pos)
  {
    double Range = int.parse(message[pos].toString() + message[pos + 1].toString()) as double; //I suppose in meters
    if (Range >= 65536) { RHO = "RHO exceds the max range or is the max range "; } //RHO = " + Convert.ToString(Range) + "m"; MessageBox.Show("RHO exceed the max range or is the max range, RHO = {0}m", Convert.ToString(Range)); }
    else { RHO = "ρ:" + Range.toString() + "m"; }//MessageBox.Show("RHO is the max range, RHO = {0}m", Convert.ToString(Range)); }
    THETA = (int.parse(message[pos+2].toString() + message[pos + 3].toString()) * (360 / (8.38190317e-8))).toString(); //I suppose in degrees
    Position_In_Polar = RHO + THETA;
    pos += 4;
    return pos;
  }
  /// <summary>
  /// Data Item I010/042, Position in Cartesian Co-ordinates
  ///
  /// Definition: Position of a target in Cartesian co-ordinates, in two’s complement form.
  /// Format: Four-octet fixed length Data Item.
  /// </summary>
  /// <param name="Position_Cartesian_Coordinates"> Position in String format for tables </param>
  /// <param name="X_Component_map">X componet to use in map</param>
  /// <param name="Y_Component_map">Y component to use in map</param>
  double X_Component_map = -99999;
  double Y_Component_map = -99999;
  String X_Component;
  String Y_Component;
  String Position_Cartesian_Coordinates;
  int Compute_Position_in_Cartesian_Coordinates(List<String> message, int pos)
  {
  X_Component_map = this.lib.TwoComplement2Decimal(message[pos].toString() + message[pos + 1].toString());
  Y_Component_map = this.lib.TwoComplement2Decimal(message[pos + 2].toString() + message[pos + 3].toString());
  X_Component = X_Component_map.toString();
  Y_Component = Y_Component_map.toString();
  Position_Cartesian_Coordinates = "X: " + X_Component + ", Y: " + Y_Component;
  /*Point p = new Point(X_Component_map, Y_Component_map);*/
  /* PointLatLng position = ComputeWGS_84_from_Cartesian(p, this.SIC);*/ //Compute WGS84 position from cartesian position
  /*Set_WGS84_Coordinates(position);*/ //Apply computed WGS84 position to this message
  pos += 4;
  return pos;
  }
  /// <summary>
  /// Data Item I010/200, Calculated Track Velocity in Polar Co-ordinates
  ///
  /// Definition: Calculated track velocity expressed in polar co-ordinates.
  /// Format : Four-Octet fixed length data item.
  /// </summary>
  String Ground_Speed;
  String Track_Angle;
  String Track_Velocity_Polar_Coordinates;
  int Compute_Track_Velocity_in_Polar_Coordinates(List<String> message, int pos)
  {
  double ground_speed = (int.parse(message[pos].toString() + message[pos + 1].toString())) * 0.00006103515;
  double meters = ground_speed * 1852;
  if (ground_speed >= 2) { Ground_Speed = "Ground Speed exceed the max value (2 NM/s) or is the max value, "; }
  else { Ground_Speed = "GS: " +  meters.toString() + " m/s, "; }
  Track_Angle = "T.A: " + (int.parse(message[pos + 2].toString() + message[pos + 3].toString()) * (360 / (65536))).toString() + "°";
  Track_Velocity_Polar_Coordinates = Ground_Speed + Track_Angle;
  pos += 4;
  return pos;
  }

  /// <summary>
  /// Data Item I010/202, Calculated Track Velocity in Cartesian Co-ordinates
  ///
  /// Definition: Calculated track velocity expressed in Cartesian co-ordinates, in two’s complement representation.
  /// Format: Four-octet fixed length Data Item.
  /// </summary>
  String Vx;
  String Vy;
  String Track_Velocity_in_Cartesian_Coordinates;
  int Compute_Track_Velocity_in_Cartesian_Coordinates(List<String> message, int pos)
  {
  double vx = this.lib.TwoComplement2Decimal(message[pos].toString() + message[pos + 1].toString()) * 0.25;
  Vx = "Vx: " + vx.toString() + " m/s, ";
  double vy = (this.lib.TwoComplement2Decimal(message[pos + 2]+ message[pos + 3])) * 0.25;
  Vy = "Vy: " + vy.toString() + " m/s";
  Track_Velocity_in_Cartesian_Coordinates = Vx + Vy;
  pos += 4;
  return pos;
  }

  /// <summary>
  /// Data Item I010/161, Track Number
  ///
  /// Definition: An integer value representing a unique reference to a track record within a particular track file.
  /// Format: Two-octet fixed length Data Item.
  /// </summary>
  String Track_Number;
  int Compute_Track_Number(List<String> message, int pos)
  {
  Track_Number = (int.parse((message[pos].toString() + message[pos + 1].toString()).substring(4, 12))).toString();
  pos += 2;
  return pos;
  }

  /// <summary>
  /// Data Item I010/170, Track Status
  ///
  /// Definition: Status of track.
  /// Format: Variable length Data Item comprising a first part of one-octet, followed by one-octet extents as necessary.
  /// </summary>

  String CNF;
  String TRE;
  String CST;
  String MAH;
  String TCC;
  String STH;
  String TOM;
  String DOU;
  String MRS;
  String GHO;
  int Compute_Track_Status(List<String> message, int pos)
  {
    String OctetoChar = message[pos];
    if (OctetoChar[0] == '0') { CNF = "Confirmed track"; }
    else { CNF = "Track in initialisation phase"; }
    if (OctetoChar[1] == '0') { TRE = "TRE: Default"; }
    else { TRE = "TRE: Last report for a track"; }
    int crt = int.parse(OctetoChar[2]+ OctetoChar[3]);
    if (crt == 0) { CST = "No extrapolation"; }
    else if (crt == 1) { CST = "Predictable extrapolation due to sensor refresh period"; }
    else if (crt == 2) { CST = "Predictable extrapolation in masked area"; }
    else if (crt == 3) { CST = "Extrapolation due to unpredictable absence of detection"; }
    if (OctetoChar[4] == '0') { MAH = "MAH: Default"; }
    else { MAH = "MAH: Horizontal manoeuvre"; }
    if (OctetoChar[5] == '0') { TCC = "Tracking performed in 'Sensor Plane', i.e. neither slant range correction nor projection was applied"; }
    else { TCC = "Slant range correction and a suitable projection technique are used to track in a 2D.reference plane, tangential to the earth model at the Sensor Site co-ordinates"; }
    if (OctetoChar[6] == '0') { STH = "Measured position"; }
    else { STH = "Smoothed position"; }
    pos++;
    if (OctetoChar[7] == '1')
    {
    OctetoChar = message[pos];
    int tom = int.parse(OctetoChar[0] + OctetoChar[1]);
    if (tom == 0) { TOM = "TOM: Unknown type of movement"; }
    else if (tom == 1) { TOM = "TOM: Taking-off"; }
    else if (tom == 2) { TOM = "TOM: Landing"; }
    else if (tom == 3) { TOM = "TOM: Other types of movement"; }
    int dou = int.parse(OctetoChar[2] + OctetoChar[3]+ OctetoChar[4]);
    if (dou == 0) { DOU = "No doubt"; }
    else if (dou == 1) { DOU = "Doubtful correlation (undetermined reason)"; }
    else if (dou == 2) { DOU = "Doubtful correlation in clutter"; }
    else if (dou == 3) { DOU = "Loss of accuracy"; }
    else if (dou == 4) { DOU = "Loss of accuracy in clutter"; }
    else if (dou == 5) { DOU = "Unstable track"; }
    else if (dou == 6) { DOU = "Previously coasted"; }
    int mrs = int.parse(OctetoChar[5] + OctetoChar[6]);
    if (mrs == 0) { MRS = "Merge or split indication undetermined"; }
    else if (mrs == 1) { MRS = "Track merged by association to plot"; }
    else if (mrs == 2) { MRS = "Track merged by non-association to plot"; }
    else if (mrs == 3) { MRS = "Split track"; }
    pos++;
    if (OctetoChar[7] == '1')
    {
    OctetoChar = message[pos];
    if (OctetoChar[0] == '0') { GHO = "GHO: Default"; }
    else { GHO = "Ghost track"; }
    pos++;
    }
    }
    return pos;
  }

  /// <summary>
  /// Data Item I010/060, Mode-3/A Code in Octal Representation
  ///
  /// Definition: Mode-3/A code converted into octal representation
  /// Format: Two-octet fixed length Data Item.
  /// </summary>
  // DATA ITEM I010/060, MODE-3/A CODE IN OCTAL REPRESANTATION
  String V_Mode_3A;
  String G_Mode_3A;
  String L_Mode_3A;
  String Mode_3A;
  int Compute_Mode_3A_Code_in_Octal_Representation(List<String> message, int pos)
  {
  String OctetoChar = message[pos];
  if (OctetoChar[0] == '0') { V_Mode_3A = "V: Code validated"; }
  else { V_Mode_3A = "V: Code not validated"; }
  if (OctetoChar[1] == '0') { G_Mode_3A = "G: Default"; }
  else { G_Mode_3A = "G: Garbled code"; }
  if (OctetoChar[2] == '0') { L_Mode_3A = "L: Mode-3/A code derived from the reply of the transponder"; }
  else { L_Mode_3A = "L: Mode-3/A code not extracted during the last scan"; }
  Mode_3A = this.lib.decimal2Octal(int.parse(message[pos].toString() + message[pos + 1].toString())).toString().padLeft(4, '0');
  pos += 2;
  return pos;
  }

  /// <summary>
  /// Data Item I010/220, Target Address
  ///
  /// Definition: Target address (24-bits address) assigned uniquely to each Target.
  /// Format: Three-octet fixed length Data Item.
  /// </summary>
  String Target_Address;
  int Compute_Target_Address(Uint8List messageInt, int pos)
  {
    Target_Address = messageInt[pos].toRadixString(16).padLeft(2, "0")+messageInt[pos + 1].toRadixString(16).padLeft(2, "0")+
        messageInt[pos + 2].toRadixString(16).padLeft(2, "0");
    pos += 3;
    return pos;
  }
  /// <summary>
  /// Data Item I010/245, Target Identification
  ///
  /// Definition: Target (aircraft or vehicle) identification in 8 characters.
  /// Format: Seven-octet fixed length Data Item.
  /// </summary>
  String STI;
  String Target_Identification;
  String TAR;
  int Compute_Target_Identification(List<String> message, int pos)
  {
    String octeto = message[pos];
    String sti = octeto[0]+octeto[1];
    if (sti == "00") { STI = "Callsign or registration downlinked from transponder"; }
    else if (sti == "01") { STI = "Callsign not downlinked from transponder"; }
    else if (sti == "10") { STI = "Registration not downlinked from transponder"; }
    StringBuffer Identification = new StringBuffer();
    String octets = message[pos].toString() + message[pos + 1].toString() + message[pos+2].toString() + message[pos + 3].toString()+message[pos+4].toString() + message[pos + 5].toString();
    for (int i = 0; i < 8; i++) {
      Identification.write(this.lib.computeChar(octets.substring(i * 6, 6)));
    }
    TAR = Identification.toString();
    pos += 7;
    return pos;
  }
















}