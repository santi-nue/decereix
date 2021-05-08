import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
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
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class LoadfileScreen extends StatefulWidget {
  const LoadfileScreen({Key key}) : super(key: key);

  @override
  _LoadfileScreenState createState() => _LoadfileScreenState();
}

class _LoadfileScreenState extends State<LoadfileScreen> {
  bool _saving = false;
  bool _error = false;
  // Use Multithreading to read and decode the file,
  static Future<TransferCat> loadAsterix(Map<String,dynamic> mapVal) {
    Uint8List fileBytes = mapVal["fileBytes"];
    int firstTime = mapVal["firstTime"];
    List<CAT10> cat10All = [];
    List<CAT21> cat21All = [];
    List<CATALL> catAll = [];
    // show a dialog to open a file
    //-------------------RAW File to parse it in RAM-------------------//
    List<String> fileBinary =
    new List<String>.filled(fileBytes.length, "", growable: false);
    for (int i = 0; i < fileBytes.length; i++) {
      fileBinary[i] = fileBytes[i].toRadixString(2).padLeft(8, "0");
    }
    // Go over all of the packets and store them in a separate list of lists
    // First Octet Category

    // 2nd*256 + 3rd Octet = Length in Bytes
    //int messageCategory = fileBytes[0];
    int messageLength; // 2nd*256 + 3rd Octet
    List<Uint8List> messages = [];
    List<List<String>> messagesBinary = [];
    List<int> messagesLengths = [];
    // Also store as binary messages[currentMsg][Field].toRadixString(2).padLeft(8, "0")
    // Store messages from the fileBytes into packet size Blocks using messageLength
    int endPointer = messageLength;

    for (int currPointer = 0;
    (currPointer + 1) < fileBytes.length;
    currPointer += messageLength) {
      messageLength =
          (fileBytes[currPointer + 1] * 256) + fileBytes[currPointer + 2];
      endPointer = currPointer + messageLength; // 0+31 = 31
      if (endPointer >= fileBytes.length) {
        messages.add(fileBytes
            .sublist(currPointer)); // (currentMessageByte)-LastByteIncluded
        messagesBinary.add(fileBinary.sublist(currPointer));
      } else {
        messages.add(fileBytes.sublist(currPointer, endPointer)); // O-30
        messagesBinary.add(fileBinary.sublist(currPointer, endPointer));
      }
      messagesLengths.add(messageLength);
    }

    ///---------------------Binary to Human -------------------///
    HelpDecode helpDecode = new HelpDecode();
    CAT10Helper cat10helper = new CAT10Helper();
    CAT21Helper cat21helper = new CAT21Helper();
    CAT10 cat10;
    CAT21 cat21;
    // Messages separated --> Now we have to convert them according to CAT 10 or CAT 21
    for (int k = 0; k < messages.length; k++) {
      // For each message we are gonna convert it properly
      if (messages[k][0] == 10) {
        cat10 = new CAT10(
            helpDecode, cat10helper, messages[k], k, messagesBinary[k]);
        cat10All.add(cat10);
        catAll.add(new CATALL.fromCat10(cat10, firstTime ));
      } else if (messages[k][0] == 21) {
        cat21 = new CAT21(
            helpDecode, cat21helper, messages[k], k, messagesBinary[k]);
        cat21All.add(cat21);
        catAll.add(new CATALL.fromCat21(cat21, firstTime));
      }
    }
    TransferCat transferCat = new TransferCat();
    transferCat.catAll = catAll;
    transferCat.cat21All = cat21All;
    transferCat.cat10All = cat10All;
    return new Future.value(transferCat);
  }
  @override
  Widget build(BuildContext context) {
    CatProvider _catProvider = Provider.of<CatProvider>(context, listen: true);

   Future<void> loadFileAsync() async {
    await FilePickerCross.importFromStorage(fileExtension: 'ast').then((myFile) async {
        // After picking file --> Read the file in Hex
        if (myFile != null) {
          setState(() {
            this._saving = true;
          });
            Map<String, dynamic> map = {};
            map['fileBytes'] = myFile.toUint8List();
            map['firstTime'] = _catProvider.first_time;
            // Read
          await compute(loadAsterix,map).then((transferCat){
              if (transferCat.cat10All != null) {
                if (transferCat.cat10All.isNotEmpty) {
                  _catProvider.cat10All = (transferCat.cat10All);
                }
              }
              if (transferCat.cat21All != null) {
                if (transferCat.cat21All.isNotEmpty) {
                  _catProvider.cat21All = (transferCat.cat21All);
                }
              }
              if (transferCat.catAll != null) {
                if (transferCat.catAll.isNotEmpty) {
                  _catProvider.catAll = (transferCat.catAll);
                }
              }
              setState(() {
                this._saving = false;
                this._error = false;
              });
            }).catchError((onError) {
              debugPrint(onError.toString());
              setState(() {
                this._saving = false;
                this._error = true;
              });
          });
        }
      });
    }

    return LoadingOverlay(
        child:
     Center(
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
                  loadFileAsync().whenComplete((){
                    if(!this._error){
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        text: "Filed Loaded!",
                      );
                    }else{
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: "Couldn't load file, Error!",
                      );
                    }
                  });
                },
              ),
              Text("Load File"),
            ],
          ),
        ),
    ),
     ),isLoading: this._saving
    );
  }
}
