import 'dart:core';
import 'dart:typed_data';

import 'package:decereix/Helpers/cat10Helper.dart';
import 'package:decereix/Helpers/cat21Helper.dart';
import 'package:decereix/Helpers/helpDecode.dart';
import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/models/cat10.dart';
import 'package:decereix/models/cat21.dart';
import 'package:decereix/models/catall.dart';
import 'package:decereix/models/trajectories.dart';
import 'package:decereix/models/transferCat.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:worker_manager/worker_manager.dart';
import 'dart:io'; // for exit();
import 'dart:async';
import 'dart:isolate';
class LoadfileScreen extends StatefulWidget {
  const LoadfileScreen({Key key}) : super(key: key);

  @override
  _LoadfileScreenState createState() => _LoadfileScreenState();
}

class _LoadfileScreenState extends State<LoadfileScreen> {

  /// Reads Asterisk file *ast in binary format, optimized for Multithreading operation
  static Future<Map<String, dynamic>> loadAsterix(Map<String, dynamic> mapVal) async {
    List<CAT10> cat10All = [];
    List<CAT21> cat21All = [];
    List<CATALL> catAll = [];
    try {
      Uint8List fileBytes = mapVal["fileBytes"];
      int firstTime = mapVal["firstTime"];
      mapVal = {};
      /// Raw Integer to Dart Binary String ex. 02 = "00000010"//
      var fileBinary =
          fileBytes.map((i) => i.toRadixString(2).padLeft(8, "0")).toList();
      // Go over all of the packets and store them in a separate list of lists
      /// First Octet equals Category [Cat10, Cat21v2.1]
      /// 2nd*256 + 3rd Octet = Length in Bytes
      int messageLength; /// 2nd*256 + 3rd Octet
      List<List<String>> messagesBinary = [];
      /// Store messages from the fileBytes into packet size Blocks using messageLength
      int endPointer = messageLength;
      int initialTime = 86400;
      int endTime = -1;
      for (int currPointer = 0;
          (currPointer + 1) < fileBytes.length;
          currPointer += messageLength) {
        messageLength =
            (fileBytes[currPointer + 1] * 256) + fileBytes[currPointer + 2];
        endPointer = currPointer + messageLength; // 0+31 = 31
        messagesBinary.add(fileBinary.sublist(currPointer, endPointer));
      }
      fileBinary = null;
      fileBytes = null;

      /// [Decoding] Binary to Human Readable UTF-8
      /// No separate function due to [Dart] inefficiency
      HelpDecode helpDecode = new HelpDecode();
      CAT10Helper cat10helper = new CAT10Helper();
      CAT21Helper cat21helper = new CAT21Helper();
      CAT10 cat10;
      CAT21 cat21;
      // Messages separated --> Now we have to convert them according to CAT 10 or CAT 21
      for (int k = 0; k < messagesBinary.length; k++) {
        // For each message we are gonna convert it properly
        if (messagesBinary[k][0] == "00001010") {
          cat10 = new CAT10(helpDecode, cat10helper, k, messagesBinary[k]);
          cat10All.add(cat10);
          catAll.add(new CATALL.fromCat10(cat10, firstTime));
          if(cat10.TimeOfDayInSeconds!=null) {
            if (cat10.TimeOfDayInSeconds < initialTime &&
                cat10.TimeOfDayInSeconds > -1) {
              initialTime = cat10.TimeOfDayInSeconds;
            }
            if (endTime < cat10.TimeOfDayInSeconds) {
              endTime = cat10.TimeOfDayInSeconds;
            }
          }
        } else if (messagesBinary[k][0] == "00010101") {
          cat21 = new CAT21(helpDecode, cat21helper, k, messagesBinary[k]);
          cat21All.add(cat21);
          catAll.add(new CATALL.fromCat21(cat21, firstTime));
          if(cat21.TimeOfDayInSeconds!=null) {
            if (cat21.TimeOfDayInSeconds < initialTime &&
                cat21.TimeOfDayInSeconds > -1) {
              initialTime = cat21.TimeOfDayInSeconds;
            }
            if (endTime < cat21.TimeOfDayInSeconds) {
              endTime = cat21.TimeOfDayInSeconds;
            }
          }
        }
      }
      /// Everything in same function, faster computation
      Map<String, dynamic> transferMap = {};
      /// [Trajectories] calculated here and not separated due to inefficiency in dart///
      List<Trajectories> smrTrajectories = [];
      List<Trajectories> mlatTrajectories = [];
      List<Trajectories> adsbTrajectories = [];
      int i = 0;
      bool check = false;
      catAll.forEach((message) {
        check = false;
        check = ((message.Latitude_in_WGS_84_map != -200) && (message.Longitude_in_WGS_84_map != -200)) && (message.Time_Of_day!=null||message.List_Time_Of_Day!=null) && (message.Target_Identification!=null||message.Target_Address!=null||message.Track_number!=null);
        if (check) {
          if (message.DetectionMode == "SMR") {
            if (message.Target_Identification != null) {
              bool isNotFound = true;
              for (int k = 0; k < smrTrajectories.length; k++) {
                if (smrTrajectories[k].Target_Identification ==
                    message.Target_Identification) {
                  smrTrajectories[k].AddPoint(message.Latitude_in_WGS_84_map,
                      message.Longitude_in_WGS_84_map, message.Time_Of_day);
                  isNotFound = false;
                }
              }
              if (isNotFound) {
                Trajectories trajectory = new Trajectories(
                    message.Target_Identification,
                    message.Time_Of_day,
                    message.Latitude_in_WGS_84_map,
                    message.Longitude_in_WGS_84_map,
                    message.type,
                    message.Target_Address,
                    message.DetectionMode,
                    message.CAT,
                    message.SAC,
                    message.SIC,
                    message.Track_number);
                smrTrajectories.add(trajectory);
              }
            }
            else if (message.Target_Address != null) {
              bool isNotFound = true;
              for (int k = 0; k < smrTrajectories.length; k++) {
                if (smrTrajectories[k].Target_Address ==
                    message.Target_Address) {
                  smrTrajectories[k].AddPoint(message.Latitude_in_WGS_84_map,
                      message.Longitude_in_WGS_84_map, message.Time_Of_day);
                  isNotFound = false;
                }
              }
              if (isNotFound) {
                Trajectories trajectory = new Trajectories(
                    message.Target_Identification,
                    message.Time_Of_day,
                    message.Latitude_in_WGS_84_map,
                    message.Longitude_in_WGS_84_map,
                    message.type,
                    message.Target_Address,
                    message.DetectionMode,
                    message.CAT,
                    message.SAC,
                    message.SIC,
                    message.Track_number);
                smrTrajectories.add(trajectory);
              }
            }
            else if (message.Track_number != null) {
              bool isNotFound = true;
              for (int k = 0; k < smrTrajectories.length; k++) {
                if (smrTrajectories[k].Track_number == message.Track_number) {
                  smrTrajectories[k].AddPoint(message.Latitude_in_WGS_84_map,
                      message.Longitude_in_WGS_84_map, message.Time_Of_day);
                  isNotFound = false;
                }
              }
              if (isNotFound) {
                Trajectories trajectory = new Trajectories(
                    message.Target_Identification,
                    message.Time_Of_day,
                    message.Latitude_in_WGS_84_map,
                    message.Longitude_in_WGS_84_map,
                    message.type,
                    message.Target_Address,
                    message.DetectionMode,
                    message.CAT,
                    message.SAC,
                    message.SIC,
                    message.Track_number);
                smrTrajectories.add(trajectory);
              }
            }
          }
          else if (message.DetectionMode == "MLAT") {
            if (message.Target_Identification != null) {
              bool isNotFound = true;
              for (int k = 0; k < mlatTrajectories.length; k++) {
                if (mlatTrajectories[k].Target_Identification ==
                    message.Target_Identification) {
                  mlatTrajectories[k].AddPoint(message.Latitude_in_WGS_84_map,
                      message.Longitude_in_WGS_84_map, message.Time_Of_day);
                  isNotFound = false;
                }
              }
              if (isNotFound) {
                Trajectories trajectory = new Trajectories(
                    message.Target_Identification,
                    message.Time_Of_day,
                    message.Latitude_in_WGS_84_map,
                    message.Longitude_in_WGS_84_map,
                    message.type,
                    message.Target_Address,
                    message.DetectionMode,
                    message.CAT,
                    message.SAC,
                    message.SIC,
                    message.Track_number);
                mlatTrajectories.add(trajectory);
              }
            }
            else if (message.Target_Address != null) {
              bool isNotFound = true;
              for (int k = 0; k < mlatTrajectories.length; k++) {
                if (mlatTrajectories[k].Target_Address ==
                    message.Target_Address) {
                  mlatTrajectories[k].AddPoint(message.Latitude_in_WGS_84_map,
                      message.Longitude_in_WGS_84_map, message.Time_Of_day);
                  isNotFound = false;
                }
              }
              if (isNotFound) {
                Trajectories trajectory = new Trajectories(
                    message.Target_Identification,
                    message.Time_Of_day,
                    message.Latitude_in_WGS_84_map,
                    message.Longitude_in_WGS_84_map,
                    message.type,
                    message.Target_Address,
                    message.DetectionMode,
                    message.CAT,
                    message.SAC,
                    message.SIC,
                    message.Track_number);
                mlatTrajectories.add(trajectory);
              }
            }
            else if (message.Track_number != null) {
              bool isNotFound = true;
              for (int k = 0; k < mlatTrajectories.length; k++) {
                if (mlatTrajectories[k].Track_number == message.Track_number) {
                  mlatTrajectories[k].AddPoint(message.Latitude_in_WGS_84_map,
                      message.Longitude_in_WGS_84_map, message.Time_Of_day);
                  isNotFound = false;
                }
              }
              if (isNotFound) {
                Trajectories trajectory = new Trajectories(
                    message.Target_Identification,
                    message.Time_Of_day,
                    message.Latitude_in_WGS_84_map,
                    message.Longitude_in_WGS_84_map,
                    message.type,
                    message.Target_Address,
                    message.DetectionMode,
                    message.CAT,
                    message.SAC,
                    message.SIC,
                    message.Track_number);
                mlatTrajectories.add(trajectory);
              }
            }
          }
          else if (message.DetectionMode == "ADSB") {
            if (message.Target_Identification != null) {
              bool isNotFound = true;
              for (int k = 0; k < adsbTrajectories.length; k++) {
                if (adsbTrajectories[k].Target_Identification ==
                    message.Target_Identification) {
                  adsbTrajectories[k].AddPoint(message.Latitude_in_WGS_84_map,
                      message.Longitude_in_WGS_84_map, message.Time_Of_day);
                  isNotFound = false;
                }
              }
              if (isNotFound) {
                Trajectories trajectory = new Trajectories(
                    message.Target_Identification,
                    message.Time_Of_day,
                    message.Latitude_in_WGS_84_map,
                    message.Longitude_in_WGS_84_map,
                    message.type,
                    message.Target_Address,
                    message.DetectionMode,
                    message.CAT,
                    message.SAC,
                    message.SIC,
                    message.Track_number);
                adsbTrajectories.add(trajectory);
              }
            }
            else if (message.Target_Address != null) {
              bool isNotFound = true;
              for (int k = 0; k < adsbTrajectories.length; k++) {
                if (adsbTrajectories[k].Target_Address ==
                    message.Target_Address) {
                  adsbTrajectories[k].AddPoint(message.Latitude_in_WGS_84_map,
                      message.Longitude_in_WGS_84_map, message.Time_Of_day);
                  isNotFound = false;
                }
              }
              if (isNotFound) {
                Trajectories trajectory = new Trajectories(
                    message.Target_Identification,
                    message.Time_Of_day,
                    message.Latitude_in_WGS_84_map,
                    message.Longitude_in_WGS_84_map,
                    message.type,
                    message.Target_Address,
                    message.DetectionMode,
                    message.CAT,
                    message.SAC,
                    message.SIC,
                    message.Track_number);
                adsbTrajectories.add(trajectory);
              }
            }
            else if (message.Track_number != null) {
              bool isNotFound = true;
              for (int k = 0; k < adsbTrajectories.length; k++) {
                if (adsbTrajectories[k].Track_number == message.Track_number) {
                  adsbTrajectories[k].AddPoint(message.Latitude_in_WGS_84_map,
                      message.Longitude_in_WGS_84_map, message.Time_Of_day);
                  isNotFound = false;
                }
              }
              if (isNotFound) {
                Trajectories trajectory = new Trajectories(
                    message.Target_Identification,
                    message.Time_Of_day,
                    message.Latitude_in_WGS_84_map,
                    message.Longitude_in_WGS_84_map,
                    message.type,
                    message.Target_Address,
                    message.DetectionMode,
                    message.CAT,
                    message.SAC,
                    message.SIC,
                    message.Track_number);
                adsbTrajectories.add(trajectory);
              }
            }
          }
        }
      });
      transferMap['initialTime'] = initialTime;
      transferMap['endTime'] = endTime;
      transferMap['cat10All'] = cat10All;
      transferMap['cat21All'] = cat21All;
      transferMap['catAll'] = catAll;
      transferMap['smrTrajectories'] = smrTrajectories;
      transferMap['mlatTrajectories'] = mlatTrajectories;
      transferMap['adsbTrajectories'] = adsbTrajectories;
      transferMap['status'] = true;
      // Cleaning up, for faster data retrieval before exiting the thread
      cat21All = null; cat10All = null;
      smrTrajectories = null; mlatTrajectories = null; adsbTrajectories = null; catAll = null;
      // Return all of the computation both Trajectories and Cat packets
      return transferMap;
    } catch (e) {
      // Debug Print if any error occurs during the execution of computation
      debugPrint("LoadFileError:" + e.toString());
      Map<String, dynamic> transferMap = {};
      transferMap['status'] = false;
      return transferMap;
    }
  }

  @override
  Widget build(BuildContext context) {
    CatProvider _catProvider = Provider.of<CatProvider>(context, listen: false);
    loadFileAsync() async {
      try {
        FilePickerCross myFile = await FilePickerCross.importFromStorage(fileExtension: 'ast');
        // After picking file --> Read the file in Hex
        //---------------------------------------------------//

        if (myFile != null) {
          Map<String, dynamic> map = {};
          map['fileBytes'] = myFile.toUint8List();
          map['firstTime'] = _catProvider.firstTime;
          //-------------------------------- compute(loadAsterix, map). ---------//
          /*final result = */ Executor().execute(arg1: map, fun1: loadAsterix).then((resultTransfer) {
           map = null;
            myFile = null;
            bool status = resultTransfer['status'];
            if (status) {
              _catProvider.firstTime = resultTransfer['initialTime'];
              _catProvider.endTime = resultTransfer['endTime'];
              _catProvider.cat10All = resultTransfer['cat10All'];
              _catProvider.cat21All = resultTransfer['cat21All'];
              _catProvider.catAll = resultTransfer['catAll'];
              _catProvider.smrTrajectories = resultTransfer['smrTrajectories'];
              _catProvider.mlatTrajectories = resultTransfer['mlatTrajectories'];
              _catProvider.adsbTrajectories = resultTransfer['adsbTrajectories'];
              resultTransfer = null;
            }
            EasyLoading.dismiss().then((value) => toast('File Loaded Successfully!'),);
          }).whenComplete(() {});
        }
      } catch (e) {
        EasyLoading.dismiss();
        debugPrint("loadFile Error");
        toast('File could not be Loaded!');
        }
    }

    return Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    iconSize: 96,
                    icon: const Icon(Icons.find_in_page),
                    tooltip: 'Load Asterix File',
                    onPressed: () {
                      EasyLoading.show(
                        status: 'loading...',
                        maskType: EasyLoadingMaskType.black,
                      ).then((value) {
                        loadFileAsync();
                      });
                    }),
                Text("Load File"),
              ],
            ),
          ),
        ));
  }
}
