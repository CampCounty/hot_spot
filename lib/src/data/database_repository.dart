import 'package:hot_spot/src/features/overview/domain/fang_eintragen.dart';

import 'package:hot_spot/src/features/overview/domain/profile.dart';

abstract class DatabaseRepository {
  Future<List<Fang>> getUserFaenge(Profile profile);
  Future<void> addFang(Fang newFang);
  Future<List<Fang>> getFaenge();
  Future<List<String>> getFischArten();
}
