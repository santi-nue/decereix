import 'dart:typed_data';
import 'package:decereix/Helpers/cat10Helper.dart';
import 'package:decereix/Helpers/cat21Helper.dart';
import 'package:decereix/Helpers/helpDecode.dart';
import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/models/cat10.dart';
import 'package:decereix/models/cat21.dart';
import 'package:decereix/models/catall.dart';
import 'package:decereix/models/transferCat.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:worker_manager/worker_manager.dart';

class LoadfileScreen extends StatefulWidget {
  const LoadfileScreen({Key key}) : super(key: key);

  @override
  _LoadfileScreenState createState() => _LoadfileScreenState();
}

class _LoadfileScreenState extends State<LoadfileScreen> {
  // Use Multithreading to read and decode the file,
  static Future<TransferCat> loadAsterix(Map<String, dynamic> mapVal) {
    /*Map<String, dynamic> resultMap = {};*/
    List<CAT10> cat10All = [];
    List<CAT21> cat21All = [];
    List<CATALL> catAll = [];
    try {
      Uint8List fileBytes = mapVal["fileBytes"];
      int firstTime = mapVal["firstTime"];
      mapVal = null;
      //-------------------RAW File to parse it in RAM-------------------//
      List<String> fileBinary =
      new List<String>.filled(fileBytes.length, "", growable: false);
      for (int i = 0; i < fileBytes.length; i++) {
        fileBinary[i] = fileBytes[i].toRadixString(2).padLeft(8, "0");
      }
      // Go over all of the packets and store them in a separate list of lists
      // First Octet Category

      // 2nd*256 + 3rd Octet = Length in Bytes
      int messageLength; // 2nd*256 + 3rd Octet
      List<List<String>> messagesBinary = [];
      // Also store as binary messages[currentMsg][Field].toRadixString(2).padLeft(8, "0")
      // Store messages from the fileBytes into packet size Blocks using messageLength
      int endPointer = messageLength;

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

      ///---------------------Binary to Human -------------------///
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
          /*messages[k]=null;*/
        } else if (messagesBinary[k][0] == "00010101") {
          cat21 = new CAT21(helpDecode, cat21helper, k, messagesBinary[k]);
          cat21All.add(cat21);
          catAll.add(new CATALL.fromCat21(cat21, firstTime));
          /*messages[k]=null;*/
        }
      }
      return Future.value(
          new TransferCat.fromCats(cat10All, cat21All, catAll, true));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(new TransferCat.fromCats([], [], [], false));
    }
  }

  @override
  Widget build(BuildContext context) {
    CatProvider _catProvider = Provider.of<CatProvider>(context, listen: false);

    loadFileAsync() async {
      try {
        FilePickerCross myFile =
            await FilePickerCross.importFromStorage(fileExtension: 'ast');
        // After picking file --> Read the file in Hex
        if (myFile != null) {
          Map<String, dynamic> map = {};
          map['fileBytes'] = myFile.toUint8List();
          map['firstTime'] = _catProvider.first_time;
          //-----------------------------------------//
          compute(loadAsterix, map).then((resultTransfer) {
            map = null;
            myFile = null;
            if (resultTransfer.status) {
              if(resultTransfer.cat10All!=null) {
                _catProvider.cat10All = resultTransfer.cat10All;
                resultTransfer.cat10All = null;
              }
              if(resultTransfer.catAll!=null) {
                _catProvider.catAll = resultTransfer.catAll;
                resultTransfer.catAll = null;
              }
              if(resultTransfer.cat21All!=null) {
                _catProvider.cat21All = resultTransfer.cat21All;
                resultTransfer = null;
              }
              // Need to sort the list into a stack of planes, cars, with respective trackNumber
              // as the distinctive field. Object will have a separate stack inside the list of stacks
              // TODO: ADD SORTING FOR DESCRIBED REQUIREMENT EARLIER...

              toast('File Loaded Successfully!');
            }
            EasyLoading.dismiss();
          }).whenComplete(() {});
        }
      } catch (e) {
        EasyLoading.dismiss();
        debugPrint(e.toString());
        toast('File Could not be Loaded!');
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
