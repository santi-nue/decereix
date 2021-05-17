import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/Screens/cat10_screen.dart';
import 'package:decereix/Screens/cat21_screen.dart';
import 'package:decereix/Screens/catall_screen.dart';
import 'package:decereix/Screens/loadfile_screen.dart';
import 'package:decereix/Screens/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:worker_manager/worker_manager.dart';

Future<void> main() async {
  await Executor().warmUp();

  /// [runApp] which is a Dart function to initialize the [Widget Tree]
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that [Other Widgets] including [MyApp]
    /// can use, while mocking the providers. Which means change the state inside it.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CatProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CatProvider _catProvider = Provider.of<CatProvider>(context, listen: true);
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DECERIX',
        builder: EasyLoading.init(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'DECERIX'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currPage = 0;

  void _changePage() {
    setState(() {
      _currPage = 1;
    });
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        this._currPage = 0;
                      });
                    },
                    icon: Icon(Icons.home, size: 30, color: Colors.white),
                    label: Text("HOME", overflow: TextOverflow.ellipsis),
                  ),
                ),
                Container(height: 15),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        this._currPage = 1;
                      });
                    },
                    icon: Icon(Icons.article_outlined,
                        size: 30, color: Colors.white),
                    label: Text("CAT 10", overflow: TextOverflow.ellipsis),
                  ),
                ),
                Container(height: 15),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        this._currPage = 2;
                      });
                    },
                    icon: Icon(Icons.article_outlined,
                        size: 30, color: Colors.white),
                    label: Text("CAT 21", overflow: TextOverflow.ellipsis),
                  ),
                ),
                Container(height: 15),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        this._currPage = 3;
                      });
                    },
                    icon: Icon(Icons.addchart, size: 30, color: Colors.white),
                    label: Text("CAT ALL", overflow: TextOverflow.ellipsis),
                  ),
                ),
                Container(height: 15),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        this._currPage = 4;
                      });
                    },
                    icon:
                        Icon(Icons.map_outlined, size: 40, color: Colors.white),
                    label: Text("MAP ", overflow: TextOverflow.ellipsis),
                  ),
                ),
                Container(height: 15),
              ],
            ),
          ),
          if (_currPage == 0) ...[
            Expanded(
              flex: 9,
              child: LoadfileScreen(),
            ),
          ] else if (_currPage == 1) ...[
            Expanded(
              flex: 9,
              child: Cat10Table(),
            ),
          ] else if (_currPage == 2) ...[
            Expanded(
              flex: 9,
              child: Cat21Table(),
            ),
          ] else if (_currPage == 3) ...[
            Expanded(
              flex: 9,
              child: CatAllTable(),
            ),
          ] else if (_currPage == 4) ...[
            Expanded(
              flex: 9,
              child: MapScreen(),
            ),
          ],
        ],
      ),
    );
  }
}
