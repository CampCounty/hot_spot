import '../domain/fang_eintragen.dart';

import '../domain/profile.dart';

abstract class DatabaseRepository {
  List<Fang> getUserFaenge(Profile profile);
  void addFang(Fang newFang);
  List<Fang> getFaenge();
}
