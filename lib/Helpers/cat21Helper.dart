import 'dart:core';
import 'dart:typed_data';
import 'package:decereix/Helpers/helpDecode.dart';

class CAT21Helper{
  HelpDecode lib = HelpDecode();

  CAT21Helper();
  /// <summary>
  /// Data Item I021/008, Aircraft Operational Status
  ///
  /// Definition: Identification of the operational services available in the aircraft while airborne.
  /// Format: One-octet fixed length Data Item.
  /// </summary>

  String RA;
  String TC;
  String TS;
  String ARV;
  String CDTIA;
  String Not_TCAS;
  String SA;
  int Compute_Aircraft_Operational_Status(List<String> message, int pos)
  {
    String OctetoChar = message[pos];
    if (OctetoChar[0] == '1') { RA = "TCAS RA active"; }
    else { RA = "TCAS II or ACAS RA not active"; }
    if (this.lib.Binary2Int(OctetoChar[1] + OctetoChar[2]) == 1) { TC = "No capability for trajectory Change Reports"; }
    else if (this.lib.Binary2Int(OctetoChar[1] + OctetoChar[2]) == 2) { TC = "Support fot TC+0 reports only"; }
    else if (this.lib.Binary2Int(OctetoChar[1] + OctetoChar[2]) == 3) { TC = "Support for multiple TC reports"; }
    else { TC = "Reserved"; }
    if (OctetoChar[3] == '0') { TS = "No capability to support Target State Reports"; }
    else { TS = "Capable of supporting target State Reports"; }
    if (OctetoChar[4] == '0') { ARV = "No capability to generate ARV-Reports"; }
    else { ARV = "Capable of generate ARV-Reports"; };
    if (OctetoChar[5] == '0') { CDTIA = "CDTI not operational"; }
    else { CDTIA = "CDTI operational"; }
    if (OctetoChar[6] == '0') { Not_TCAS = "TCAS operational"; }
    else { Not_TCAS = "TCAS not operational"; }
    if (OctetoChar[7] == '0') { SA = "Antenna Diversity"; }
    else { SA = "Single Antenna only"; }
    pos++;
    return pos;
  }

  /// <summary>
  ///  Data Item I021/010, Data Source Identification
  ///
  /// Definition : Identification of the ADS-B station providing information.
  /// Format : Two-octet fixed length Data Item.
  /// </summary>

  String SAC;
  String SIC;
  int airportCode;
  int Compute_Data_Source_Identification(List<String> message, int pos)
  {
    SAC = this.lib.Binary2Int(message[pos]).toString();
    int x = this.lib.Binary2Int(message[pos + 1]);
    SIC = x.toString();
    this.airportCode = GetAirporteCode((x)); //Computes airport code from SIC
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
  /// <summary>
  /// Data Item I021/015, Service Identification
  ///
  /// Definition : Identification of the service provided to one or more users.
  /// Format : One-Octet fixed length data item.
  /// </summary>
  String Service_Identification;
  int Compute_Service_Identification(List<String> message, int pos)
  {
    Service_Identification = this.lib.Binary2Int(message[pos]).toString();
    pos++;
    return pos;
  }

  /// <summary>
  /// Data Item I021/016, Service Management
  ///
  /// Definition: Identification of services offered by a ground station (identified by a SIC code).
  /// Format: One-octet fixed length Data Item.
  /// </summary>
  String RP;
  int Compute_Service_Managment(List<String> message, int pos)
  {
    RP = (this.lib.Binary2Double(message[pos]) * 0.5).toString() + " sec";
    pos++;
    return pos;
  }

  /// <summary>
  /// Data Item I021/020, Emitter Category
  ///
  /// Definition : Characteristics of the originating ADS-B unit.
  /// Format : One-Octet fixed length data item.
  /// </summary>
  //EMITTER CATEGORY
  String ECAT;
  int Compute_Emitter_Category(List<String> message, int pos)
  {
    int ecat = this.lib.Binary2Int(message[pos]);
    if (Target_Identification == "7777XBEG") { ECAT = "No ADS-B Emitter Category Information"; }
    else
    {
      if (ecat == 0) { ECAT = "No ADS-B Emitter Category Information"; }
      if (ecat == 1) { ECAT = "Light aircraft"; }
      if (ecat == 2) { ECAT = "Small aircraft"; }
      if (ecat == 3) { ECAT = "Medium aircraft"; }
      if (ecat == 4) { ECAT = "High Vortex Large"; }
      if (ecat == 5) { ECAT = "Heavy aircraft"; }
      if (ecat == 6) { ECAT = "Highly manoeuvrable(5g acceleration capability) and high speed(> 400 knots cruise)"; }
      if (ecat == 7 || ecat == 8 || ecat == 9) { ECAT = "Reserved"; }
      if (ecat == 10) { ECAT = "Rotocraft"; }
      if (ecat == 11) { ECAT = "Glider / Sailplane"; }
      if (ecat == 12) { ECAT = "Lighter than air"; }
      if (ecat == 13) { ECAT = "Unmanned Aerial Vehicle"; }
      if (ecat == 14) { ECAT = "Space / Transatmospheric Vehicle"; }
      if (ecat == 15) { ECAT = "Ultralight / Handglider / Paraglider"; }
      if (ecat == 16) { ECAT = "Parachutist / Skydiver"; }
      if (ecat == 17 || ecat == 18 || ecat == 19) { ECAT = "Reserved"; }
      if (ecat == 20) { ECAT = "Surface emergency vehicle"; }
      if (ecat == 21) { ECAT = "Surface service vehicle"; }
      if (ecat == 22) { ECAT = "Fixed ground or tethered obstruction"; }
      if (ecat == 23) { ECAT = "Cluster obstacle"; }
      if (ecat == 24) { ECAT = "Line obstacle"; }
    }
    pos++;
    return pos;
  }

  /// <summary>
  /// Data Item I021/040, Target Report Descriptor
  ///
  /// Definition: Type and characteristics of the data as transmitted by a system.
  /// Format: Variable Length Data Item, comprising a primary subfield of one octet, followed by one-octet extensions as necessary.
  /// </summary>

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
  int Compute_Target_Report_Descripter(List<String> message, int pos)
  {
    String OctetoChar = message[pos];
    int atp = this.lib.Binary2Int(OctetoChar[0]+ OctetoChar[1]+ OctetoChar[2]);
    int arc = this.lib.Binary2Int(OctetoChar[3]+ OctetoChar[4]);
    if (atp == 0) { ATP = "24-Bit ICAO address"; }
    else if (atp == 1) { ATP = "Duplicate address"; }
    else if (atp == 2) { ATP = "Surface vehicle address"; }
    else if (atp == 3) { ATP = "Anonymous address"; }
    else { ATP = "Reserved for future use"; }
    if (arc == 0) { ARC = "25 ft "; }
    else if (arc == 1) { ARC = "100 ft"; }
    else if (arc == 2) { ARC = "Unknown"; }
    else { ARC = "Invalid"; }
    if (OctetoChar[5] == '0') { RC = "Default"; }
    else { RC = "Range Check passed, CPR Validation pending"; }
    if (OctetoChar[6] == '0') { RAB = "Report from target transponder"; }
    else { RAB = "Report from field monitor (fixed transponder)"; }
    pos++;
    if (OctetoChar[7] == '1')
    {
      OctetoChar = message[pos];
      if (OctetoChar[0] == '0') { DCR = "No differential correction (ADS-B)"; }
      else { DCR = "Differential correction (ADS-B)"; }
      if (OctetoChar[1] == '0') { GBS = "Ground Bit not set"; }
      else { GBS = "Ground Bit set"; }
      if (OctetoChar[2] == '0') { SIM = "Actual target report"; }
      else { SIM = "Simulated target report"; }
      if (OctetoChar[3] == '0') { TST = "Default"; }
      else { TST = "Test Target"; }
      if (OctetoChar[4] == '0') { SAA = "Equipment capable to provide Selected Altitude"; }
      else { SAA = "Equipment not capable to provide Selected Altitude"; }
      int cl = this.lib.Binary2Int(OctetoChar[5]+ OctetoChar[6]);
      if (cl == 0) { CL = "Report valid"; }
      else if (cl == 1) { CL = "Report suspect"; }
      else if (cl == 2) { CL = "No information"; }
      else { CL = "Reserved for future use"; }
      pos++;
      if (OctetoChar[7] == '1')
      {
        OctetoChar = message[pos];
        if (OctetoChar[2] == '0') { IPC = "Default"; }
        else { IPC = "Independent Position Check failed"; }
        if (OctetoChar[3] == '0') { NOGO = "NOGO-bit not set"; }
        else { NOGO = "NOGO-bit set"; }
        if (OctetoChar[4] == '0') { CPR = "CPR Validation correct "; }
        else { CPR = "CPR Validation failed"; }
        if (OctetoChar[5] == '0') { LDPJ = "LDPJ not detected"; }
        else { LDPJ = "LDPJ detected"; }
        if (OctetoChar[6] == '0') { RCF = "Default"; }
        else { RCF = "Range Check failed "; }
        pos++;
      }
    }
    return pos;
  }

  /// <summary>
  /// Data Item I021/070, Mode 3/A Code in Octal Representation
  ///
  /// Definition: Mode-3/A code converted into octal representation.
  /// Format: Two-octet fixed length Data Item.
  /// </summary>
  String ModeA3;
  int Compute_Mode_A3(List<String> message, int pos)
  {
    ModeA3 = (lib.decimal2Octal(this.lib.Binary2Int((message[pos]+ message[pos + 1]).substring(4, 16)))).toString().padLeft(4, '0');
    pos += 2;
    return pos;
  }

  /// <summary>
  /// Data Item I021/071, Time of Applicability for Position
  ///
  /// Definition: Time of applicability of the reported position, in the form of elapsed time since last midnight, expressed as UTC.
  /// Format: Three-Octet fixed length data item.
  /// </summary>
  String Time_of_Applicability_Position;
  int Compute_Time_of_Aplicabillity_Position(List<String> message, int pos)
  {
    // MessageBox.Show("Entered");
    int str = this.lib.Binary2Int(message[pos]+ message[pos + 1]+ message[pos + 2]);
    double seconds = ((str) / 128);
    Time_of_day_sec = seconds.truncate();
    final d3 = Duration(milliseconds: str*1000);
    Time_of_Applicability_Position = d3.toString().substring(2, 7);
    pos += 3;
    return pos;
  }

  /// <summary>
  /// Data Item I021/072, Time of Applicability for Velocity
  ///
  /// Definition: Time of applicability(measurement) of the reported velocity, in the form of elapsed time since last midnight, expressed as UTC.
  /// Format: Three-Octet fixed length data item.
  /// </summary>
  String Time_of_Applicability_Velocity;
  int Compute_Time_of_Aplicabillity_Velocity(List<String> message, int pos)
  {
    int str = this.lib.Binary2Int(message[pos]+ message[pos + 1]+ message[pos + 2]);
    double seconds = ((str) / 128);
    Time_of_day_sec = seconds.truncate();
    final duration = Duration(seconds: Time_of_day_sec);
    Time_of_Applicability_Velocity = "${duration.inHours}:${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";
    pos += 3;
    return pos;
  }

  /// <summary>
  /// Data Item I021/073, Time of Message Reception for Position
  ///
  /// Definition : Time of reception of the latest position squitter in the Ground
  /// Station, in the form of elapsed time since last midnight, expressed as UTC.
  /// Format : Three-Octet fixed length data item.
  /// </summary>
  String Time_of_Message_Reception_Position;
  int Compute_Time_of_Message_Reception_Position(List<String> message, int pos)
  {
    int str = this.lib.Binary2Int(message[pos]+ message[pos + 1]+ message[pos + 2]);
    double seconds = ((str) / 128);
    Time_of_day_sec = seconds.truncate();
    final duration = Duration(seconds: Time_of_day_sec);
    Time_of_Message_Reception_Position = "${duration.inHours}:${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";
    pos += 3;
    return pos;
  }


  /// <summary>
  /// Data Item I021/074, Time of Message Reception of Position–High Precision
  ///
  /// Definition : Time at which the latest ADS-B position information was received
  /// by the ground station, expressed as fraction of the second of the UTC Time.
  /// Format : Four-Octet fixed length data item.
  /// </summary>
  String Time_of_Message_Reception_Position_High_Precision;
  int Compute_Time_of_Message_Reception_Position_High_Precision(List<String> message, int pos)
  {
    String octet = (message[pos]+ message[pos + 1]+ message[pos + 2]+ message[pos + 3]);
    String FSI = octet.substring(0, 2);
    String time = octet.substring(2, 32);
    int str = this.lib.Binary2Int(time);
    double sec = ((str)) * 9.3132257e-10;
    if (FSI == "10") { sec--; }
    if (FSI == "01") { sec++; }
    Time_of_Message_Reception_Position_High_Precision = sec.toString() + " sec";
    pos += 4;
    return pos;
  }


  /// <summary>
  /// Data Item I021/075, Time of Message Reception for Velocity
  ///
  /// Definition : Time of reception of the latest velocity squitter in the Ground
  /// Station, in the form of elapsed time since last midnight, expressed as UTC.
  /// Format: Three-Octet fixed length data item.
  /// </summary>
  String Time_of_Message_Reception_Velocity;
  int Compute_Time_of_Message_Reception_Velocity(List<String> message, int pos)
  {
    int str = this.lib.Binary2Int((message[pos]+ message[pos + 1]+ message[pos + 2]));

    double seconds = ((str) / 128);
    Time_of_day_sec = seconds.truncate();
    final duration = Duration(seconds: Time_of_day_sec);
    Time_of_Message_Reception_Velocity = "${duration.inHours}:${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";

    pos += 3;
    return pos;
  }


  /// <summary>
  /// Data Item I021/076, Time of Message Reception of Velocity–High Precision
  ///
  /// Definition : Time at which the latest ADS-B velocity information was received
  /// by the ground station, expressed as fraction of the second of the UTC Time.
  /// Format: Four-Octet fixed length data item.
  /// </summary>
  String Time_of_Message_Reception_Velocity_High_Precision;
  int Compute_Time_of_Message_Reception_Velocity_High_Precision(List<String> message, int pos)
  {
    String octet =(message[pos]+ message[pos + 1]+ message[pos + 2]+ message[pos + 3]);
    String FSI = octet.substring(0, 2);
    String time = octet.substring(2, 32);
    int str = this.lib.Binary2Int(time);
    double sec = ((str)) * 9.3132257e-10;
    if (FSI == "10") { sec--; }
    if (FSI == "01") { sec++; }
    Time_of_Message_Reception_Velocity_High_Precision = (sec).toString() + " sec";
    pos += 4;
    return pos;
  }

  /// <summary>
  /// Time of ASTERIX Report Transmission
  ///
  /// Definition : Time of the transmission of the ASTERIX category 021 report in
  /// the form of elapsed time since last midnight, expressed as UTC.
  /// Format: Three-Octet fixed length data item.
  /// </summary>
  /// <param name="Time_of_day_sec">Time in int format for the map</param>
  /// <param name="Time_of_Asterix_Report_Transmission">Time in String format for tables</param>
  String Time_of_Asterix_Report_Transmission;
  int Time_of_day_sec;
  int Compute_Time_of_Asterix_Report_Transmission(List<String> message, int pos)
  {

    int str = this.lib.Binary2Int((message[pos]+ message[pos + 1]+ message[pos + 2]));

    double seconds = ((str) / 128);
    Time_of_day_sec = seconds.truncate();
    final duration = Duration(seconds: Time_of_day_sec);
    Time_of_Asterix_Report_Transmission = "${duration.inHours}:${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";

    pos += 3;
    return pos;
  }

  /// <summary>
  /// Data Item I021/080, Target Address
  ///
  /// Definition: Target address (emitter identifier) assigned uniquely to each target.
  /// Format: Three-octet fixed length Data Item.
  /// </summary>
  //TARGET ADDRESS
  String Target_address;
  int Compute_Target_Address(Uint8List messageInt, int pos)
  {
    Target_address = messageInt[pos].toRadixString(16).padLeft(2, "0")+ messageInt[pos+1].toRadixString(16).padLeft(2, "0")+messageInt[pos+2].toRadixString(16).padLeft(2, "0");
    pos += 3;
    return pos;
  }

  /// <summary>
  /// Data Item I021/090, Quality Indicators
  ///
  /// Definition: ADS-B quality indicators transmitted by a/c according to MOPS version.
  /// Format: Variable Length Data Item, comprising a primary subfield of oneoctet, followed by one-octet extensions as necessary.
  /// NOTE: Apart from the “PIC” item, all items are defined as per the respective link technology protocol version(“MOPS version”, see I021/210).
  /// </summary>

  String Quality_Indicators;
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

  int Compute_Quality_Indicators(List<String> message, int pos)
  {
    NUCr_NACv =(this.lib.Binary2Int(message[pos].substring(0, 3))).toString();
    NUCp_NIC = (this.lib.Binary2Int(message[pos].substring(3, 3+4))).toString();
    pos++;
    if (message[pos - 1][7] == "1")
    {

      NICbaro = (this.lib.Binary2Int(message[pos][0])).toString();
      SIL = (this.lib.Binary2Int(message[pos].substring(1, 3))).toString();
      NACp = (this.lib.Binary2Int(message[pos].substring(3, 7))).toString();
      pos++;
      if (message[pos - 1][7] == "1")
      {

        if (message[pos][2] == "0") { SILS = "Measured per flight-Hour"; }
        else { SILS = "Measured per sample"; }
        SDA = (this.lib.Binary2Int(message[pos].substring(3,5))).toString();
        GVA = (this.lib.Binary2Int(message[pos].substring(5,7))).toString();
        pos++;
        if (message[pos - 1][7] == "1")
        {

          PIC = this.lib.Binary2Int(message[pos].substring(0, 4));
          if (PIC == 0) { ICB = "No integrity(or > 20.0 NM)"; NUCp = "0"; NIC = "0"; }
          if (PIC == 1) { ICB = "< 20.0 NM"; NUCp = "1"; NIC = "1"; }
          if (PIC == 2) { ICB = "< 10.0 NM"; NUCp = "2"; NIC = "-"; }
          if (PIC == 3) { ICB = "< 8.0 NM"; NUCp = "-"; NIC = "2"; }
          if (PIC == 4) { ICB = "< 4.0 NM"; NUCp = "-"; NIC = "3"; }
          if (PIC == 5) { ICB = "< 2.0 NM"; NUCp = "3"; NIC = "4"; }
          if (PIC == 6) { ICB = "< 1.0 NM"; NUCp = "4"; NIC = "5"; }
          if (PIC == 7) { ICB = "< 0.6 NM"; NUCp = "-"; NIC = "6 (+ 1/1)"; }
          if (PIC == 8) { ICB = "< 0.5 NM"; NUCp = "5"; NIC = "6 (+ 0/0)"; }
          if (PIC == 9) { ICB = "< 0.3 NM"; NUCp = "-"; NIC = "6 (+ 0/1)"; }
          if (PIC == 10) { ICB = "< 0.2 NM"; NUCp = "6"; NIC = "7"; }
          if (PIC == 11) { ICB = "< 0.1 NM"; NUCp = "7"; NIC = "8"; }
          if (PIC == 12) { ICB = "< 0.04 NM"; NUCp = ""; NIC = "9"; }
          if (PIC == 13) { ICB = "< 0.013 NM"; NUCp = "8"; NIC = "10"; }
          if (PIC == 14) { ICB = "< 0.004 NM"; NUCp = "9"; NIC = "11"; }
          pos++;
        }
      }
    }
    return pos;
  }

  /// <summary>
  /// Data Item I021/110, Trajectory Intent
  ///
  /// Definition : Reports indicating the 4D intended trajectory of the aircraft.
  /// Format : Compound Data Item, comprising a primary subfield of one octet, followed by the indicated subfields.
  /// </summary>

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
  int Compute_Trajectory_Intent(List<String> message, int pos)
  {
    Trajectory_present = 1;
    if (message[pos][0] == "1") { subfield1 = true; }
    else { subfield1 = false; }
    if (message[pos][1] == "1") { subfield2 = true; }
    else { subfield2 = false; }
    if (subfield1 == true)
    {
      pos++;
      if (message[pos][0] == "0") { NAV = "Trajectory Intent Data is available for this aircraft"; }
      else { NAV = "Trajectory Intent Data is not available for this aircraft "; }
      if (message[pos][1] == "0") { NVB = "Trajectory Intent Data is valid"; }
      else { NVB = "Trajectory Intent Data is not valid"; }
    }
    if (subfield2 == true)
    {
      pos++;
      REP = this.lib.Binary2Int(message[pos]);
      TCA = List .filled(REP, "", growable: true);
      NC = List .filled(REP, "", growable: true);
      TCP = List .filled(REP, 0, growable: true);
      Altitude = List .filled(REP, "", growable: true);
      Latitude = List .filled(REP, "", growable: true);
      Longitude = List .filled(REP, "", growable: true);
      Point_Type = List .filled(REP, "", growable: true);
      TD = List .filled(REP, "", growable: true);
      TRA = List .filled(REP, "", growable: true);
      TOA = List .filled(REP, "", growable: true);
      TOV = List .filled(REP, "", growable: true);
      TTR = List .filled(REP, "", growable: true);
      pos++;

      for (int i = 0; i < REP; i++)
      {
        if (message[pos][0] == "0") { TCA[i] = "TCP number available"; }
        else { TCA[i] = "TCP number not available"; }
        if (message[pos][1] == "0") { NC[i] = "TCP compliance"; }
        else { NC[i] = "TCP non-compliance"; }
        TCP[i] = this.lib.Binary2Int(message[pos].substring(2, 8));
        pos++;
        Altitude[i] = (lib.TwoComplement2Decimal(message[pos]+ message[pos + 1]) * 10).toString() + " ft";
        pos += 2;
        Latitude[i] = (lib.TwoComplement2Decimal(message[pos]+ message[pos + 1]) * (180 / (8388608))).toString() + " deg";
        pos += 2;
        Longitude[i] = (lib.TwoComplement2Decimal(message[pos]+ message[pos + 1]) * (180 / (8388608))).toString() + " deg";
        pos += 2;
        int pt = this.lib.Binary2Int(message[pos].substring(0, 4));
        if (pt == 0) { Point_Type[i] = "Unknown"; }
        else if (pt == 1) { Point_Type[i] = "Fly by waypoint (LT) "; }
        else if (pt == 2) { Point_Type[i] = "Fly over waypoint (LT)"; }
        else if (pt == 3) { Point_Type[i] = "Hold pattern (LT)"; }
        else if (pt == 4) { Point_Type[i] = "Procedure hold (LT)"; }
        else if (pt == 5) { Point_Type[i] = "Procedure turn (LT)"; }
        else if (pt == 6) { Point_Type[i] = "RF leg (LT)"; }
        else if (pt == 7) { Point_Type[i] = "Top of climb (VT)"; }
        else if (pt == 8) { Point_Type[i] = "Top of descent (VT)"; }
        else if (pt == 9) { Point_Type[i] = "Start of level (VT)"; }
        else if (pt == 10) { Point_Type[i] = "Cross-over altitude (VT)"; }
        else { Point_Type[i] = "Transition altitude (VT)"; }
        String td = message[pos].substring(4,6);
        if (td == "00") { TD[i] = "N/A"; }
        else if (td == "01") { TD[i] = "Turn right"; }
        else if (td == "10") { TD[i] = "Turn left"; }
        else { TD[i] = "No turn"; }
        if (message[pos][6] == "0") { TRA[i] = "TTR not available"; }
        else { TRA[i] = "TTR available"; }
        if (message[pos][7] == "0") { TOA[i] = "TOV available"; }
        else { TOA[i] = "TOV not available"; }
        pos++;
        TOV[i] = (this.lib.Binary2Int(message[pos]+ message[pos + 1]+ message[pos + 2])).toString() + " sec";
        pos += 3;
        TTR[i] = (this.lib.Binary2Int(message[pos]+ message[pos + 1]) * 0.01).toString() + " Nm";
        pos += 2;
      }
    }
    return pos;
  }

  /// <summary>
  /// Data Item I021/130, Position in WGS-84 Co-ordinates
  ///
  /// Definition : Position in WGS-84 Co-ordinates.
  /// Format : Six-octet fixed length Data Item.
  /// </summary>
  /// <param name="Latitude_in_WGS_84">Latitude in Degrees minutes seconds that will show in the tables</param>
  /// <param name="Longitudee_in_WGS_84">Longitude in Degrees minutes seconds that will show in the tables</param>
  /// <param name="Latitude_in_WGS_84_map">Latitude in decimals used to draw markers on map</param>
  /// <param name="Latitude_in_WGS_84_map">Longiutde in decimals used to draw markers on map</param>

  String LatitudeWGS_84;
  String LongitudeWGS_84;
  double LatitudeWGS_84_map = -200;
  double LongitudeWGS_84_map = -200;
  int Compute_PositionWGS_84(List<String> messageOctets, int pos)
  {

    double Latitude = this.lib.TwoComplement2Decimal(messageOctets[pos]+ messageOctets[pos + 1]+ messageOctets[pos + 2]) * (0.00002145767);
    pos += 3;
    double Longitude = this.lib.TwoComplement2Decimal(messageOctets[pos]+ messageOctets[pos + 1]+ messageOctets[pos + 2]) * (0.00002145767);
    pos += 3;
    LatitudeWGS_84_map = (Latitude);
    LongitudeWGS_84_map = (Longitude);
    int Latdegres = Latitude.truncate();
    int Latmin = ((Latitude - Latdegres) * 60).truncate();
    double Latsec = (Latitude - (Latdegres + (Latmin / 60)))*3600;
    int Londegres = Longitude.truncate();
    int Lonmin = ((Longitude - Londegres) * 60).truncate();
    double Lonsec = (Longitude - (Londegres + (Lonmin / 60)))*3600;
    LatitudeWGS_84 = Latdegres.toString() + "º " + Latmin.toString() + "' " + Latsec.toString() + "''";
    LongitudeWGS_84 = Londegres.toString() + "º" + Lonmin.toString() + "' " + Lonsec.toString() + "''";
    return pos;
  }

  /// <summary>
  /// Data Item I021/131, High-Resolution Position in WGS-84 Co-ordinates
  ///
  /// Definition: Position in WGS-84 Co-ordinates in high resolution.
  /// Format: Eight-octet fixed length Data Item.
  /// </summary>
  String High_Resolution_LatitudeWGS_84;
  String High_Resolution_LongitudeWGS_84;
  int Compute_High_Resolution_PositionWGS_84(List<String> message, int pos)
  {
    double Latitude = this.lib.TwoComplement2Decimal(message[pos]+ message[pos + 1]+ message[pos + 2] + message[pos + 3]) * (0.000000167638063);
    pos += 4;
    double Longitude = this.lib.TwoComplement2Decimal(message[pos]+ message[pos + 1]+ message[pos + 2]) * (0.000000167638063);
    pos += 4;
    LatitudeWGS_84_map = (Latitude);
    LongitudeWGS_84_map = (Longitude);
    int Latdegres = Latitude.truncate();
    int Latmin = ((Latitude - Latdegres) * 60).truncate();
    double Latsec = (Latitude - (Latdegres + (Latmin / 60)))*3600;
    int Londegres = Longitude.truncate();
    int Lonmin = ((Longitude - Londegres) * 60).truncate();
    double Lonsec = (Longitude - (Londegres + (Lonmin / 60)))*3600;
    High_Resolution_LatitudeWGS_84 = Latdegres.toString() + "º " + Latmin.toString() + "' " + Latsec.toString() + "''";
    High_Resolution_LongitudeWGS_84 = Londegres.toString() + "º" + Lonmin.toString() + "' " + Lonsec.toString() + "''";
    return pos;
  }

  /// <summary>
  /// Data Item I021/132, Message Amplitude
  ///
  /// Definition : Amplitude, in dBm, of ADS-B messages received by the ground station, coded in two’s complement.
  /// Format : One-Octet fixed length data item.
  /// </summary>
  String Message_Amplitude;
  int Compute_Message_Amplitude(List<String> message, int pos)
  {
    Message_Amplitude = (lib.TwoComplement2Decimal(message[pos])).toString() + " dBm";
    pos++;
    return pos;
  }

  /// <summary>
  /// Data Item I021/140, Geometric Height
  ///
  /// Definition : Minimum height from a plane tangent to the earth’s ellipsoid,
  /// defined by WGS-84, in two’s complement form.
  /// Format : Two-Octet fixed length data item.
  /// </summary>
  String Geometric_Height;
  int Compute_Geometric_Height(List<String> message, int pos)
  {
    Geometric_Height = (lib.TwoComplement2Decimal(message[pos]+ message[pos + 1]) * 6.25).toString() + " ft"; pos += 2;
    return pos;
  }

  /// <summary>
  /// Data Item I021/145, Flight Level
  ///
  /// Definition: Flight Level from barometric measurements, not QNH corrected, in two’s complement form.
  /// Format: Two-Octet fixed length data item.
  /// </summary>
  String Flight_Level;
  int Compute_Flight_level(List<String> message, int pos)
  {
    Flight_Level = (lib.TwoComplement2Decimal((message[pos]+ message[pos + 1])) * (0.25)).toString() + " FL";
    pos += 2;
    return pos;
  }

  /// <summary>
  /// Data Item I021/146, Selected Altitude
  ///
  /// Definition : The Selected Altitude as provided by the avionics and
  /// corresponding either to the MCP/FCU Selected Altitude(the ATC
  /// cleared altitude entered by the flight crew into the avionics) or to
  /// the FMS Selected Altitude.
  /// Format: Two-Octet fixed length data item.
  /// </summary>

  String SAS;
  String Source;
  String Sel_Altitude;
  String Selected_Altitude;
  int Compute_Selected_Altitude(List<String> message, int pos)
  {
    String sou = message[pos].substring(1,3);
    if (sou == "00") { Source = "Unknown"; }
    else if (sou == "01") { Source = "Aircraft Altitude (Holding Altitude)"; }
    else if (sou == "10") { Source = "MCP/FCU Selected Altitude"; }
    else { Source = "FMS Selected Altitude"; }
    Sel_Altitude = (lib.TwoComplement2Decimal((message[pos]+ message[pos + 1]).substring(3, 16)) * 25).toString() + " ft";
    Selected_Altitude = "SA: " + (Sel_Altitude).toString();
    pos += 2;
    return pos;
  }

  /// <summary>
  /// Data Item I021/148, Final State Selected Altitude
  ///
  /// Definition : The vertical intent value that corresponds with the ATC cleared
  /// altitude, as derived from the Altitude Control Panel(MCP/FCU).
  /// Format: Two-Octet fixed length data item.
  /// </summary>
  ///
  String MV;
  String AH;
  String AM;
  String Final_State_Altitude;
  int Compute_Final_State_Selected_Altitude(List<String> message, int pos)
  {
    if (message[pos][0] == "0") { MV = "Not active or unknown"; }
    else { MV = "Active"; }
    if (message[pos][1] == "0") { AH = "Not active or unknown"; }
    else { AH = "Active"; }
    if (message[pos][2] == "0") { AM = "Not active or unknown"; }
    else { AM = "Active"; }
    Final_State_Altitude = (lib.TwoComplement2Decimal((message[pos]+ message[pos + 1]).substring(3, 16)) * 25).toString() + " ft";
    pos += 2;
    return pos;
  }

  /// <summary>
  /// Data Item I021/150, Air Speed
  ///
  /// Definition: Calculated Air Speed (Element of Air Vector).
  /// Format: Two-Octet fixed length data item.
  /// </summary>
  String Air_Speed;
  int Compute_Air_Speed(List<String> message, int pos)
  {
    if (message[pos][0] == "0") { Air_Speed = (this.lib.Binary2Int((message[pos]+ message[pos + 1]).toString().substring(1, 16)) * 0.00006103515).toString() + " NM/s"; }
    else { Air_Speed = (this.lib.Binary2Int((message[pos]+ message[pos + 1]).substring(1, 16)) * 0.001).toString() + " Mach"; }
    pos += 2;
    return pos;
  }

  /// <summary>
  /// Data Item I021/151 True Airspeed
  ///
  /// Definition : True Air Speed.
  /// Format : Two-Octet fixed length data item.
  /// </summary>
  String True_Air_Speed;
  int Compute_True_Air_Speed(List<String> message, int pos)
  {
    if (message[pos][0] == "0")
    {
      True_Air_Speed = (this.lib.Binary2Int((message[pos]+ message[pos + 1]).toString().substring(1, 16))).toString() + " Knots";
    }
    else { True_Air_Speed = "Value exceeds defined rage"; }
    pos += 2;
    return pos;
  }


  /// <summary>
  /// Data Item I021/152, Magnetic Heading
  ///
  /// Definition: Magnetic Heading (Element of Air Vector).
  /// Format: Two-Octet fixed length data item.
  /// </summary>

  //MAGNETIC HEADING
  String Magnetic_Heading;
  int Compute_Magnetic_Heading(List<String> message, int pos)
  {
    Magnetic_Heading = (this.lib.Binary2Int((message[pos]+message[pos])) * (360 / (65536))).toString() + "º";
    pos += 2;
    return pos;
  }

  /// <summary>
  /// Data Item I021/155, Barometric Vertical Rate
  ///
  /// Definition: Barometric Vertical Rate, in two’s complement form.
  /// Format: Two-Octet fixed length data item.
  /// </summary>
  String Barometric_Vertical_Rate;
  int Compute_Barometric_Vertical_Rate(List<String> message, int pos)
  {
    if (message[pos][0] == "0")
    {
      Barometric_Vertical_Rate = (lib.TwoComplement2Decimal((message[pos]+ message[pos + 1]).substring(1, 16)) * 6.25).toString() + " feet/minute";
    }
    else { Barometric_Vertical_Rate = "Value exceeds defined rage"; }
    pos += 2;
    return pos;
  }

  /// <summary>
  /// Data Item I021/157, Geometric Vertical Rate
  ///
  /// Definition: Geometric Vertical Rate, in two’s complement form, with reference to WGS-84.
  /// Format: Two-Octet fixed length data item.
  /// </summary>
  String Geometric_Vertical_Rate;
  int Compute_Geometric_Vertical_Rate(List<String> message, int pos)
  {
    if (message[pos][0] == "0")
    {
      Geometric_Vertical_Rate = (lib.TwoComplement2Decimal((message[pos]+message[pos + 1]).substring(1, 16)) * 6.25).toString() + " feet/minute";
    }
    else { Geometric_Vertical_Rate = "Value exceeds defined rage"; }
    pos += 2;
    return pos;
  }

  /// <summary>
  /// Data Item I021/160, Airborne Ground Vector
  ///
  /// Definition : Ground Speed and Track Angle elements of Airborne Ground Vector.
  /// Format : Four-Octet fixed length data item.
  /// </summary>
  String Ground_Speed;
  String Track_Angle;
  String Ground_vector;
  int Compute_Airborne_Ground_Vector(List<String> message, int pos)
  {
    if (message[pos][0] == "0")
    {
      Ground_Speed = (this.lib.Binary2Int((message[pos]+ message[pos + 1]).substring(1, 16)) * 0.21972654).toString() + "Knts";
      // double meters =
      Track_Angle = (this.lib.Binary2Int((message[pos + 2]+ message[pos + 3]).substring(0, 16)) * 0.00549316406).toString();
      Ground_vector = "GS: " + Ground_Speed + ", T.A: " + (Track_Angle) + "º";
    }
    else { Ground_vector = "Value exceeds defined rage"; }
    pos += 4;
    return pos;
  }

  /// <summary>
  /// Data Item I021/161, Track Number
  ///
  /// Definition: An integer value representing a unique reference to a track record within a particular track file.
  /// Format: Two-octet fixed length Data Item.
  /// </summary>
  String Track_Number;
  int Compute_Track_Number(List<String> message, int pos)
  {
    Track_Number = (this.lib.Binary2Int((message[pos]+ message[pos + 1]).substring(4, 16))).toString();
    pos += 2;
    return pos;
  }

  /// <summary>
  /// Data Item I021/165, Track Angle Rate
  ///
  /// Definition : Rate of Turn, in two’s complement form.
  /// Format : 2-Byte Fixed length data item.
  /// </summary>
  String Track_Angle_Rate;
  int Compute_Track_Angle_Rate(List<String> message, int pos)
  {
    Track_Angle_Rate = (this.lib.Binary2Int((message[pos]+ message[pos]).substring(6, 16)) * 0.03125).toString() + " º/s";
    pos += 2;
    return pos;
  }

  /// <summary>
  /// Data Item I021/170, Target Identification
  ///
  /// Definition: Target (aircraft or vehicle) identification in 8 characters, as reported by the target.
  /// Format: Six-octet fixed length Data Item.
  /// </summary>
  ///
  String Target_Identification;
  int Compute_Target_Identification(List<String> message, int pos)
  {
    String Identification = "";
    String octets = (message[pos]+ message[pos + 1]+ message[pos + 2]+ message[pos + 3]+ message[pos + 4]+ message[pos + 5]);
    for (int i = 0; i < 8; i++) { Identification+=(lib.computeChar(octets.substring(i * 6, i * 6+6))); }
    String tar = Identification.toString();
    if (tar.length > 1) { Target_Identification = tar; }
    return pos + 6;
  }

  /// <summary>
  /// Data Item I021/200, Target Status
  ///
  /// Definition : Status of the target
  /// Format : One-octet fixed length Data Item
  /// </summary>
  String ICF;
  String LNAV;
  String PS;
  String SS;
  int Compute_Target_Status(List<String> message, int pos)
  {
    if (message[pos][0] == "0") { ICF = "No intent change active"; }
    else { ICF = "Intent change flag raised"; }
    if (message[pos][1] == "0") { LNAV = "LNAV Mode engaged"; }
    else { LNAV = "LNAV Mode not engaged"; }
    int ps = this.lib.Binary2Int(message[pos].substring(3, 6));
    if (ps == 0) { PS = "No emergency / not reported"; }
    else if (ps == 1) { PS = "General emergency"; }
    else if (ps == 2) { PS = "Lifeguard / medical emergency"; }
    else if (ps == 3) { PS = "Minimum fuel"; }
    else if (ps == 4) { PS = "No communications"; }
    else if (ps == 5) { PS = "Unlawful interference"; }
    else { PS = "'Downed' Aircraft "; }
    int ss = this.lib.Binary2Int(message[pos].substring(6,8));
    if (ss == 0) { SS = "No condition reported"; }
    else if (ss == 1) { SS = "Permanent Alert (Emergency condition)"; }
    else if (ss == 2) { SS = "Temporary Alert (change in Mode 3/A Code other than emergency)"; }
    else { SS = "SPI set"; }
    pos++;
    return pos;
  }

  /// <summary>
  /// Data Item I021/210, MOPS Version
  ///
  /// Definition: Identification of the MOPS version used by a/c to supply ADS-B information.
  /// Format: One-octet fixed length Data Item
  /// </summary>

  String VNS;
  String LTT;
  String MOPS;
  int Compute_MOPS_Version(List<String> message, int pos)
  {
    if (message[pos][1] == "0") { VNS = "The MOPS Version is supported by the GS"; }
    else { VNS = "The MOPS Version is not supported by the GS"; }
    int ltt = this.lib.Binary2Int(message[pos].substring(5, 8));
    if (ltt == 0) { LTT = "Other"; }
    else if (ltt == 1) { LTT = "UAT"; }
    else if (ltt == 2)
    {
      int vn = this.lib.Binary2Int(message[pos].substring(2, 5));
      String VN = "";
      if (vn == 0) { VN = "ED102/DO-260"; }
      if (vn == 1) { VN = "DO-260A"; }
      if (vn == 2) { VN = "ED102A/DO-260B"; }
      LTT = "Version Number: " + VN;
    }
    else if (ltt == 3) { LTT = "VDL 4"; }
    else { LTT = "Not assigned"; }
    MOPS = LTT;
    pos++;
    return pos;
  }


  /// <summary>
  /// Data Item I021/220, Met Information
  ///
  /// Definition : Meteorological information.
  /// Format : Compound data item consisting of a one byte primary sub-field,
  /// followed by up to four fixed length data fields.
  /// </summary>
  int MET_present = 0;
  String Wind_Speed;
  String Wind_Direction;
  String Temperature;
  String Turbulence;
  int Compute_Met_Information(List<String> message, int pos)
  {
    MET_present = 1;
    int posin = pos;
    int posfin = pos++;
    if (message[posin][0] == "1") { Wind_Speed = (this.lib.Binary2Int((message[posfin]+ message[posfin]))).toString() + " Knots"; posfin += 2; }
    if (message[posin][1] == "1") { Wind_Direction = (this.lib.Binary2Int((message[posfin]+ message[posfin]))).toString() + " degrees"; posfin += 2; }
    if (message[posin][2] == "1") { Temperature = (this.lib.Binary2Int((message[posfin]+ message[posfin])) * 0.25).toString() + " ºC"; posfin += 2; }
    if (message[posin][3] == "1") { Turbulence = (this.lib.Binary2Int((message[posfin]+ message[posfin]))).toString() + " Turbulence"; posfin += 2; }
    return posfin;
  }


  /// <summary>
  /// Data Item I021/230, Roll Angle
  ///
  /// Definition : The roll angle, in two’s complement form, of an aircraft executing a turn.
  /// Format: A two byte fixed length data item.
  /// </summary>

  String Roll_Angle;
  int Compute_Roll_Angle(List<String> message, int pos)
  {
    Roll_Angle = (lib.TwoComplement2Decimal((message[pos]+ message[pos])) * 0.01).toString() + "º";
    return pos++;
  }

  /// <summary>
  /// Data Item I021/250, Mode S MB Data
  ///
  /// Definition: Mode S Comm B data as extracted from the aircraft transponder.
  /// Format: Repetitive Data Item starting with a one-octet Field Repetition
  /// Indicator(REP) followed by at least one BDS message
  /// </summary>

  List<String> MB_Data;
  List<String> BDS1;
  List<String> BDS2;
  int modeS_rep;
  int Compute_Mode_S_MB_DATA(List<String> message, int pos)
  {
    int modeS_rep = this.lib.Binary2Int(message[pos]);
    if (modeS_rep < 0) { MB_Data = List .filled(modeS_rep, "", growable: false); BDS1 = List .filled(modeS_rep, "", growable: false); BDS2 = List .filled(modeS_rep, "", growable: false); }
    pos++;
    for (int i = 0; i < modeS_rep; i++)
    {
      MB_Data[i] = (message[pos]+ message[pos + 1]+ message[pos + 2]+ message[pos + 3]+ message[pos + 4]+ message[pos + 5]+ message[pos + 6]);
      BDS1[1] = message[pos + 7].substring(0, 4);
      BDS2[1] = message[pos + 7].substring(4, 8);
      pos += 8;
    }
    return pos;
  }

  /// <summary>
  /// Data Item I021/260, ACAS Resolution Advisory Report
  ///
  /// Definition: Currently active Resolution Advisory (RA), if any, generated by the
  /// ACAS associated with the transponder transmitting the RA
  /// message and threat identity data.
  /// Format: Seven-octet fixed length Data Item.
  /// </summary>

  String TYP;
  String STYP;
  String ARA;
  String RAC;
  String RAT;
  String MTE;
  String TTI;
  String TID;
  int Compute_ACAS_Resolution_Advisory_Report(List<String> message, int pos)
  {
    String messg = (message[pos]+ message[pos + 1]+ message[pos + 2]+ message[pos + 3]+ message[pos + 4]+ message[pos + 5]+ message[pos + 6]);
    TYP = messg.substring(0, 5);
    STYP = messg.substring(5, 8);
    ARA = messg.substring(8, 22);
    RAC = messg.substring(22, 26);
    RAT = messg.substring(26, 27);
    MTE = messg.substring(27, 28);
    TTI = messg.substring(28,30);
    TID = messg.substring(30, 56);
    pos += 7;
    return pos;
  }


  /// <summary>
  /// Data Item I021/271, Surface Capabilities and Characteristics
  ///
  /// Definition : Operational capabilities of the aircraft while on the ground.
  /// Format : Variable Length Data Item, comprising a primary subfield of one-octet,
  /// followed by an one-octet extensions if necessary.
  /// </summary>
  ///
  String POA;
  String CDTIS;
  String B2_low;
  String RAS;
  String IDENT;
  String LengthandWidth;
  int Compute_Surface_Capabiliteies_and_Characteristics(List<String> message, int pos)
  {

    if (message[pos][2] == "0") { POA = "Position transmitted is not ADS-B position reference point"; }
    else { POA = "Position transmitted is the ADS-B position reference point"; }
    if (message[pos][3] == "0") { CDTIS = "Cockpit Display of Traffic Information not operational"; }
    else { CDTIS = "Cockpit Display of Traffic Information operational"; }
    if (message[pos][4] == "0") { B2_low = "Class B2 transmit power ≥ 70 Watts"; }
    else { B2_low = "Class B2 transmit power < 70 Watts"; }
    if (message[pos][5] == "0") { RAS = "Aircraft not receiving ATC-services"; }
    else { RAS = "Aircraft receiving ATC services"; }
    if (message[pos][6] == "0") { IDENT = "IDENT switch not active"; }
    else { IDENT = "IDENT switch active"; }
    if (message[pos][7] == "1")
    {
      pos++;
      int LaW = this.lib.Binary2Int(message[pos].substring(4,8));
      if (LaW == 0) { LengthandWidth = "Lenght < 15  and Width < 11.5"; }
      if (LaW == 1) { LengthandWidth = "Lenght < 15  and Width < 23"; }
      if (LaW == 2) { LengthandWidth = "Lenght < 25  and Width < 28.5"; }
      if (LaW == 3) { LengthandWidth = "Lenght < 25  and Width < 34"; }
      if (LaW == 4) { LengthandWidth = "Lenght < 35  and Width < 33"; }
      if (LaW == 5) { LengthandWidth = "Lenght < 35  and Width < 38"; }
      if (LaW == 6) { LengthandWidth = "Lenght < 45  and Width < 39.5"; }
      if (LaW == 7) { LengthandWidth = "Lenght < 45  and Width < 45"; }
      if (LaW == 8) { LengthandWidth = "Lenght < 55  and Width < 45"; }
      if (LaW == 9) { LengthandWidth = "Lenght < 55  and Width < 52"; }
      if (LaW == 10) { LengthandWidth = "Lenght < 65  and Width < 59.5"; }
      if (LaW == 11) { LengthandWidth = "Lenght < 65  and Width < 67"; }
      if (LaW == 12) { LengthandWidth = "Lenght < 75  and Width < 72.5"; }
      if (LaW == 13) { LengthandWidth = "Lenght < 75  and Width < 80"; }
      if (LaW == 14) { LengthandWidth = "Lenght < 85  and Width < 80"; }
      if (LaW == 15) { LengthandWidth = "Lenght > 85  and Width > 80"; }
    }
    pos++;
    return pos;
  }


  /// <summary>
  /// Data Item I021/295, Data Ages
  ///
  /// Definition : Ages of the data provided.
  /// Format : Compound Data Item, comprising a primary subfield of up to five
  /// octets, followed by the indicated subfields.
  /// </summary>

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
  int Compute_Data_Age(List<String> message, int pos)
  {
    Data_Ages_present = 1;
    int posin = pos;
    if (message[pos][7] == "1")
    {
      pos++;
      if (message[pos][7] == "1")
      {
        pos++;
        if (message[pos][7] == "1")
        {
          pos++;
        }
      }
    }
    pos++;
    if (message[posin][0] == "1") { AOS = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
    if (message[posin][1] == "1") { TRD = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
    if (message[posin][2] == "1") { M3A = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
    if (message[posin][3] == "1") { QI = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
    if (message[posin][4] == "1") { TI = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
    if (message[posin][5] == "1") { MAM = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
    if (message[posin][6] == "1") { GH = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
    if (message[posin][7] == "1")
    {
      if (message[posin + 1][0] == "1") { FL = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 1][1] == "1") { ISA = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 1][2] == "1") { FSA = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 1][3] == "1") { AS = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 1][4] == "1") { TAS = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 1][5] == "1") { MH = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 1][6] == "1") { BVR = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
    }
    if (message[posin + 1][7] == "1")
    {
      if (message[posin + 2][0] == "1") { GVR = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 2][1] == "1") { GV = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 2][2] == "1") { TAR = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 2][3] == "1") { TI_DataAge = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 2][4] == "1") { TS_DataAge = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 2][5] == "1") { MET = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 2][6] == "1") { ROA = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
    }
    if (message[posin + 2][7] == "1")
    {
      if (message[posin + 3][0] == "1") { ARA_DataAge = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
      if (message[posin + 3][1] == "1") { SCC = (this.lib.Binary2Double(message[pos]) * 0.1).toString() + " s"; pos++; }
    }
    return pos;
  }


  /// <summary>
  /// Data Item I021/400, Receiver ID
  ///
  /// Definition : Designator of Ground Station in Distributed System.
  /// Format : One-octet fixed length Data Item.
  /// </summary>
  //RECEIVER ID
  String Receiver_ID;
  int Compute_Receiver_ID(List<String> message, int pos)
  {
    Receiver_ID = this.lib.Binary2Int(message[pos]).toString();
    pos++;
    return pos;
  }
}