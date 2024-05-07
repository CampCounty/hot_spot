import 'package:hot_spot/src/features/overview/domain/fang_eintragen.dart';

import 'package:hot_spot/src/features/overview/domain/profile.dart';

abstract class DatabaseRepository {
  List<Fang> getUserFaenge(Profile profile);
  void addFang(Fang newFang);
  List<Fang> getFaenge();
}
