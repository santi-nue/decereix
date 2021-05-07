import 'package:decereix/models/cat10.dart';
import 'package:decereix/models/cat21.dart';
import 'package:decereix/models/catall.dart';

class TransferCat {
  List<CAT10> cat10All = [];
  List<CAT21> cat21All = [];
  List<CATALL> catAll = [];
  TransferCat();
  TransferCat.fromCats(
      List<CAT10> cat10All, List<CAT21> cat21All, List<CATALL> catAll) {
    this.cat10All = cat10All;
    this.catAll = catAll;
    this.cat21All = cat21All;
  }
}
