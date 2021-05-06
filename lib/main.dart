import 'dart:ffi';
import 'dart:typed_data';

import 'package:decereix/Helpers/cat10Helper.dart';
import 'package:decereix/Helpers/helpDecode.dart';
import 'package:decereix/models/cat21.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'Helpers/cat21Helper.dart';
import 'models/cat10.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'DECEREIX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    loadAsterix().whenComplete(() {
      setState(() {
        // This call to setState tells the Flutter framework that something has
        // changed in this State, which causes it to rerun the build method below
        // so that the display can reflect the updated values. If we changed
        // _counter without calling setState(), then the build method would not be
        // called again, and so nothing would appear to happen.
        _counter = _counter + 3;
      });
    });
  }

  Future<int> loadAsterix() async {
    // show a dialog to open a file
    Uint8List fileBytes;
    FilePickerCross.importFromStorage(
            fileExtension:
                'ast' // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
            )
        .then((myFile) {
      // After picking file --> Read the file in Hex
      if (myFile != null) {
        // Chosen
        fileBytes = myFile.toUint8List();
        // Translate Bytes to Binary String
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

        HelpDecode helpDecode = new HelpDecode();
        CAT10Helper cat10helper = new CAT10Helper();
        CAT21Helper cat21helper = new CAT21Helper();
        StringBuffer buffer = new StringBuffer();
        List<CAT10> cat10All = []; // creates an empty array of length 5
        List<CAT21> cat21All = []; // creates an empty array of length 5
        // Messages separated --> Now we have to convert them according to CAT 10 or CAT 21
        for (int k = 0; k < messages.length; k++) {
          //messagesBinary[k] = buffer.toString();
          // For each message we are gonna convert it properly
          if (messages[k][0] == 10) {
            CAT10 cat10 = new CAT10(
                helpDecode, cat10helper, messages[k], k, messagesBinary[k]);
            cat10All.add(cat10);
          } else if (messages[k][0] == 21) {
            CAT21 cat21 = new CAT21(
                helpDecode, cat21helper, messages[k], k, messagesBinary[k]);
            cat21All.add(cat21);
          }
        }
        String sd = "";
        setState(() {
          _counter = 999;
        });
      }
    }).catchError((onError) {
      //do something...
      debugPrint(onError);
    }).whenComplete(() {
      return 3;
    });
    String a = "";
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.98,
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox.expand(
                        child: CupertinoButton.filled(
                          child: Text('Load File'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox.expand(
                        child: CupertinoButton.filled(
                          child: Text('Cat 10'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox.expand(
                        child: CupertinoButton.filled(
                          child: Text('Cat 21'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox.expand(
                        child: CupertinoButton.filled(
                          child: Text('Cat All'),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox.expand(
                        child: CupertinoButton.filled(
                          child: Text('Map'),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CupertinoButton.filled(
                        child: Text('A Button'),
                        onPressed: () {},
                      ),
                      CupertinoButton.filled(
                        child: Text('A Button'),
                        onPressed: () {},
                      ),
                      CupertinoButton.filled(
                        child: Text('A Button'),
                        onPressed: () {},
                      ),
                      CupertinoButton.filled(
                        child: Text('A Button'),
                        onPressed: () {},
                      ),
                      CupertinoButton.filled(
                        child: Text('A Button'),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
