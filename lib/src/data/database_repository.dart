import '../features/overview/domain/fang_eintragen.dart';

import '../features/overview/domain/profile.dart';

abstract class DatabaseRepository {
  List<Fang> getUserFaenge(Profile profile);
  void addFang(Fang newFang);
  List<Fang> getFaenge();
}
