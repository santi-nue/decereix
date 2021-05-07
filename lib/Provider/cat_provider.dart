import 'package:decereix/models/cat10.dart';
import 'package:decereix/models/cat21.dart';
import 'package:decereix/models/catall.dart';
import 'package:flutter/foundation.dart';

class CatProvider with ChangeNotifier {
  List<CAT10> _cat10All = [];

  List<CAT10> get cat10All => _cat10All;

  set cat10All(List<CAT10> cat10All) {
    _cat10All = cat10All;
    notifyListeners();
  }

  List<CAT21> _cat21All = [];

  List<CAT21> get cat21All => _cat21All;

  set cat21All(List<CAT21> cat21All) {
    _cat21All = cat21All;
    notifyListeners();
  }

  List<CATALL> _catAll = [];

  List<CATALL> get catAll => _catAll;

  set catAll(List<CATALL> catAll) {
    _catAll = catAll;
    notifyListeners();
  }

  int _first_time = 0;

  int get first_time => _first_time;

  set first_time(int first_time) {
    _first_time = first_time;
  }
}
