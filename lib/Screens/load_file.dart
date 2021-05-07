import 'dart:typed_data';

import 'package:decereix/Helpers/cat10Helper.dart';
import 'package:decereix/Helpers/cat21Helper.dart';
import 'package:decereix/Helpers/helpDecode.dart';
import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/models/cat10.dart';
import 'package:decereix/models/cat21.dart';
import 'package:decereix/models/catall.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class load_file extends StatelessWidget {
  final Function onDataLoaded;
  const load_file({Key key, @required this.onDataLoaded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CatProvider _catProvider = Provider.of<CatProvider>(context, listen: true);

    Future<bool> loadAsterix() async {
      List<CAT10> cat10All = [];
      List<CAT21> cat21All = [];
      List<CATALL> catAll = [];
      // show a dialog to open a file
      Uint8List fileBytes;
      FilePickerCross.importFromStorage(
              fileExtension:
                  'ast' // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
              )
          .then((myFile) {
        // After picking file --> Read the file in Hex
        if (myFile != null) {
          EasyLoading.show(status: 'loading...').then((value) {
            // Chosen
            fileBytes = myFile.toUint8List();
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
              messageLength = (fileBytes[currPointer + 1] * 256) +
                  fileBytes[currPointer + 2];
              endPointer = currPointer + messageLength; // 0+31 = 31
              if (endPointer >= fileBytes.length) {
                messages.add(fileBytes.sublist(
                    currPointer)); // (currentMessageByte)-LastByteIncluded
                messagesBinary.add(fileBinary.sublist(currPointer));
              } else {
                messages
                    .add(fileBytes.sublist(currPointer, endPointer)); // O-30
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
              //messagesBinary[k] = buffer.toString();
              // For each message we are gonna convert it properly
              if (messages[k][0] == 10) {
                cat10 = new CAT10(
                    helpDecode, cat10helper, messages[k], k, messagesBinary[k]);
                cat10All.add(cat10);
                catAll
                    .add(new CATALL.fromCat10(cat10, _catProvider.first_time));
              } else if (messages[k][0] == 21) {
                cat21 = new CAT21(
                    helpDecode, cat21helper, messages[k], k, messagesBinary[k]);
                cat21All.add(cat21);
                catAll
                    .add(new CATALL.fromCat21(cat21, _catProvider.first_time));
              }
            }

            // With Provider store it globally
            if (cat10All != null) {
              if (cat10All.isNotEmpty) {
                _catProvider.cat10All = (cat10All);
              }
            }
            if (cat21All != null) {
              if (cat21All.isNotEmpty) {
                _catProvider.cat21All = (cat21All);
              }
            }
            if (catAll != null) {
              if (catAll.isNotEmpty) {
                _catProvider.catAll = (catAll);
              }
            }
            EasyLoading.dismiss(animation: true);
          });
        }
      }).catchError((onError) {
        //do something...
        debugPrint(onError);
        EasyLoading.dismiss(animation: true);
      });
    }

    return Container(
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
                loadAsterix().whenComplete(() => this.onDataLoaded(true));
              },
            ),
            Text("Load File"),
          ],
        ),
      ),
    );
  }
}
