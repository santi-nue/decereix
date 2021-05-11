import 'package:decereix/models/cat10.dart';
import 'package:decereix/models/cat21.dart';
import 'package:decereix/models/catall.dart';
import 'package:decereix/models/trajectories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';

class CatProvider with ChangeNotifier {
  List<CAT10> cat10All = [];
  List<CAT21> cat21All = [];
  List<Trajectories> SMRTrajectories = [];
  List<Trajectories> MLATTrajectories = [];
  List<Trajectories> ADSBTrajectories = [];
  List<CATALL> catAll = [];

  int firstTime = 0;
  int endTime = 0;
}
