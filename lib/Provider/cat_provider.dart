import 'package:decereix/models/cat10.dart';
import 'package:decereix/models/cat21.dart';
import 'package:decereix/models/catall.dart';
import 'package:flutter/foundation.dart';

class CatProvider with ChangeNotifier {
  List<CAT10> cat10All = [];
  List<CAT21> cat21All = [];
  List<CATALL> catAll = [];
  int first_time = 0;
  void setCat10(List<CAT10> cat10All) {
    cat10All = cat10All;
    notifyListeners();
  }

  void setCat21(List<CAT21> cat21All) {
    cat21All = cat21All;
    notifyListeners();
  }

  void setCatAll(List<CATALL> catAll) {
    catAll = catAll;
    notifyListeners();
  }
}
